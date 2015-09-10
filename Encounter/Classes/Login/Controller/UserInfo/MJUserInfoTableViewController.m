//
//  MJUserInfoTableViewController.m
//  Encounter
//
//  Created by 李明军 on 21/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#define userInfoFinished @"V2_Complete"


#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "MJUserInfoTableViewController.h"
#import "MJConst.h"



@interface MJUserInfoTableViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

typedef enum{
    kUserInfoTVCSexSelectedBtnTagMan = 100,
    kUserInfoTVCSexSelectedBtnTagWoman
}kUserInfoTVCSexSelectedBtnTag;



#pragma mark - 同用户交互控件
/** 性别女选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton       *womanBtn;
/** 性别男选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton       *manBtn;
/** 名字文本输入框 */
@property (weak, nonatomic) IBOutlet UITextField    *nameTextField;
/** 生日文本输入框 */
@property (weak, nonatomic) IBOutlet UITextField    *birthdayTextField;
/** 生日日期选择器 */
@property (weak, nonatomic) IBOutlet UIDatePicker   *birthdaySelectedDatePicker;
/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView    *headImgView;
/** 图片路径 */
@property (nonatomic,copy) NSString                 *userHeadImgFilePath;


#pragma mark - 同服务器交互控件
/** 完成按钮 */
@property (nonatomic,strong) UIBarButtonItem *fifnishedBtnItem;

/** 头像图片 */
@property (nonatomic,strong) UIImage *headImg;

@end

/*------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------声明实现分界线------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------*/

@implementation MJUserInfoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  1.0 设置导航条
    [self setNavigationBar];
    
    //  2.0 设置tag
    [self setTag];
    
    //  3.0 监听文本输入框值改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    //  4.0 添加图片点击事件
    UITapGestureRecognizer *headImgTagGR    = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(headImgViewClick:)];
    self.headImgView.userInteractionEnabled = YES;
    [self.headImgView addGestureRecognizer:headImgTagGR];
    
    //  5.0 设置文本框代理
    self.nameTextField.delegate = self;
 }

/**
 *  设置导航条不隐藏
 */
- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}


/*------------------------------------------------------------------------------------------------------------------*/

#pragma mark - 界面加载时设置

/**
 *  1.0 设置导航条
 */
- (void)setNavigationBar
{
    //  1.1 设置右边完成导航item
    self.fifnishedBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(finishedBarButtonClick)];
    self.fifnishedBtnItem.enabled = NO;
    //  1.2 设置左边导航按钮，---隐藏默认返回按钮
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:nil
                                                                   action:nil];
    //  1.3 设置title
    [self.navigationItem setTitle:@"完善基本资料"];
    self.navigationItem.rightBarButtonItem = self.fifnishedBtnItem;
    self.navigationItem.leftBarButtonItem  = leftBtnItem;
}

/**
 *  2.0 设置tag
 */
- (void)setTag
{
    self.manBtn.tag   = kUserInfoTVCSexSelectedBtnTagMan;
    self.womanBtn.tag = kUserInfoTVCSexSelectedBtnTagWoman;
}

/*------------------------------------------------------------------------------------------------------------------*/

#pragma mark - 当文本框内容变更通知方法
/**
 *  当文本框内容变更通知方法
 */
- (void)textFieldChange
{
    NSString *nameStr = [self.nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([nameStr isEqualToString:@""] || [self.birthdayTextField.text isEqualToString:@""])
    {
        self.fifnishedBtnItem.enabled = NO;
    }
    else
    {
        self.fifnishedBtnItem.enabled = YES;
    }
}

/*------------------------------------------------------------------------------------------------------------------*/

#pragma mark - 日期选择器选择时间事件
/**
 *  日期选择器值改变
 *
 *  @param sender 日期选择器
 */
- (IBAction)birthdayPickerdidValueChange:(UIDatePicker *)sender
{
    [self.view endEditing:YES];
    //  1.0 设置日期显示格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat       = MJDateFormat;
    NSString *birthdayStr          = [dateFormatter stringFromDate:sender.date];
    [self.birthdayTextField setText:birthdayStr];
    
    //  2.0 因无法监听到birthdayTextField改变，重复调用一次方法，判断完成按钮是否可用
    [self textFieldChange];
    MJLog(@"选择的生日为%@",birthdayStr);
}

/*------------------------------------------------------------------------------------------------------------------*/

#pragma mark - 按钮点击事件

/**
 *  1.0 导航条右边完成按钮点击事件
 */
- (void)finishedBarButtonClick
{
    [self.view endEditing:YES];
    [self finishUserInfoRequest];
    
    MJLog(@"点击了完成");
}

/**
 *  2.0 设置性别选择按钮点击事件
 *
 *  @param sender 点击的按钮
 */
- (IBAction)sexSelectedBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    switch (sender.tag)
    {
        case kUserInfoTVCSexSelectedBtnTagMan:
        {
            MJLog(@"点击了男");
            self.manBtn.selected     = YES;
            self.womanBtn.selected   = NO;
            break;
        }
        case kUserInfoTVCSexSelectedBtnTagWoman:
        {
            MJLog(@"点击了女");
            self.manBtn.selected     = NO;
            self.womanBtn.selected   = YES;
            break;
        }
        default:
            break;
    }
}

/**
 *  3.0 监听头像图片点击事件
 *
 *  @param headImgView 头像view
 */
- (void)headImgViewClick:(UIImageView *)headImgView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择头像"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"从相册选取",@"从相机获得", nil];
    [actionSheet showInView:[[[UIApplication sharedApplication] delegate] window]];
    
    MJLog(@"点击了头像");
}

/**
 *  点击软键盘return结束编辑状体
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

/*------------------------------------------------------------------------------------------------------------------*/

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
    UIImage *img        = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //  将图片裁剪位圆形
    UIImage *circleImg  = [UIImage circleImageWithImage:img
                                            borderColor:[UIColor redColor]
                                            borderWidth:3];
    self.headImg        = img;
    //  将图片存入缓存中
    [self saveImgInDocumentWithImg:img];
    //  将图片设置位头像
    [self.headImgView setImage:circleImg];
    //  返回资料页
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   [self didSelectedImageUserInfoRequest];
                               }];
}

/**
 *  将图片存入缓存
 *
 *  @param img 头像图片
 */
- (void)saveImgInDocumentWithImg:(UIImage *)img
{
    //  将图片转换为data
    NSData *data                    = [self setImgToDataWithImg:img];
    
    //  拼接路径
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory     = [paths objectAtIndex:0];
    NSString *userHeadImgfileName   = [NSString stringWithFormat:@"userHeadImg.jpg"];
    NSString *userHeadImgFilePath   = [documentDirectory stringByAppendingPathComponent:userHeadImgfileName];
    self.userHeadImgFilePath        = userHeadImgFilePath;

    //  删除已存在同名文件
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:userHeadImgFilePath error:nil];
    
    [data writeToFile:userHeadImgFilePath atomically:YES];
    MJLog(@"存入头像图片文件%@",userHeadImgFilePath);
}

/**
 *  将图片转换为data
 *
 *  @param img 图片
 *
 *  @return 转换之后的data
 */
- (NSData *)setImgToDataWithImg:(UIImage *)img
{
    NSData *data = nil;
    if (UIImagePNGRepresentation(img) == nil)
    {
        data = UIImageJPEGRepresentation(img, 0.2);
    }
    else
    {
        data = UIImagePNGRepresentation(img);
    }
    return data;
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

/*------------------------------------------------------------------------------------------------------------------*/
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

/*------------------------------------------------------------------------------------------------------------------*/
#pragma mark - 完善资料完成请求
/**
 *  头像图片上传请求
 */
- (void)didSelectedImageUserInfoRequest
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Handler/Uploadhandler.ashx?",SERVERADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@action=depositImg&checkkey=8197bb2b3e8961a38f9e42bcd9a4e6cb&timestamp=2015-01-09",urlStr];

    MJLog(@"%@",url);
    ASIFormDataRequest *re = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    __weak ASIFormDataRequest *imageRequest = re;
    
    //  请求之前的提示
    [MMProgressHUD showWithTitle:@"请稍等" status:@"正在上传图片" cancelBlock:^{
        [MMProgressHUD dismiss];
    }];
    
    //  设置请求数据体
    [imageRequest appendPostDataFromFile:self.userHeadImgFilePath];
    [imageRequest setRequestMethod:@"POST"];
    
    //  发送请求
    [imageRequest startAsynchronous];
    
    //  请求完成回调
    [imageRequest setCompletionBlock:^{
        [MMProgressHUD dismiss];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[imageRequest responseData] options:kNilOptions error:nil];

        if ([[dic objectForKey:@"IsSuccess"]intValue]==1) {
            [MMProgressHUD dismissWithSuccess:@"上传成功"];
            [MJUserDefault setObject:[dic objectForKey:@"Message"] forKey:requestKeyUserHeadImg];
            MJLog(@"%@",dic);
        }else{
            [MMProgressHUD dismissWithError:[dic objectForKey:@"Message"] afterDelay:1];
        }
        
    }];
    [imageRequest setFailedBlock:^{
        [MMProgressHUD dismissWithError:connectionErrorMessage afterDelay:1.5];
    }];
    
}

/**
 *  完成按钮点击请求
 */
- (void)finishUserInfoRequest
{
    AFHTTPRequestOperationManager *finishBtnRequest = [AFHTTPRequestOperationManager manager];
    
    NSString *headImgUrlStr = [MJUserDefault objectForKey:requestKeyUserHeadImg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userInfoFinished                      forKey:requestKey];
    [params setObject:[self sexSelect]                      forKey:requestKeyUserSex];
    [params setObject:self.nameTextField.text               forKey:requestKeyUserNickName];
    [params setObject:self.birthdayTextField.text           forKey:requestKeyUserBrithday];
    [params setObject:headImgUrlStr                         forKey:requestKeyUserHeadImg];
    
    //  请求之前的提示
    [MMProgressHUD showWithTitle:@"请稍等" status:@"正在保存信息" cancelBlock:^{
        [MMProgressHUD dismiss];
    }];

    
    [finishBtnRequest POST:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
//        [MMProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        [self isRequestSucessWithDic:dic];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [[finishBtnRequest operationQueue] cancelAllOperations];
        [MMProgressHUD dismissWithError:connectionErrorMessage afterDelay:1.5];
        
    }];

}
    
/**
 *  请求是否成功
 *
 *  @param dic 返回字典
 */
- (void)isRequestSucessWithDic:(NSDictionary *)dic
{
    NSString *isSuc = [NSString stringWithFormat:@"%@",[dic objectForKey:@"IsSuccess"]];
    if ([isSuc isEqualToString:@"0"])
    {
        [MMProgressHUD dismissWithError:@"请求失败"];
        MJLog(@"请求失败");
    }
    else
    {
        [MMProgressHUD dismiss];
        MJLog(@"请求成功");
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

/**
 *  判断性别选择
 *
 *  @return 返回性别字符串
 */
- (NSString *)sexSelect
{
    NSString *sexStr = nil;
    if (self.womanBtn.selected)
    {
        sexStr = @"0";
    }
    else
    {
        sexStr = @"1";
    }
    return sexStr;
}

- (void)dealloc
{
    [MJNotifCenter removeObserver:self];
}

@end
