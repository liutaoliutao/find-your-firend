//
//  RCDChatViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//

#import "RCDChatViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDChatViewController.h"
#import "MJConst.h"
#import "MJMyMessageTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

//#import "RCDDiscussGroupSettingViewController.h"
//#import "RCDRoomSettingViewController.h"
//#import "RCDPrivateSettingViewController.h"

@interface RCDChatViewController ()<RCPluginBoardViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation RCDChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  设置头像样式
    [self.pluginBoardView removeItemAtIndex:3];
    [self.pluginBoardView removeItemAtIndex:2];
    [self.pluginBoardView removeItemAtIndex:1];
    [self.pluginBoardView removeItemAtIndex:0];
    [self.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"actionbar_picture_icon"] title:@"照片" atIndex:0];
    [self.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"actionbar_camera_icon"] title:@"拍照" atIndex:1];
    
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RCChatSessionInputBarControlStyle8];
    //  1. 添加返回按钮
    UIButton *btn = [[UIButton alloc] init];
    //  1.1. 配置返回按钮
    [btn setImage:[UIImage imageNamed:@"top_return"]        forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"top_return_s"]      forState:UIControlStateHighlighted];
    [btn setTitle:@"返回"                                    forState:UIControlStateNormal];
    [btn setTitleColor:systemColor                          forState:UIControlStateNormal];
    btn.frame                   = CGRectMake(0, 0, 60, 30);
    //  1.2. 设置返回按钮点击事件
    [btn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    //  1.3. 添加返回按钮
    UIBarButtonItem *leftItem   = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //  2. 添加返回按钮
    UIButton *rightBtn = [[UIButton alloc] init];
    //  2.1. 配置返回按钮
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"user_info"]        forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"user_info_s"]      forState:UIControlStateHighlighted];
    rightBtn.frame                   = CGRectMake(0, 0, 25, 25);
    //  2.2. 设置返回按钮点击事件
    [rightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    //  2.3. 添加返回按钮
    UIBarButtonItem *rightItem      = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self setMessageAvatarStyle:RCUserAvatarCycle];
}

/**=========================================================*/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
//    NSArray *array = [self.pluginBoardView allItems];
//   
//    for (NSInteger i = 0; i < array.count ; i ++) {
//        MJLog(@"%@",array[i]);
//    }
    
    

//    [self.pluginBoardView removeItemAtIndex:3];
//    [self.pluginBoardView removeItemAtIndex:2];
    
}
- (void)setName:(NSString *)name
{
    _name = name;
    self.navigationItem.title = _name;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

/**=========================================================*/

#pragma mark - 导航条返回按钮
/**
 *  返回按钮点击事件返回上一页
 *
 *  @param sender
 */
- (void)leftBarButtonItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonItemPressed:(id)sender
{
    MJMyMessageTableViewController *userInfoTVC = [[MJMyMessageTableViewController alloc] init];
    userInfoTVC.userId = self.targetId;
    userInfoTVC.inIdStr = kMJMyMessageTableViewControllerInIdStrRongYun;
    [self.navigationController pushViewController:userInfoTVC animated:YES];
}

/***********如何自定义面板功能***********************
 自定义面板功能首先要继承RCConversationViewController，如现在所在的这个文件。
 然后在viewDidLoad函数的super函数之后去编辑按钮：
 插入到指定位置的方法如下：
 [self.pluginBoardView insertItemWithImage:imagePic
                                     title:title
                                   atIndex:0
                                       tag:101];
 或添加到最后的：
 [self.pluginBoardView insertItemWithImage:imagePic
                                     title:title
                                       tag:101];
 删除指定位置的方法：
 [self.pluginBoardView removeItemAtIndex:0];
 删除指定标签的方法：
 [self.pluginBoardView removeItemWithTag:101];
 删除所有：
 [self.pluginBoardView removeAllItems];
 更换现有扩展项的图标和标题:
 [self.pluginBoardView updateItemAtIndex:0 image:newImage title:newTitle];
 或者根据tag来更换
 [self.pluginBoardView updateItemWithTag:101 image:newImage title:newTitle];
 以上所有的接口都在RCPluginBoardView.h可以查到。
 
 当编辑完扩展功能后，下一步就是要实现对扩展功能事件的处理，放开被注掉的函数
 pluginBoardView:clickedItemWithTag:
 在super之后加上自己的处理。
 
 */



/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model;
{
    [super presentImagePreviewController:model];
  RCImagePreviewController *_imagePreviewVC =
      [[RCImagePreviewController alloc] init];
  _imagePreviewVC.messageModel = model;
  _imagePreviewVC.title = @"图片预览";

  UINavigationController *nav = [[UINavigationController alloc]
      initWithRootViewController:_imagePreviewVC];

  [self presentViewController:nav animated:YES completion:nil];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model {
}

/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
  __weak typeof(&*self) __weakself = self;
  int count = [[RCIMClient sharedClient] getUnreadCount:@[
    @(ConversationType_PRIVATE),
    @(ConversationType_DISCUSSION),
    @(ConversationType_APPSERVICE),
    @(ConversationType_PUBLICSERVICE),
    @(ConversationType_GROUP)
  ]];
  dispatch_async(dispatch_get_main_queue(), ^{
      NSString *backString = nil;
    if (count > 0 && count < 1000) {
      backString = [NSString stringWithFormat:@"返回(%d)", count];
    } else if (count >= 1000) {
      backString = @"返回(...)";
    } else {
      backString = @"返回";
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 67, 23);
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
    backImg.frame = CGRectMake(-10, 0, 22, 22);
    [backBtn addSubview:backImg];
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 65, 22)];
    backText.text = backString;//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
    backText.font = [UIFont systemFontOfSize:15];
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:[UIColor whiteColor]];
    [backBtn addSubview:backText];
    [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [__weakself.navigationItem setLeftBarButtonItem:leftButton];
  });
}

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage
{
    //保存图片
    UIImage *image = newImage;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

////左滑删除
//-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    //RCConversationModel *model = self.conversationListDataSource[indexPath.row];
//    //[_myDataSource removeObject:model];
//    [self.conversationDataRepository removeObjectAtIndex:indexPath.row];
//    
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

//- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
//    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
//    switch (tag) {
//        case 101: {
//            //这里加你自己的事件处理
//        } break;
//        default:
//            break;
//    }
//}

/**
 *  点击头像事件
 *
 *  @param userId 用户的ID
 */
- (void)didTapCellPortrait:(NSString *)userId
{
    MJMyMessageTableViewController *userInfoTVC = [[MJMyMessageTableViewController alloc] init];
    userInfoTVC.userId = userId;
    userInfoTVC.inIdStr = kMJMyMessageTableViewControllerInIdStrRongYun;
    [self.navigationController pushViewController:userInfoTVC animated:YES];
}

 /**
   *  点击事件
   *
   *  @param pluginBoardView 功能模板
   *  @param index           索引
   */
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
             MJLog(@"点击了扩展-相册");
            [self selectImgFromPhotoLib];
            break;
        }
        case 1:
        {
             MJLog(@"点击了扩展-相机");
            [self selectImgFromCamera];
            break;
        }
        default:
            break;
    }
}


/**
 *  当完成图片选择或拍摄时，图片选择器代理方法
 *
 *  @param picker 图片选择器
 *  @param info   图片信息
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MJLog(@"当完成图片选择或拍摄时%@",info);
    //  从字典中取出图片
    UIImage *img       = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //  将图片设置位头像
//    self.userSelectedPhotoImgV.hidden = NO;
//    [self.userSelectedPhotoImgV setImage:img];
    //  返回资料页
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
                                   NSString *targe = self.conversation.targetId;
                                   RCImageMessage *imgMessage = [RCImageMessage messageWithImage:img];
                                   [[RCIMClient sharedClient] sendImageMessage:ConversationType_PRIVATE targetId:targe content:imgMessage pushContent:@"" progress:^(int nProgress, long messageId) {
                                       
                                   } sucess:^(long messageId) {
                                       MJLog(@"发送成功");
                                       [self saveNewPhotoToLocalSystemAfterSendingSuccess:img];
                                   } error:^(RCErrorCode errorCode, long messageId) {
                                       MJLog(@"发送失败");
                                   }];
                                   
                               }];
    
//    self.imgPathStr = [UIImage saveImgInDocumentWithImg:img WithName:@"selectedImg"];
    
}


/*------------------------------------------------------------------------------------------------------------------*/

#pragma mark - 选取图片方法

/**
 *  1.0 从相机获得图片
 */
- (void)selectImgFromCamera
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        MJLog(@"支持摄像");
        //  1.1 实例化摄像头
        UIImagePickerController *cameraPickerC = [[UIImagePickerController alloc]init];
        cameraPickerC.sourceType               = UIImagePickerControllerSourceTypeCamera;
        cameraPickerC.allowsEditing            = YES;
        cameraPickerC.delegate                 = self;
        
        AVAuthorizationStatus status           = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        //  1.2 弹出摄像头
        [self currentCameraStatusWithStatus:status block:^{
            [self presentViewController:cameraPickerC animated:YES completion:^{
            }];
        }];
        
    }
    else;
    {
        MJLog(@"不支持摄像");
//        [self setAlertWithMessage:@"不支持摄像"];
    }
    
}

/**
 *  2.0 从相册选取
 */
- (void)selectImgFromPhotoLib
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        MJLog(@"支持相册");
        //  2.1 实例化相册
        UIImagePickerController *photLibPickerC = [[UIImagePickerController alloc]init];
        photLibPickerC.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
        photLibPickerC.allowsEditing            = YES;
        photLibPickerC.delegate                 = self;
        //  版本控制，若为iphone 6 plus以下，直接获取相册
        //  2.2 获取用户权限状态
        ALAuthorizationStatus status            = [ALAssetsLibrary authorizationStatus];
        //  2.3 根据状态做出反应
        [self currentPhoteLibStatusWithStatus:status block:^{
            //  2.3.1 当权限开放，打开相册
            [self presentViewController:photLibPickerC animated:YES completion:^{
            }];
        }];
    }
    else
    {
        MJLog(@"不支持相册");
    }
}

/*------------------------------------------------------------------------------------------------------------------*/

#pragma mark - 判断当前权限状态

/**
 *  1.0 判断当前相册权限状态
 *
 *  @param status 权限状态
 *                ALAuthorizationStatusNotDetermined = 0, 用户尚未做出了选择这个应用程序的问候
 *                ALAuthorizationStatusRestricted,        此应用程序没有被授权访问的照片数据。可能是家长控制权限。
 *                ALAuthorizationStatusDenied,            用户已经明确否认了这一照片数据的应用程序访问.
 *                ALAuthorizationStatusAuthorized         用户已授权应用访问照片数据.
 *  @param block  用户已授权后执行的操作
 */
- (void)currentPhoteLibStatusWithStatus:(ALAuthorizationStatus) status block:(void(^)()) block
{
    switch (status)
    {
        case ALAuthorizationStatusNotDetermined:
        {
            [self setAlertWithMessage:MJPhotoLibNotDetermined];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                block();
            });
            break;
        }
        case ALAuthorizationStatusRestricted:
        {
            [self setAlertWithMessage:MJPhotoLibRestricted];
            break;
        }
        case ALAuthorizationStatusDenied:
        {
            [self setAlertWithMessage:MJPhotoLibStatusDenied];
            break;
        }
        case ALAuthorizationStatusAuthorized:
        {
            block();
            break;
        }
        default:
            break;
    }
    
}


/**
 *  2.0 判断当前相机权限状态
 *
 *  @param status 权限状态
 *                AVAuthorizationStatusNotDetermined = 0, 用户尚未做出了选择这个应用程序的问候
 *                AVAuthorizationStatusRestricted,        此应用程序没有被授权访问的相机。可能是家长控制权限。
 *                AVAuthorizationStatusDenied,            用户已经明确否认了这一相机的应用程序访问.
 *                AVAuthorizationStatusAuthorized         用户已授权应用访问相机.
 *  @param block  用户已授权后执行的操作
 */
- (void)currentCameraStatusWithStatus:(AVAuthorizationStatus) status block:(void(^)()) block
{
    switch (status)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            [self setAlertWithMessage:MJCameraNotDetermined];
            block();
            break;
        }
        case AVAuthorizationStatusRestricted:
        {
            [self setAlertWithMessage:MJCameraRestricted];
            break;
        }
        case AVAuthorizationStatusDenied:
        {
            [self setAlertWithMessage:MJCameraStatusDenied];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            block();
            break;
        }
        default:
            break;
    }
    
}

/*-----------------------------------------------------------------------------------------------*/
#pragma mark - 用户权限弹窗

/**
 *  用户权限弹窗
 *
 *  @param showMessageStr 用户权限限制消息
 */
- (void)setAlertWithMessage:(NSString *) showMessageStr
{
    [[[UIAlertView alloc]initWithTitle:@"警告"
                               message:showMessageStr
                              delegate:self
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil] show];
}





@end
