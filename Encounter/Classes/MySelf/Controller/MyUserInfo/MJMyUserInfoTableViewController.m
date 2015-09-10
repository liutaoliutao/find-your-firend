//
//  MJMyUserInfoTableViewController.m
//  Encounter
//
//  Created by mac on 15/5/26.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//
#define loveSelectedVW 240
#define loveSelectedVH 240
#define settingNavTitle @"编辑资料"


#import "MJMyUserInfoTableViewController.h"
#import "MJLoveSelectedView.h"
#import "MJConst.h"
#import "MJBirthdaySelectedDatePickerView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+CZ.h"

@interface MJMyUserInfoTableViewController ()<MJLoveSelectedViewDelegate,MJBirthdaySelectedDatePickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 情感状态文本框     */
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;
/** 生日文本框        */
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/** 性别 */
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
/** 职业 */
@property (weak, nonatomic) IBOutlet UITextField *jobTextField;
/** 常出没的 */
@property (weak, nonatomic) IBOutlet UITextField *userOpenGoTextField;
/** 兴趣爱好 */
@property (weak, nonatomic) IBOutlet UITextField *likeTextField;
/** 个性签名 */
@property (weak, nonatomic) IBOutlet UITextView *selfDiscTextView;

/** 提交按钮 */
@property (nonatomic,strong) UIButton *sendBtn;
/** headUrl */
@property (nonatomic,copy) NSString *headImgurlStr;
/** headImgPath */
@property (nonatomic,copy) NSString *headImgPathStr;

@end

@implementation MJMyUserInfoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLoveLabelAndBrithdayLabel];
    [self addHeadImgGesture];
    self.selfDiscTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.selfDiscTextView.layer.borderWidth = 1;
    self.selfDiscTextView.layer.cornerRadius = 6;
    self.selfDiscTextView.layer.masksToBounds = YES;

    
    //  1. 添加返回按钮
    UIButton *rightBtn = [[UIButton alloc] init];
    //  2.1. 配置返回按钮
    [rightBtn setTitle:@"提交"                forState:UIControlStateNormal];
    [rightBtn setTitleColor:systemColor      forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    rightBtn.frame                   = CGRectMake(0, 0, 50, 25);
    //  2.2. 设置返回按钮点击事件
    [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn = rightBtn;
    
    //  2.3. 添加返回按钮
    UIBarButtonItem *rightItem      = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationItem setTitle:settingNavTitle];
}

#pragma mark - 头像添加点击事件
- (void)addHeadImgGesture
{
    UITapGestureRecognizer *tapHeadImgGesture   = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                         action:@selector(headImgViewTap)];
    self.headImgView.userInteractionEnabled     = YES;
    [self.headImgView addGestureRecognizer:tapHeadImgGesture];
}

/**
 *  头像点击事件
 */
- (void)headImgViewTap
{
    
    MJLog(@"点击了头像");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择头像"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"从相册选取",@"从相机获得", nil];
    [actionSheet showInView:[[[UIApplication sharedApplication] delegate] window]];

}

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
    self.headImgPathStr = [UIImage saveImgInDocumentWithImg:img WithName:@"mySelfHeadImg"];
    //  将图片设置位头像
    [self.headImgView setImage:[UIImage circleImageWithImage:img borderColor:nil borderWidth:0]];
    //  返回资料页
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   [self didSelectedImageUserInfoRequest];
                               }];
}

#pragma mark - 上传头像

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
    [imageRequest appendPostDataFromFile:self.headImgPathStr];
    [imageRequest setRequestMethod:@"POST"];
    
    //  发送请求
    [imageRequest startAsynchronous];
    
    //  请求完成回调
    [imageRequest setCompletionBlock:^{
        [MMProgressHUD dismiss];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[imageRequest responseData] options:kNilOptions error:nil];
        
        if ([[dic objectForKey:@"IsSuccess"]intValue]==1) {
            [MMProgressHUD dismissWithSuccess:@"上传成功"];
            self.headImgurlStr = [dic objectForKey:@"Message"];
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





#pragma mark - 加载情感和生日label

/**
 *  加载情感和生日label
 */
- (void)setLoveLabelAndBrithdayLabel
{
    //  1.0 加载情感label
    if ([MJUserDefault objectForKey:userDefaultLoveSelectedStr])
    {
        self.loveLabel.text         = [MJUserDefault objectForKey:userDefaultLoveSelectedStr];
    }
    else
    {
        [MJUserDefault setObject:self.loveLabel.text forKey:userDefaultLoveSelectedStr];
    }
    
    //  2.0 加载生日label
    if ([MJUserDefault objectForKey:userDefaultbirthdaySelectedStr])
    {
        self.birthdayLabel.text     = [MJUserDefault objectForKey:userDefaultbirthdaySelectedStr];
    }
    else
    {
        [MJUserDefault setObject:self.birthdayLabel.text forKey:userDefaultbirthdaySelectedStr];
    }

}



#pragma mark - 控件事件监听

/**
 *  情感状态选择事件
 */
- (IBAction)loveBtnClick:(UIButton *)sender
{
       //  2.0 添加情感选择view
    MJLoveSelectedView *loveSelectedV                   = [[MJLoveSelectedView alloc]init];
    loveSelectedV.frame                                 = self.view.bounds;
    loveSelectedV.delegate                              = self;
    [self.view addSubview:loveSelectedV];
}

/**
 *  生日选择事件
 */
- (IBAction)birthdayBtnClick:(UIButton *)sender
{
    MJBirthdaySelectedDatePickerView *birthdaySelectedV = [[MJBirthdaySelectedDatePickerView alloc]init];
    birthdaySelectedV.frame                             = self.view.bounds;
    birthdaySelectedV.delegate                          = self;
    [self.view addSubview:birthdaySelectedV];
}


#pragma mark - Table view 代理和数据源方法


/**
 *  设置组头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) return 1;
    return 20;
}



/**
 *  当选中时，设置编辑状态结束
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView endEditing:YES];
}

/**
 *  当即将抓取页面时，取消编辑
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}

#pragma mark - 情感选择器代理方法

/**
 *  情感选择器代理方法
 *
 *  @param loveSelectedView   情感选择器
 *  @param selectedLoveString 选中的情感字符串
 */
- (void)loveSelectedView:(MJLoveSelectedView *)loveSelectedView selectedLoveString:(NSString *)selectedLoveString
{
    self.loveLabel.text             = selectedLoveString;
    loveSelectedView.hidden         = YES;
}


#pragma mark - 生日日期选择器代理方法

- (void)birthdaySelectedDatePickerView:(MJBirthdaySelectedDatePickerView *)datePickerView selectedDateStr:(NSString *)selectedDateStr
{
    self.birthdayLabel.text         = selectedDateStr;
    datePickerView.hidden           = YES;
}


- (void)setUserid:(NSString *)userid
{
    _userid = userid;
    [self requestUserInfoWithUserid:userid];
}

- (void)requestUserInfoWithUserid:(NSString *)userId
{
    //从后台服务器获取用户信息
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params             = [[NSMutableDictionary alloc]init];
    [params setObject:@"GetUserInfo" forKey:@"M"];
    [params setObject:userId forKey:@"Userid"];
    [manager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
//                NSInteger notReadCount                 = [[resultDic objectForKey:@"NotReadCount"] integerValue];
//                NSString *bgImgUrlStr                   = [resultDic objectForKey:@"BackgroundImage"];
                NSString *qingganStr                    = [resultDic  objectForKey:@"Personinfo"];
                NSString *birthStr                      = [resultDic   objectForKey:@"Brithday"];
                NSString *zhiyeStr                      = [resultDic   objectForKey:@"Vocation"];
                NSString *chumoStr                      = [resultDic   objectForKey:@"Haunt"];
                NSString *xingquStr                     = [resultDic   objectForKey:@"Favorite"];
                
                self.headImgurlStr                      = headStr;
                
                [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    self.headImgView.image = [UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
                }];
                
                self.nameTextField.text     = nickNameStr;
                
                if ([sexStr isEqualToString:@"1"]) {
                    self.sexLabel.text          = @"男";
                }
                else
                {
                    self.sexLabel.text          = @"女";
                }
                
                
                self.birthdayLabel.text     = birthStr;
                self.loveLabel.text         = qingganStr;
                self.jobTextField.text      = zhiyeStr;
                self.userOpenGoTextField.text = chumoStr;
                self.likeTextField.text     = xingquStr;
                self.selfDiscTextView.text  = mottoStr;
                
                //                self.isFocus                            = [[resultDic objectForKey:@"IsFocus"] boolValue];
//                
//                [self.userHeadImg sd_setImageWithURL:[NSURL URLWithString:headStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    self.userHeadImg.image = [UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
//                    //                    self.userHeadImg.image = [UIImage clipImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
//                    //                    self.userHeadImg.image = [UIImage clipPhotoImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
//                }];
//                self.userNameLabel.text = nickNameStr;
//                if (notReadCount == 0)
//                {
//                    self.currentMessageLabel.hidden = YES;
//                    self.messageBtn.enabled  = NO;
//                }
//                else
//                {
//                    self.currentMessageLabel.hidden = NO;
//                    self.messageBtn.enabled  = YES;
//                    self.currentMessageLabel.text = [NSString stringWithFormat:@"%ld",(long)notReadCount];
//                }
//                
//                if (![bgImgUrlStr isEqualToString:@""])
//                {
//                    [self.headBackGroudImgView sd_setImageWithURL:[NSURL URLWithString:bgImgUrlStr]];
//                }
                
//                [headDic setObject:headStr                                  forKey:personInfoResultDicHeadimg];
//                [headDic setObject:sexStr                                   forKey:personInfoResultDicSex];
//                [headDic setObject:nickNameStr                              forKey:personInfoResultDicNickname];
//                [headDic setObject:mottoStr                                 forKey:personInfoResultDicMotto];
//                [headDic setObject:bgImgUrlStr                              forKey:personInfoResultDicBackImg];
//                [self.datasourceArray addObject:headDic];
//                [self addModelToArrayWithName:@"头像url:"       content:[resultDic  objectForKey:@"Headimg"]];
//                [self addModelToArrayWithName:@"昵称:"          content:[resultDic  objectForKey:@"Nickname"]];
//                [self addModelToArrayWithName:@"性别:"          content:[resultDic  objectForKey:@"Sex"]];
//                [self addModelToArrayWithName:@"情感状态："      content:[resultDic  objectForKey:@"Personinfo"]];
//                [self addModelToArrayWithName:@"生日："         content:[resultDic   objectForKey:@"Brithday"]];
//                [self addModelToArrayWithName:@"职业："         content:[resultDic   objectForKey:@"Vocation"]];
//                [self addModelToArrayWithName:@"常出没地："      content:[resultDic   objectForKey:@"Haunt"]];
//                [self addModelToArrayWithName:@"兴趣爱好："      content:[resultDic   objectForKey:@"Favorite"]];
//                [self addModelToArrayWithName:@"个性签名："      content:[resultDic   objectForKey:@"Motto"]];
                //                [self.tableView reloadData];
            }else{
                
                personInfor                 = [dic objectForKey:@"Result"];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];

}

#pragma mark - 提交按钮
/**
 *  提交按钮
 *
 *  @param btn 
 */
- (void)rightBtnPressed:(UIButton *)btn
{
    MJLog(@"点击了提交");
    
    
    AFHTTPRequestOperationManager *sendManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"V2_UpdateUserInfo" forKey:requestKey];
    
    
    
  
//    [params setObject:self.headImgurlStr forKey:@"HeadImg"];
    
    //  1. 昵称
    if (self.nameTextField.text)
    {
        [params setObject:self.nameTextField.text forKey:@"Nickname"];
    }
    else
    {
        [params setObject:@"" forKey:@"Nickname"];
    }
    
    //  2. 情感
//    if (self.loveLabel.text)
//    {
////        if ([self.loveLabel.text isEqualToString:@"保密"])
////        {
////            [params setObject:@"1" forKey:@"PersonInfo"];
////        }
////        else if ([self.loveLabel.text isEqualToString:@"单身"])
////        {
////            [params setObject:@"2" forKey:@"PersonInfo"];
////        }
////        else if ([self.loveLabel.text isEqualToString:@"热恋中"])
////        {
////            [params setObject:@"3" forKey:@"PersonInfo"];
////        }
////        else if ([self.loveLabel.text isEqualToString:@"已婚"])
////        {
////            [params setObject:@"4" forKey:@"PersonInfo"];
////        }
////        else if ([self.loveLabel.text isEqualToString:@"同性"])
////        {
////            [params setObject:@"5" forKey:@"PersonInfo"];
////        }
////        else
////        {
////            [params setObject:@"1" forKey:@"PersonInfo"];
////        }
//            }
//    else
//    {
//        [params setObject:@"保密" forKey:@"PersonInfo"];
//    }
    if (self.loveLabel.text)
    {
        [params setObject:self.loveLabel.text forKey:@"PersonInfo"];
    }
    else
    {
        [params setObject:@"保密" forKey:@"PersonInfo"];
    }
    

    //  3. 生日
    if (self.birthdayLabel.text)
    {
        [params setObject:self.birthdayLabel.text forKey:@"Brithday"];
    }
    else
    {
        [params setObject:@"1990-01-01" forKey:@"Brithday"];
    }
    
    //  4. 职业
    if (self.jobTextField.text)
    {
        [params setObject:self.jobTextField.text forKey:@"Vocation"];
    }
    else
    {
        [params setObject:@"" forKey:@"Vocation"];
    }
    
    //  5. 常出没
    if (self.userOpenGoTextField.text)
    {
        
        [params setObject:self.userOpenGoTextField.text forKey:@"Haunt"];
    }
    else
    {
        [params setObject:@"" forKey:@"Haunt"];
    }
    
    //  6. 爱好
    if (self.likeTextField.text)
    {
        [params setObject:self.likeTextField.text forKey:@"Favorite"];
    }
    else
    {
        [params setObject:@"" forKey:@"Favorite"];
    }
    
    //  7. 个性签名
    if (self.selfDiscTextView.text)
    {
        [params setObject:self.selfDiscTextView.text forKey:@"Motto"];
    }
    else
    {
        [params setObject:@"" forKey:@"Motto"];
    }
    MJLog(@"params:%@",params);
    
    [sendManager POST:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
        NSDictionary *dic = responseObject;
        NSString *message = [dic objectForKey:@"Message"];
        MJLog(@"修改资料-连接服务器成功%@%@",dic,message);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"修改资料-连接服务器失败%@",error);
    }];
    
}

@end
