//
//  MJResetPwdTableViewController.m
//  Encounter
//
//  Created by 李明军 on 21/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJResetPwdTableViewController.h"
#import "MJConst.h"

@interface MJResetPwdTableViewController ()<UITextFieldDelegate>

#pragma mark - 用户交互控件
/** 验证码填入文本框 */
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
/** 新密码填入文本框 */
@property (weak, nonatomic) IBOutlet UITextField *prePwdTextField;

#pragma mark - 服务器交互控件
/** 完成按钮 */
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;

@end

/*------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------声明实现分界线------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------*/

@implementation MJResetPwdTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  设置完成按钮圆角效果和背景
    self.navigationItem.title = @"找回密码";
    
    //  监听文本框变动时间
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];

}
- (IBAction)finishBtnClick:(UIButton *)sender {
}

#pragma mark - 当文本框内容变更通知方法
/**
 *  当文本框内容变更通知方法
 */
- (void)textFieldChange
{
    NSString *prePwdStr = [self.prePwdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *telCodeStr = [self.oldPwdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (telCodeStr.length > 6)
    {
        self.oldPwdTextField.text = [telCodeStr substringToIndex:6];
    }
    if (prePwdStr.length > 16)
    {
        self.prePwdTextField.text = [prePwdStr substringToIndex:16];
    }
    
    if ([prePwdStr isEqualToString:@""] || [telCodeStr isEqualToString:@""])
    {
        self.finishedBtn.enabled = NO;
    }
    else
    {
        self.finishedBtn.enabled = YES;
    }
}



#pragma mark - 点击空白，键盘消失
/**
 *  完成按钮点击事件
 */
- (IBAction)finishedBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (!self.oldPwdTextField.text)return;
    [NSPredicate predicateIsUserPasswordWithText:self.prePwdTextField.text block:^{
        
        
        
        AFHTTPRequestOperationManager *finishBtnManager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString *phoStr = [NSString stringWithFormat:@"%@",[MJUserDefault objectForKey:@"phoneNumTextFieldText"]];
        NSString *signStr = [NSString stringWithFormat:@"%@%@%@%@",phoStr,self.oldPwdTextField.text,self.prePwdTextField.text,requestSecuKey];
        
//        [params setObject:@"ShortEditeUser"                     forKey:requestKey];
//        [params setObject:phoStr                                forKey:@"Mobile"];
//        [params setObject:self.oldPwdTextField.text             forKey:@"CheckCode"];
//        [params setObject:self.prePwdTextField.text             forKey:@"Password"];
//        [params setObject:[signStr md5String]                   forKey:requestKeySign];
//        
        MJLog(@"设置密码%@%@",signStr,params);
        
        [MMProgressHUD showWithTitle:@"正在验证" status:@"请稍后" cancelBlock:^{
            [[finishBtnManager operationQueue] cancelAllOperations];
            [MMProgressHUD dismiss];
        }];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@?M=ShortEditeUser&Mobile=%@&CheckCode=%@&Password=%@&Sign=%@",[SERVERADDRESS stringByAppendingString:@"V2/UserHandler.ashx"],phoStr,self.oldPwdTextField.text,self.prePwdTextField.text,[signStr md5String]];
        MJLog(@"url%@",urlStr);
        [finishBtnManager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            
            MJLog(@"设置密码-连接服务器成功%@",dic);
            NSString *reStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if ([reStr isEqualToString:@"1"])
            {
                [MMProgressHUD dismissWithSuccess:@"新密码设置成功，请重新登录"];
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

- (void)dealloc
{
    [MJNotifCenter removeObserver:self];
}

@end
