//
//  MJLoginViewController.m
//  Encounter
//
//  Created by 李明军 on 19/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//


/** 发送请求时，标示登录 */
#define userLoginSign       @"UserLogin"
//  登录成功状态返回结果字典key
/** 返回结果头像url key */
#define resultKeyHeadImgUrl @"headImageUrl"
/** 是否是第一次请求，决定是否需要填写详情页 */
#define resultKeyIsFirst    @"isFirst"
/** 性别 */
#define resultKeySex        @"sex"
/** 用户userId */
#define resultKeyUserId     @"userId"
/** 用户userName */
#define resultKeyUserName   @"userName"

#import "MJLoginViewController.h"
#import "MJConst.h"
#import "AppDelegate.h"

@interface MJLoginViewController ()<UITextFieldDelegate>

#pragma mark - 登录服务器交互控件组
/** 登录图标 */
@property (weak, nonatomic) IBOutlet UIImageView *loginImg;
/** 登录描述label */
@property (weak, nonatomic) IBOutlet UILabel *loginDiscLabel;

#pragma mark - 登录用户交互控件组
/** 用户名文本框 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
/** 密码文本框 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/** 登录按钮 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/** 标志 */
@property (nonatomic,assign) NSInteger loginSignNum;
/**  */
@property (nonatomic,strong) UIImageView *coverView;


@end


/*------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------声明实现分界线------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------*/


@implementation MJLoginViewController

#pragma mark - view加载

/**
 *  view加载完毕
 */
- (void)viewDidLoad
{
    self.loginSignNum = 1;
    
    [super viewDidLoad];
    //  通过自定义分类设置按钮背景及圆角效果
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldValueChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    self.userNameTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    
    //  从缓存中取出登陆图标（appdelegate 进入时版本检测时获取登陆图标）
    if ([MJUserDefault objectForKey:@"ServiceRemark"])
    {
        NSString *str = [MJUserDefault objectForKey:@"ServiceRemark"];
        [self.loginImg sd_setImageWithURL:[NSURL URLWithString:str]];
    }
}

/**
 *  view已经出现
 *
 *  @param animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    [MJUserDefault removeObjectForKey:@"annotationViewForBubbleLat"];
    [MJUserDefault removeObjectForKey:@"annotationViewForBubbleLon"];
    [MJUserDefault removeObjectForKey:@"annotationViewForBubbleDistance"];
    
    self.userNameTextField.delegate      = self;
    self.passwordTextField.delegate      = self;
    if ([MJUserDefault objectForKey:@"userNameTextLogin"])
    {
        self.loginSignNum = 2;
        UIImageView *img = [[UIImageView alloc] initWithFrame:self.view.bounds];
        img.image = [UIImage imageNamed:@"登录背景"];
        [self.view addSubview:img];
        self.coverView = img;
        self.userNameTextField.text = [MJUserDefault objectForKey:@"userNameTextLogin"];
        self.passwordTextField.text = [SFHFKeychainUtils getPasswordForUsername:self.userNameTextField.text andServiceName:@"yibaiwuUserName" error:nil];
        [self requestCurrentDeviceToDevice];
        
    }

}

/**
 *  隐藏导航条
 */
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

/**
 *  设置返回按钮
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:@"返回"];
}


#pragma mark - 设置登录图标(未使用)
/**
 *  设置登录图标(未使用)
 */
- (void)settingLoginImg
{
    if ([MJUserDefault objectForKey:userDefaultHeadImgUrlStr])
    {
        NSString *headImgUrl = [MJUserDefault objectForKey:userDefaultHeadImgUrlStr];
        [self.loginImg sd_setImageWithURL:[NSURL URLWithString:headImgUrl]];
    }
}


#pragma mark - 点击空白取消编辑状态
/**
 *  点击空白处取消编辑状态
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - 文本输入框值改变通知
/**
 *  判断登录按钮是否可用
 */
- (void)textFieldValueChange
{
    //  去掉空格
    NSString *nameStr = [self.userNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *pwdStr  = [self.passwordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //  限制用户输入11位用户名
    if (nameStr.length > 11) {
        self.userNameTextField.text = [nameStr substringToIndex:11];
    }
    //  限制用户最多输入16位密码
    if (pwdStr.length > 16) {
        self.passwordTextField.text = [pwdStr substringToIndex:16];
    }
    //  如果密码或用户名为空，登陆按钮不可用
    if ([nameStr isEqualToString:@""] || [pwdStr isEqualToString:@""])
    {
        self.loginBtn.enabled = NO;
    }
    else
    {
        self.loginBtn.enabled = YES;
    }
}


#pragma mark - 按钮点击事件

#pragma mark 1. 登录按钮点击事件
/**
 *  登录按钮点击事件
 *
 *  @param sender 登录按钮
 */
- (IBAction)loginClick:(id)sender
{
    //  移除足迹页面定位缓存，为了求初遇逻辑
    
    
    
    [MJUserDefault setObject:self.userNameTextField.text forKey:userDefaultPhoneNum];
    [self checkRongYunConnect];
//      1.0 判断用户手机号是否输入正确，正确继续，不正确直接返回
    if (![NSPredicate predicateIsPhoneNumberWithText:self.userNameTextField.text block:nil])return;
//      2.0 判断用户密码是否位包含字母数字的6-16位密码
    [NSPredicate predicateIsUserPasswordWithText:self.passwordTextField.text block:^{
        MJLog(@"点击了登录按钮");
        //  发送登录请求
        [self requestCurrentDeviceToDevice];
//        [self loginRequest];
    }];
}

#pragma mark 2. 检测当前程序版本，若不为最新版本，则不能登录
/**
 *  检测当前程序版本，若不为最新版本，则不能登录
 */
- (void)requestCurrentDeviceToDevice
{
    [self loginRequest];
//    //  测试版本请求
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *str = [NSString stringWithFormat:@"IosVersion%@",requestSecuKey];
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:[str md5String]        forKey:@"Sign"];
//    [param setObject:@"GetSysConfig"        forKey:@"M"];
//    [param setObject:@"IosVersion"          forKey:@"ParamFlag"];
//    
//    
//    [manager POST:[NSString stringWithFormat:@"%@V2/SysConfig.ashx?",SERVERADDRESS] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = responseObject;
//        MJLog(@"......版本检测%@",dic);
//        if ([[dic objectForKey:@"retCode"] integerValue] == 1)
//        {
//            NSArray *resultA = [dic objectForKey:@"retData"];
//            [self requestDeviceToFWithDic:resultA[0]];
//        }
//        else
//        {
//            MJLog(@"请求失败");
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        MJLog(@"....%@",error);
//        self.passwordTextField.text = @"";
//        [[manager operationQueue] cancelAllOperations];
//        if (self.loginSignNum == 2)
//        {
//            [self.coverView removeFromSuperview];
//        }
//        [MMProgressHUD showAlert:@"网络连接失败"];
//    }];
    
}
//
//#pragma mark 3. 版本检测结果处理
///**
// *  版本检测结果处理
// *
// *  @param dic 版本检测结果字典
// */
//- (void)requestDeviceToFWithDic:(NSDictionary *)dic
//{
//    NSString  *paramValue           = [dic objectForKey:@"ParamValue"];
//    NSString *paramName         = [dic objectForKey:@"ParamName"];
//    NSString *paramFlag         = [dic objectForKey:@"ParamFlag"];
////    NSString *paramCreateTime   = [dic objectForKey:@"CeateTime"];
//    NSString *markStr           = [dic objectForKey:@"Remark"];
//    
//    //    [MJUserDefault setObject:paramValue forKey:@"ServiceRemark"];
//    MJLog(@"ParamValue%@",paramValue);
//    MJLog(@"paramName%@",paramName);
//    MJLog(@"paramFlag%@",paramFlag);
//    MJLog(@"markStr%@",markStr);
//   
//    //  若为最新版本，允许登录
//    if ([paramName isEqualToString:@"2.0"]) {
//        
//    }
//    else
//    {
//        //  若不为最新版本，跳转新版本下载地址
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:markStr]];
//    }
//    
//}


#pragma mark - 登录请求

#pragma mark 1. 登录请求
/**
 *  登录请求
 */
- (void)loginRequest
{
    //  1.0 创建请求管理
    AFHTTPRequestOperationManager *loginManager = [AFHTTPRequestOperationManager manager];
    
    //  2.0 创建请求数据包（字典）
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userLoginSign forKey:requestKey];
    [params setObject:self.userNameTextField.text forKey:requestKeyUserPhoneNumber];
    [params setObject:self.passwordTextField.text forKey:requestKeyUserPassword];
    
//    //  3.0 发送请求前等待提示
    
    if (self.loginSignNum == 1)
    {
        [MMProgressHUD showWithTitle:@"请稍后。。" status:@"登录中。。。" cancelBlock:^{
            [[loginManager operationQueue] cancelAllOperations];
            [MMProgressHUD dismiss];
        }];

    }
    
    
    //  4.0 发送请求
    [loginManager POST:[SERVERADDRESS stringByAppendingString:@"Handler/ManagerUser.ashx"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MMProgressHUD dismissWithSuccess:@"登录成功"];
        NSDictionary *responseDic = responseObject;
        MJLog(@"%@",responseDic);
        [MJUserDefault setObject:self.userNameTextField.text forKey:@"userNameTextLogin"];
//        [MJUserDefault setObject:self.passwordTextField.text forKey:@"userPwdTextLogin"];
        [SFHFKeychainUtils storeUsername:self.userNameTextField.text andPassword:self.passwordTextField.text forServiceName:@"yibaiwuUserName" updateExisting:YES error:nil];
        //  登录成功切换根控制器
        [self loginResponseWithDic:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"登录失败%@",error);
        self.passwordTextField.text = @"";
        [self.coverView removeFromSuperview];
        if (self.loginSignNum == 1) {
            [MMProgressHUD dismissWithError:errorMessage afterDelay:1.5];

        }else
        {
            [self.coverView removeFromSuperview];
            [MMProgressHUD showAlert:@"网络连接失败"];
        }
    }];
    
}

#pragma mark 2. 登录返回结果处理
/**
 *  登录返回结果处理
 *
 *  @param dic 服务器返回信息字典
 */
- (void)loginResponseWithDic:(NSDictionary *)dic
{
    [MJUserDefault removeObjectForKey:userDefaultAppStartIsLogin];
    //  记录登录状态
    BOOL islogin = NO;
    
    //  1. 从返回结果字典中取出返回信息
    //  1.1. 请求是否通过状态
    NSString *isSuccessStr      = [NSString stringWithFormat:@"%@",[dic objectForKey:responseKeyIsSuccess]];
    //  1.2. 请求返回状态信息
    NSString *message           = [dic objectForKey:responseKeyMessage];
    //  1.3. 请求结果字典
    NSDictionary *resultDic     = [dic objectForKey:responseKeyResult];
    
    MJLog(@"\nmessage:%@%@",message,isSuccessStr);
    //  2. 如果返回为0，表示请求未通过
    if ([isSuccessStr isEqualToString:@"0"])
    {
        islogin = NO;
//        if (self.loginSignNum == 1) {
        [self.coverView removeFromSuperview];
        [MMProgressHUD dismissWithError:message];
        
//        }
       
    }
    //  3. 如果返回为1,表示请求通过
    else if ([isSuccessStr isEqualToString:@"1"])
    {
        islogin = YES;
        //  3.1. 成功状态返回结果处理
        if (self.loginSignNum == 1) {
            [MMProgressHUD dismiss];
        }
        
        [self loginSucessWithResultDic:resultDic];
       
    }
    [MJUserDefault setObject:@(islogin)     forKey:userDefaultAppStartIsLogin];

    
}

#pragma mark 3. 登录成功返回结果处理
/**
 *  登录成功返回结果处理
 *
 *  @param resultDic 返回结果字典
 */
- (void)loginSucessWithResultDic:(NSDictionary *)resultDic
{
    //  1. 从成功状态结果中取出所有信息
    NSString *headImgUrlStr = [resultDic objectForKey:resultKeyHeadImgUrl];
    NSString *isFirstStr    = [NSString stringWithFormat:@"%@",[resultDic objectForKey:resultKeyIsFirst]];
    NSString *sexStr        = [resultDic objectForKey:resultKeySex];
    NSString *userIdStr     = [resultDic objectForKey:resultKeyUserId];
    NSString *userNameStr   = [resultDic objectForKey:resultKeyUserName];
    MJLog(@"resultDic\n%@",resultDic);
    
    //  2. 将所有取出信息放入用户偏好中
    [MJUserDefault setObject:headImgUrlStr                  forKey:userDefaultHeadImgUrlStr];
    [MJUserDefault setObject:sexStr                         forKey:userDefaultSex];
    [MJUserDefault setObject:userIdStr                      forKey:userDefaultUserId];
    [MJUserDefault setObject:userNameStr                    forKey:userDefaultUserName];
    [MJUserDefault synchronize];
    
    //  3. 根据isFirstStr跳转
    //  3.1. 返回0，表示不是第一次登录，不需要进入详情页
    if ([isFirstStr isEqualToString:@"0"])
    {
        [self getToken];
        AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appD setLocationIsStart];
        if ([MJUserDefault objectForKey:userDefaultIsOnLocation])
        {
            BOOL locationIsOn = [[MJUserDefault objectForKey:userDefaultIsOnLocation] boolValue];
            if (locationIsOn)
            {
                [appD setLocationIsStart];
            }
        }
        else
        {
            [appD setLocationIsStart];
        }
        
        
        [appD startNoReadThread];
        //  判断缓存中是否有足迹，若没有，请求足迹并缓存
        NSArray *footArray = [MJUserDefault objectForKey:userDefaultLatestFootPrint];
        if (footArray.count < 1)
        {
            [appD getfootArray];
        }
        
        UIStoryboard *mainSt = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [[UIApplication sharedApplication].delegate window].rootViewController = [mainSt instantiateInitialViewController];
        [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
    }
    //  3.2. 返回1，表示为第一次登录，需要进入详情页
    else if ([isFirstStr isEqualToString:@"1"])
    {
        [self performSegueWithIdentifier:MJSegueToUserInfoSetIdentifier sender:self];
    }
}




#pragma mark - 连接融云

#pragma mark 1. 获取融云连接token
/**
 *  获取融云连接token
 */
- (void)getToken
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"GetToken" forKey:@"M"];
    [params setObject:[MJUserDefault objectForKey:userDefaultUserId]        forKey:@"userId"];
    [params setObject:[MJUserDefault objectForKey:userDefaultUserName]      forKey:@"userName"];
    [params setObject:[MJUserDefault objectForKey:userDefaultHeadImgUrlStr] forKey:@"headImageUrl"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[SERVERADDRESS stringByAppendingString:@"Handler/ChatHandler.ashx"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dic=responseObject;
        NSString *statuCode =[NSString stringWithFormat:@"%@",[dic objectForKey:@"IsSuccess"]];
        MJLog(@"responseObject%@",dic);
        if ([statuCode isEqualToString:@"1"]) {
            NSDictionary *resultDic=[dic objectForKey:@"Result"];
            [MJUserDefault removeObjectForKey:rongYunToKen];
            [MJUserDefault setObject:[resultDic objectForKey:@"token"] forKey:rongYunToKen];
            [MJUserDefault synchronize];
            [self connectRongYun];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"错误%@",error);
    }];
}

#pragma mark 2. 连接融云
/**
 *  连接融云
 */
- (void)connectRongYun
{
    [[RCIM sharedKit] connectWithToken:[MJUserDefault objectForKey:rongYunToKen] success:^(NSString *userId) {
        MJLog(@"连接成功");
        
        [MJUserDefault setObject:userId forKey:rongYunUserId];
        [MJUserDefault synchronize];
        
        //设置当前的用户信息
        RCUserInfo *currentUserInfo = [[RCUserInfo alloc] initWithUserId:[MJUserDefault objectForKey:rongYunUserId]
                                                                    name:[MJUserDefault objectForKey:userDefaultUserName]
                                                                portrait:[MJUserDefault objectForKey:userDefaultHeadImgUrlStr]];
        
        [RCIMClient sharedClient].currentUserInfo = currentUserInfo;

//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIStoryboard *mainSt = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            [[UIApplication sharedApplication].delegate window].rootViewController = [mainSt instantiateInitialViewController];
//        });
        
    } error:^(RCConnectErrorCode status) {
        MJLog(@"连接融云失败%ld",(long)status);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIStoryboard *mainSt = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            [[UIApplication sharedApplication].delegate window].rootViewController = [mainSt instantiateInitialViewController];
//        });
    }];
    
}

#pragma mark 3. 检查融云连接状态
/**
 *  检查融云连接状态
 */
- (void)checkRongYunConnect
{
    RCNetworkStatus stauts=[[RCIMClient sharedClient] getCurrentNetworkStatus];
    
    if (RC_NotReachable == stauts) {
        MJLog(@"当前网络不可用，请检查！");
    }
}

#pragma mark - 键盘代理方法
/**
 *  通过代理方法设置点击软键盘return按钮处理事件
 *
 *  @param textField 文本框
 *
 *  @return 返回bool
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //  若在户名文本输入框编辑状态下点击return按钮，跳转至密码框
    if ([self.userNameTextField isFirstResponder])
    {
        [self.passwordTextField becomeFirstResponder];
    }
    //  若密码框位编辑状态下点击return按钮，即为登录状态
    else if([self.passwordTextField isFirstResponder])
    {
        [self loginClick:self.loginBtn];
    }
    return YES;
}

#pragma mark - 通知释放
/**
 *  通知释放
 */
- (void)dealloc
{
    [MJNotifCenter removeObserver:self];
}

@end
