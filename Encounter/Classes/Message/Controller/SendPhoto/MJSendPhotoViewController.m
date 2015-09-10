//
//  MJSendPhotoViewController.m
//  Encounter
//
//  Created by 李明军 on 23/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJSendPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "MJConst.h"


@interface MJSendPhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 用户描述输入框 */
@property (weak, nonatomic) IBOutlet UITextField *userDiscTextField;
/** 用户选择照片展示 */
@property (weak, nonatomic) IBOutlet UIImageView *userSelectedPhotoImgV;
/** 定位 */
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
/** 描述 */
@property (weak, nonatomic) IBOutlet UILabel *discLabel;
/** 缓存 */
@property (nonatomic,copy) NSString *imgPathStr;
/** 缓存 */
@property (nonatomic,strong) UIButton *sendBtn;



@end

@implementation MJSendPhotoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.userSelectedPhotoImgV.hidden = YES;
    self.userDiscTextField.placeholder = @"说点什么吧";
    self.locationLabel.text = self.hotPlaceStr;
    self.discLabel.text     = [NSString stringWithFormat:@"照片将发送到%@",self.hotPlaceStr];
    
    //  1. 添加返回按钮
    UIButton *rightBtn = [[UIButton alloc] init];
    //  2.1. 配置返回按钮
    [rightBtn setTitle:@"提交"                forState:UIControlStateNormal];
    [rightBtn setTitleColor:systemColor      forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    rightBtn.frame                   = CGRectMake(0, 0, 50, 25);
    //  2.2. 设置返回按钮点击事件
    [rightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn = rightBtn;
    
    //  2.3. 添加返回按钮
    UIBarButtonItem *rightItem      = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    rightBtn.enabled = NO;
//    [self.navigationItem.rightBarButtonItem setEnabled:NO];

    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldValueChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];

    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"发照片"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

#pragma mark - 右导航

/**
 *  右导航
 *
 *  @param btn
 */
- (void)rightBarButtonItemPressed:(UIButton *)btn
{
    MJLog(@"选照片点击了提交");
    
    
    if (self.imgPathStr)
    {
        [self didSelectedImageUserInfoRequestWithBtn:btn];
    }

    

}

/**
 *  头像图片上传请求
 */
- (void)didSelectedImageUserInfoRequestWithBtn:(UIButton *)btn
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@V2/PhotoHandler.ashx?",SERVERADDRESS];
    NSString *signStr = [NSString stringWithFormat:@"00%ld%@",(long)self.hotId,requestSecuKey];
    NSString *url = [NSString stringWithFormat:@"%@M=UpdatePhoto&Title=""&Describe=%@&Lat=%d&Long=%d&Place=%@&hotId=%ld&Sign=%@",urlStr,self.userDiscTextField.text,0,0,self.addressStr,(long)self.hotId,[signStr md5String]];
    NSString *utfStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    MJLog(@"%@",utfStr);
    ASIFormDataRequest *re = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:utfStr]];
    __weak ASIFormDataRequest *imageRequest = re;
    
    //  请求之前的提示
    [MMProgressHUD showWithTitle:@"请稍等" status:@"正在上传图片" cancelBlock:^{
        [MMProgressHUD dismiss];
    }];
    
    //  设置请求数据体
    [imageRequest appendPostDataFromFile:self.imgPathStr];
    [imageRequest setRequestMethod:@"POST"];
    
    //  发送请求
    [imageRequest startAsynchronous];
    
    //  请求完成回调
    [imageRequest setCompletionBlock:^{
        [MMProgressHUD dismiss];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[imageRequest responseData] options:kNilOptions error:nil];
        
        if ([[dic objectForKey:@"retCode"]intValue]==1) {
            [MMProgressHUD dismissWithSuccess:@"上传成功"];
            [MJUserDefault setObject:[dic objectForKey:@"retMsg"] forKey:@"photoSend"];
            MJLog(@"%@",dic);
            if ([self.delegate respondsToSelector:@selector(sendPhotoViewC:didClickSendBtn:)])
            {
                [self.delegate sendPhotoViewC:self didClickSendBtn:btn];
                
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MMProgressHUD dismissWithError:[dic objectForKey:@"retMsg"] afterDelay:3];
            MJLog(@"%@",[dic objectForKey:@"retMsg"]);
        }
        
    }];
    [imageRequest setFailedBlock:^{
        [MMProgressHUD dismissWithError:connectionErrorMessage afterDelay:1.5];
    }];
    
}


#pragma mark - 按钮点击事件
/**
 *  拍照按钮点击
 *
 *  @param sender
 */
- (IBAction)cameraBtnClick:(UIButton *)sender
{
    MJLog(@"照片选取页，选择了拍照");
    [self selectImgFromCamera];
}

/**
 *  从相册中选择按钮
 *
 *  @param sender
 */
- (IBAction)photoLibBtnClick:(UIButton *)sender
{
    MJLog(@"照片选取页，选择了相册");
    [self selectImgFromPhotoLib];
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
    self.userSelectedPhotoImgV.hidden = NO;
    [self.userSelectedPhotoImgV setImage:img];
    //  返回资料页
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
                               }];
    
    self.imgPathStr = [UIImage saveImgInDocumentWithImg:img WithName:@"selectedImg"];
    
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

#pragma mark - 文字改变

- (void)textFieldValueChange
{
    
    NSString *text = [self.userDiscTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (![text isEqual:@""])
    {
        self.sendBtn.enabled = YES;
    }
    else
    {
        self.sendBtn.enabled = NO;
    }
}

- (void)dealloc
{
    [MJNotifCenter removeObserver:self];
}

@end
