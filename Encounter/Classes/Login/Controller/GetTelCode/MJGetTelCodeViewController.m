//
//  MJGetTelCodeViewController.m
//  Encounter
//
//  Created by 李明军 on 19/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJGetTelCodeViewController.h"
#import "MJConst.h"

@interface MJGetTelCodeViewController ()

#pragma mark - 同用户交互控件
/** 手机号码输入框 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;

#pragma mark - 同服务器交互控件
/** 获取手机验证码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *getTelCodeBtn;


@end

/*------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------声明实现分界线------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------*/


@implementation MJGetTelCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  监听文本框变动时间
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cellTextFieldChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}


- (void)cellTextFieldChange
{
    NSString *telStr = [self.phoneNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (telStr.length > 11)
    {
        self.phoneNumTextField.text = [telStr substringToIndex:11];
    }
}

#pragma mark - 显示隐藏导航条
/**
 *  显示隐藏导航条
 */
- (void)viewWillAppear:(BOOL)animated
{
    //  显示隐藏导航条
    [self.navigationController setNavigationBarHidden:NO];
    //  设置title
    [self.navigationItem setTitle:@"输入手机号"];
    //  设置导航条title颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : systemNavColor }];
}

#pragma mark - 消失时
/**
 *  消失时
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:@"返回"];
}

#pragma mark - 获取验证码按钮
/**
 *  获取验证码按钮
 */
- (IBAction)getTelCode:(UIButton *)sender
{
    //  判断输入号码是否位11位，在自定义分类中
    [NSPredicate predicateIsPhoneNumberWithText:self.phoneNumTextField.text block:^{
#warning ........此处位分流，根据服务器返回决定即将出现的页面
#warning ........若输入手机号存在，则为重设密码，进入MJSegueToResetPwdIdentifier
#warning ........若输入手机号不存在，则为新用户，进入MJSegueToRigesterIdentifier
        
        AFHTTPRequestOperationManager *getCodeManager = [AFHTTPRequestOperationManager manager];
        
        NSString *signStr = [NSString stringWithFormat:@"%@%@",self.phoneNumTextField.text,requestSecuKey];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:@"SendCheckCode" forKey:requestKey];
        [params setObject:self.phoneNumTextField.text forKey:@"Mobile"];
        [params setObject:[signStr md5String] forKey:requestKeySign];
        
        MJLog(@"请求验证码%@%@",signStr,params);
        
        [MMProgressHUD showWithTitle:@"正在发送验证码" status:@"请稍后" cancelBlock:^{
            [[getCodeManager operationQueue] cancelAllOperations];
            [MMProgressHUD dismiss];
        }];
        
        [getCodeManager POST:[SERVERADDRESS stringByAppendingString:@"V2/SmsHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            MJLog(@"请求验证码-连接服务器成功%@",dic);
            NSInteger reSuceNum = [[dic objectForKey:@"retCode"] integerValue];
            if (reSuceNum == 1) {
                [MMProgressHUD dismissWithSuccess:@"发送成功"];
                NSString *reStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retData"]];
                if ([reStr isEqualToString:@"0"]) {
                    
                    [MJUserDefault setObject:self.phoneNumTextField.text forKey:@"phoneNumTextFieldText"];
                    [MJUserDefault synchronize];
                    [self performSegueWithIdentifier:MJSegueToRigesterIdentifier sender:self];
                }
                else
                {
                    [MJUserDefault setObject:self.phoneNumTextField.text forKey:@"phoneNumTextFieldText"];
                    [MJUserDefault synchronize];
                    
                    [self performSegueWithIdentifier:MJSegueToResetPwdIdentifier sender:self];
                }

            }
            else
            {
                NSString *message = [dic objectForKey:@"retMsg"];
                [MMProgressHUD dismissWithError:message afterDelay:1.5];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            MJLog(@"请求验证码-连接服务器失败%@",error);
            [[getCodeManager operationQueue] cancelAllOperations];
            [MMProgressHUD dismissWithError:@"连接服务器失败" afterDelay:1.5];
            
        }];
    }];
}

#pragma mark - 服务器请求

- (void)requestGetTelCode
{
    AFHTTPRequestOperationManager *getTelManager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",self.phoneNumTextField.text,requestSecuKey];
    
    [params setObject:@"SendCheckCode"              forKey:requestKey];
    [params setObject:self.phoneNumTextField.text   forKey:@"Mobile"];
    [params setObject:str                           forKey:requestKeySign];
    MJLog(@"params\n%@",params);
    
    //  请求之前的提示
    [MMProgressHUD showWithTitle:@"请稍等" status:@"正在上传图片" cancelBlock:^{
        [MMProgressHUD dismiss];
    }];
    
    [getTelManager POST:[NSString stringWithFormat:@"%@V2/SmsHandler.ashx?",SERVERADDRESS] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MMProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        MJLog(@"responseObject\n%@",dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"网络错误"];
        MJLog(@"error%@",error);
    }];
    
}


#pragma mark - 点击空白，键盘消失
/**
 *  点击空白，结束编辑
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [MJNotifCenter removeObserver:self];
}

@end
