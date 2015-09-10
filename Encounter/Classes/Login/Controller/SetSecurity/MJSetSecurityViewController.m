//
//  MJSetSecurityViewController.m
//  Encounter
//
//  Created by 李明军 on 19/5/15.
//  Copyright (c) 2015年 KuiH/ All rights reserved.
//

#import "MJSetSecurityViewController.h"
#import "MJConst.h"

@interface MJSetSecurityViewController ()

#pragma mark - 用户交互控件
/** 验证码文本框 */
@property (weak, nonatomic) IBOutlet UITextField *userInputTelCodeTextField;
/** 密码设置文本框 */
@property (weak, nonatomic) IBOutlet UITextField *setPasswordTextField;

#pragma mark - 服务器交互控件
/** 完成设置密码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *finishedSetSecurityBtn;

@end


/*------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------声明实现分界线------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------*/


@implementation MJSetSecurityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  监听文本框变动时间
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSecuTextFieldChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)setSecuTextFieldChange
{
    NSString *codeStr = [self.userInputTelCodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *pwdStr = [self.setPasswordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (codeStr.length > 6)
    {
        self.userInputTelCodeTextField.text = [codeStr substringToIndex:6];
    }
    if (pwdStr.length > 16)
    {
        self.setPasswordTextField.text = [pwdStr substringToIndex:16];
    }
}

#pragma mark - 修改title
/**
 *  修改title
 */
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"新用户注册"];
}

/**
 *  设置返回按钮值
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:@"返回"];
}


#pragma mark - 完成按钮点击事件
/**
 *  完成按钮点击事件
 *
 *  @param sender 点击按钮
 */
- (IBAction)finishedBtnClick:(UIButton *)sender
{
    
    //  如果设置的新密码位6-16位包含字母数字的密码，就进入下一个页面
    [NSPredicate predicateIsUserPasswordWithText:self.setPasswordTextField.text block:^{
        
        
        
        AFHTTPRequestOperationManager *finishBtnManager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString *phoStr = [NSString stringWithFormat:@"%@",[MJUserDefault objectForKey:@"phoneNumTextFieldText"]];
        NSString *signStr = [NSString stringWithFormat:@"%@%@%@%@",phoStr,self.userInputTelCodeTextField.text,self.setPasswordTextField.text,requestSecuKey];
        
//        [params setObject:@"ShortEditeUser"                     forKey:requestKey];
//        [params setObject:phoStr                                forKey:@"Mobile"];
//        [params setObject:self.userInputTelCodeTextField.text   forKey:@"CheckCode"];
//        [params setObject:self.setPasswordTextField.text        forKey:@"Password"];
//        [params setObject:[signStr md5String]                   forKey:requestKeySign];
        
        MJLog(@"设置密码%@%@",signStr,params);
        
        [MMProgressHUD showWithTitle:@"正在验证" status:@"请稍后" cancelBlock:^{
            [[finishBtnManager operationQueue] cancelAllOperations];
            [MMProgressHUD dismiss];
        }];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@?M=ShortEditeUser&Mobile=%@&CheckCode=%@&Password=%@&Sign=%@",[SERVERADDRESS stringByAppendingString:@"V2/UserHandler.ashx"],phoStr,self.userInputTelCodeTextField.text,self.setPasswordTextField.text,[signStr md5String]];
        MJLog(@"url%@",urlStr);
        [finishBtnManager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSDictionary *dic = responseObject;
            
            MJLog(@"设置密码-连接服务器成功%@",dic);
            NSString *reStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if ([reStr isEqualToString:@"1"])
            {
                [MMProgressHUD dismissWithSuccess:@"注册成功，请登陆后完善资料"];
//                [self performSegueWithIdentifier:MJSegueToUserInfoSetIdentifier sender:self];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                [MMProgressHUD dismissWithError:[dic objectForKey:@"retMsg"] afterDelay:1.5];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            MJLog(@"设置密码-连接服务器失败%@",error);
            [MMProgressHUD dismissWithError:@"网络连接失败，请稍后再试" afterDelay:1.5];
            [[finishBtnManager operationQueue] cancelAllOperations];
        }];
        
        
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


@end
