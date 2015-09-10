//
//  MJMySelfTableViewController.m
//  Encounter
//
//  Created by 李明军 on 26/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJMySelfTableViewController.h"
#import "MJConst.h"
#import "MJPersonCellModel.h"
#import "MJPersonLastTableViewCell.h"
#import "MJMyselfHeadTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MJPersonPhotoTableViewCell.h"
#import "MJCurrentMessageTableViewController.h"
#import "MJPhotoLibViewController.h"
#import "AppDelegate.h"


@interface MJMySelfTableViewController ()<MJMyselfHeadTableViewCellDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MJPersonPhotoTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

/** 数据源 */
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
/** urlArray */
@property (nonatomic,strong) NSMutableArray *urlArray;
/** nodataArray */
@property (nonatomic,strong) NSMutableArray     *nodataArray;
/**  */
@property (nonatomic,copy) NSString *bgImgPath;
/**  */
@property (nonatomic,strong) UIImageView *bgImgV;
/**  */
@property (nonatomic,strong) MJMyselfHeadTableViewCell *headCell;
/**  */
@property (nonatomic,strong) UITableView *tableView;
/** 个人资料请求 */
@property (nonatomic,strong) AFHTTPRequestOperationManager *messageRequestManager;
/** 相册资料请求 */
@property (nonatomic,strong) AFHTTPRequestOperationManager *photoRequestManager;


@end

@implementation MJMySelfTableViewController



- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray)
    {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)urlArray
{
    if (!_urlArray)
    {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (NSMutableArray *)nodataArray
{
    if (!_nodataArray) {
        _nodataArray = [NSMutableArray array];
        NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
        [headDic setObject:@""                                      forKey:personInfoResultDicHeadimg];
        [headDic setObject:@""                                      forKey:personInfoResultDicSex];
        [headDic setObject:@""                                      forKey:personInfoResultDicNickname];
        [headDic setObject:@"网络不给力"                              forKey:personInfoResultDicMotto];
        [headDic setObject:@(0)                                     forKey:@"personInfoResultDicnotReadCount"];
        [headDic setObject:@""                                      forKey:personInfoResultDicBackImg];
        [_nodataArray addObject:headDic];
        
    }
    return _nodataArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  设置tabbarItem选中图标
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"bottom_my_s"]];
    
    UITableView *tabl = [[UITableView alloc]init];
    tabl.delegate = self;
    tabl.dataSource = self;
    tabl.frame = CGRectMake(0,0, systemSize.width, systemSize.height + 20);
    
    [self.view addSubview:tabl];
    self.tableView = tabl;
    //        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    //        {
    //            CGRect rect = self.tableView.frame;
    //            rect.origin.y -= 20;
    //            self.tableView.frame = rect;
    //        }
    //        [self.tableV addHeaderWithTarget:self action:@selector(headerRefreshedTo)];
    [self.view addSubview:self.tableView];

    [MJNotifCenter addObserver:self
                      selector:@selector(noreadCountNotification:)
                          name:notificationGetNoreadCount
                        object:nil];
    
//    [self requestMessageWithUserId:userId];
//     NSString *userId = [MJUserDefault objectForKey:userDefaultUserId];
    
//    [self.tableView reloadData];
    //  为背景图添加点击事件
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(changeHeadBackgroundImg)];
//    self.headBackGroudImgView.userInteractionEnabled = YES;
//    [self.headBackGroudImgView addGestureRecognizer:tap];
    
    
}

/**
 *  隐藏导航条
 */
- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
  
    NSString *userId = [MJUserDefault objectForKey:userDefaultUserId];
    
    
    [self requestPhotoLibWithUserId:userId];
    [self requestMessageWithUserId:userId];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.navigationItem setTitle:@"返回"];
    [[self.messageRequestManager operationQueue] cancelAllOperations];
    [[self.photoRequestManager operationQueue] cancelAllOperations];
}

- (void)viewDidAppear:(BOOL)animated
{
    
   

}

#pragma mark - 新消息通知

/**
 *  新消息通知
 *
 *  @param notification
 */
- (void)noreadCountNotification:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSInteger notreadCount = [[dic objectForKey:notificationNoreadCountKey] integerValue];
    if (notreadCount > 0)
    {
        AppDelegate *appd               = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tabbarConTr = (UITabBarController *)[[appd window] rootViewController];
        UITabBarItem *item              = [[[tabbarConTr tabBar] items] objectAtIndex:2];
        [item setBadgeValue:[[NSString alloc]initWithFormat:@"%d",notreadCount]];
    }
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSourceArray.count > 0)
    {
        if (self.urlArray.count > 0)
        {
            return self.dataSourceArray.count + 1;
        }
        else
        {
            return self.dataSourceArray.count;
        }
    }
    else
    {
        return self.nodataArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSourceArray.count > 0) {
        if (indexPath.row == 0)
        {
            MJMyselfHeadTableViewCell *headCell = [MJMyselfHeadTableViewCell myselfHeadTVCWithTableView:tableView];
            headCell.delegate = self;
            NSDictionary *dic = self.dataSourceArray[0];
            headCell.dic = dic;
            self.headCell = headCell;
            
            return headCell;
        }
        else
        {
            if (self.urlArray.count > 0)
            {
                if (indexPath.row == 1)
                {
                    NSDictionary *dic = self.dataSourceArray[0];
                    MJPersonPhotoTableViewCell *personCell  = [MJPersonPhotoTableViewCell photoTableViewCellWithTableView:tableView];
                    personCell.photoUrlStrArray             = self.urlArray;
                    NSString *userId = [MJUserDefault objectForKey:userDefaultUserId];
                    personCell.userid                       = userId;
                    
                    personCell.dic                          = dic;
                    personCell.delegate                     = self;
                    return personCell;
                }
                else
                {
                    MJPersonLastTableViewCell *lastedCell   = [MJPersonLastTableViewCell latestTableViewCellWithTableView:tableView];
                    MJPersonCellModel *model = self.dataSourceArray[indexPath.row - 1];
                    lastedCell.personCellModel = model;
                    lastedCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return lastedCell;
                }
            }
            else
            {
                MJPersonLastTableViewCell *lastedCell   = [MJPersonLastTableViewCell latestTableViewCellWithTableView:tableView];
                if (self.dataSourceArray.count > indexPath.row) {
                    MJPersonCellModel *model = self.dataSourceArray[indexPath.row];
                    lastedCell.personCellModel = model;
                }
                
                
                return lastedCell;
            }
        }
        
    }
    else
    {
        MJMyselfHeadTableViewCell *headCell = [MJMyselfHeadTableViewCell myselfHeadTVCWithTableView:tableView];
        //            headCell.delegate = self;
        NSDictionary *dic = self.nodataArray[0];
        headCell.dic = dic;
        
        return headCell;
        
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 250;
    }
    else
    {
        if (self.urlArray.count > 0)
        {
            if (indexPath.row == 1)
            {
                return 80;
            }
            else
            {
                return 40;
            }
        }
        else
        {
            return 40;
        }
    }

}



#pragma mark - 头部代理

/**
 *  背景点击代理
 *
 *  @param myselfTVC
 *  @param bgImgV
 */
- (void)myselfHeadTVC:(MJMyselfHeadTableViewCell *)myselfTVC didClickBgImgV:(UIImageView *)bgImgV
{

    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择背景图片"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"从相册选取",@"从相机获得", nil];
    [actionSheet showInView:[[[UIApplication sharedApplication] delegate] window]];
    
}

/**
 *  新消息点击代理
 *
 *  @param myselfTVC
 *  @param currentMessageBtn
 */
- (void)myselfHeadTVC:(MJMyselfHeadTableViewCell *)myselfTVC didClickCurrentMessageBtn:(UIButton *)currentMessageBtn
{
    MJLog(@"点击了新消息按钮");
    MJCurrentMessageTableViewController *currentMessageTVC = [[MJCurrentMessageTableViewController alloc]init];
    NSString *userId = [MJUserDefault objectForKey:userDefaultUserId];
    currentMessageTVC.userid = userId;
    [self.navigationController pushViewController:currentMessageTVC animated:YES];
}

/**
 *  点击相册cell代理
 *
 *  @param personPhotoTVC
 *  @param btn
 */
- (void)personPhotoTVC:(MJPersonPhotoTableViewCell *)personPhotoTVC didClickBtn:(UIButton *)btn withUserId:(NSString *)userid withDic:(NSDictionary *)dic
{
    MJPhotoLibViewController *photoLibVC = [[MJPhotoLibViewController alloc]init];
    photoLibVC.dic = self.dataSourceArray[0];
    photoLibVC.inSign = kMJPhotoLibViewControllerSignSelf;
    NSString *userId = [MJUserDefault objectForKey:userDefaultUserId];
    photoLibVC.userId = userId;
    [self.navigationController pushViewController:photoLibVC animated:YES];
}


#pragma mark - 相册
//- (void)actionSheetDidSelectedImg:(UIImage *)img
//{
//    [self.bgImgV setImage:img];
//}

#pragma mark - 代理方法
/**
 *  1.0 头像点击底部弹窗代理方法
 *
 *  @param actionSheet 弹窗
 *  @param buttonIndex 索引  0:从相册选取 1:从相机选取
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self selectImgFromPhotoLib];
            MJLog(@"从相册选举");
            break;
        }
        case 1:
        {
            [self selectImgFromCamera];
            MJLog(@"从相机选举");
            break;
        }
        default:
            break;
    }
}

/**
 *  2.0 当完成图片选择或拍摄时，图片选择器代理方法
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
    [self.bgImgV setImage:img];
//    self.headCell.bgImg = img;
    //  返回资料页
    [picker dismissViewControllerAnimated:YES
                               completion:^{
//                                   NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                                   [dic setObject:img forKey:@"bgImg"];
//                                   [MJNotifCenter postNotificationName:@"bgImgNotification" object:nil userInfo:dic];
                                   NSString *userId = [MJUserDefault objectForKey:userDefaultUserId];
                                   [self requestMessageWithUserId:userId];
                               }];
    self.bgImgPath = [UIImage saveImgInDocumentWithImg:img WithName:@"saveBackImg"];
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@V2/UserHandler.ashx?",SERVERADDRESS];
    
    NSString *url = [NSString stringWithFormat:@"%@M=UpdateBackground",urlStr];
    //    NSString *utfStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    MJLog(@"%@",url);
    ASIFormDataRequest *re = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    __weak ASIFormDataRequest *imageRequest = re;
    
    //  请求之前的提示
    [MMProgressHUD showWithTitle:@"请稍等" status:@"正在上传图片" cancelBlock:^{
        [MMProgressHUD dismiss];
    }];
    
    //  设置请求数据体
    [imageRequest appendPostDataFromFile:self.bgImgPath];
    [imageRequest setRequestMethod:@"POST"];
    
    //  发送请求
    [imageRequest startAsynchronous];
    
    //  请求完成回调
    [imageRequest setCompletionBlock:^{
        [MMProgressHUD dismiss];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[imageRequest responseData] options:kNilOptions error:nil];
        
        if ([[dic objectForKey:@"retCode"]intValue]==1) {
            [MMProgressHUD dismissWithSuccess:@"上传成功"];
            [MJUserDefault setObject:[dic objectForKey:@"retData"] forKey:@"bgImgSend"];
            MJLog(@"%@",dic);
            
        }else{
            [MMProgressHUD dismissWithError:[dic objectForKey:@"retMsg"] afterDelay:3];
            MJLog(@"%@",[dic objectForKey:@"retMsg"]);
        }
        
    }];
    [imageRequest setFailedBlock:^{
        [MMProgressHUD dismissWithError:connectionErrorMessage afterDelay:1.5];
    }];
    
    
    
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


#pragma mark - 请求数据
/**
 *  获取用户信息
 *
 *  @param userId
 */
- (void)requestMessageWithUserId:(NSString *)userId
{
    [self.dataSourceArray removeAllObjects];
    //从后台服务器获取用户信息
    self.messageRequestManager              = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params             = [[NSMutableDictionary alloc]init];
    [params setObject:@"GetUserInfo" forKey:@"M"];
    [params setObject:userId forKey:@"Userid"];
    [self.messageRequestManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic                   = responseObject;
        MJLog(@"responseObject%@",dic);
        NSString *statuCode                 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"IsSuccess"]];
        if ([statuCode isEqualToString:@"1"]) {
            NSDictionary *personInfor;
            if ([[dic objectForKey:@"Result"] count]>0) {
                NSDictionary *resultDic                    = [dic objectForKey:@"Result"][0];
                NSMutableDictionary *headDic            = [NSMutableDictionary dictionary];
                MJLog(@"%@",resultDic);
                
                NSString *headStr                       = [resultDic objectForKey:@"Headimg"];
                NSString *sexStr                        = [resultDic objectForKey:@"Sex"];
                NSString *nickNameStr                   = [resultDic objectForKey:@"Nickname"];
                NSString *mottoStr                      = [resultDic objectForKey:@"Motto"];
                NSInteger notReadCount                 = [[resultDic objectForKey:@"NotReadCount"] integerValue];
                NSString *bgImgUrlStr                   = [resultDic objectForKey:@"BackgroundImage"];
                
                
                [headDic setObject:headStr                                  forKey:personInfoResultDicHeadimg];
                [headDic setObject:sexStr                                   forKey:personInfoResultDicSex];
                [headDic setObject:nickNameStr                              forKey:personInfoResultDicNickname];
                [headDic setObject:mottoStr                                 forKey:personInfoResultDicMotto];
                [headDic setObject:@(notReadCount)                          forKey:@"personInfoResultDicnotReadCount"];
                [headDic setObject:bgImgUrlStr                              forKey:personInfoResultDicBackImg];
                if (notReadCount == 0) {
                    AppDelegate *appd               = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    UITabBarController *tabbarConTr = (UITabBarController *)[[appd window] rootViewController];
                    UITabBarItem *item              = [[[tabbarConTr tabBar] items] objectAtIndex:2];
                    [item setBadgeValue:nil];

                }
                else
                {
                    AppDelegate *appd               = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    UITabBarController *tabbarConTr = (UITabBarController *)[[appd window] rootViewController];
                    UITabBarItem *item              = [[[tabbarConTr tabBar] items] objectAtIndex:2];
                    [item setBadgeValue:[[NSString alloc]initWithFormat:@"%d",notReadCount]];
                }
                
                [self.dataSourceArray addObject:headDic];
                [self addModelToArrayWithName:@"个人资料"        content:@"  "];
//                [self addModelToArrayWithName:@"头像url:"       content:[resultDic  objectForKey:@"Headimg"]];
                [self addModelToArrayWithName:@"昵称："          content:[resultDic  objectForKey:@"Nickname"]];
                NSInteger sexNum = [[resultDic  objectForKey:@"Sex"] integerValue];
                if (sexNum == 0) {
                    [self addModelToArrayWithName:@"性别："          content:@"女"];
                }else
                {
                    [self addModelToArrayWithName:@"性别："          content:@"男"];
                }
                
                [self addModelToArrayWithName:@"情感状态："      content:[resultDic  objectForKey:@"Personinfo"]];
                [self addModelToArrayWithName:@"生日："         content:[resultDic   objectForKey:@"Brithday"]];
                [self addModelToArrayWithName:@"职业："         content:[resultDic   objectForKey:@"Vocation"]];
                [self addModelToArrayWithName:@"常出没地："      content:[resultDic   objectForKey:@"Haunt"]];
                [self addModelToArrayWithName:@"兴趣爱好："      content:[resultDic   objectForKey:@"Favorite"]];
                [self addModelToArrayWithName:@"个性签名："      content:[resultDic   objectForKey:@"Motto"]];
                [self.tableView reloadData];
                //                [self.tableView reloadData];
            }else{
                
                personInfor                 = [dic objectForKey:@"Result"];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
    
}

/**
 *  根据是否有值将模型加入数组
 *
 *  @param titleStr 标题
 *  @param content  内容
 */
- (void)addModelToArrayWithName:(NSString *)titleStr content:(NSString *)content
{
    if (![content isEqualToString:@""]) {
        MJPersonCellModel *personModel = [MJPersonCellModel personCellModel];
        personModel.title               = titleStr;
        personModel.content             = content;
        [self.dataSourceArray addObject:personModel];
        MJLog(@"%lu",(unsigned long)self.dataSourceArray.count);
    }else
    {
        return;
    }
}


/**
 *  请求相册
 *
 *  @param userId userId
 *
 *  @return 返回数组
 */
- (void)requestPhotoLibWithUserId:(NSString *)userId
{
    [self.urlArray removeAllObjects];
    self.photoRequestManager    = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"GetUserPhoto"   forKey:requestKey];
    [params setObject:userId            forKey:@"Userid"];
    if (self.urlArray.count > 0) {
        [self.urlArray removeAllObjects];
    }
    
    [self.photoRequestManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
         NSDictionary *dic = responseObject;
         MJLog(@"返回结果\n%@",dic);
         MJLog(@"连接服务器成功");
         
         if ([[dic objectForKey:@"IsSuccess"] boolValue])
         {
             NSArray *resultArray = [dic objectForKey:@"Result"];
             if (resultArray > 0)
             {
                 for (NSDictionary *urlDic in resultArray)
                 {
                     NSString *urlStr = [urlDic objectForKey:@"contents"];
                     [self.urlArray addObject:urlStr];
                     
                 }
                 [self.tableView reloadData];
             }else
             {

                 MJLog(@"相册为空");
             }
             
         }else
         {
             MJLog(@"请求失败%@",[dic objectForKey:@"Message"]);
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         MJLog(@"连接服务器失败%@",error);
     }];
    
}


- (void)dealloc
{
    [MJNotifCenter removeObserver:self];
}

@end
