//
//  MJResetPasswordTableViewController.m
//  Encounter
//
//  Created by 李明军 on 1/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJResetPasswordTableViewController.h"
#import "MJConst.h"
#import "NSPredicate+MJExtension.h"

@interface MJResetPasswordTableViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

/** 旧密码 */
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
/** 新密码 */
@property (weak, nonatomic) IBOutlet UITextField *currentPwdTextField;
/** 重复新密码 */
@property (weak, nonatomic) IBOutlet UITextField *repeatPwdTextField;
/** 完成按钮 */
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation MJResetPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldPwdTextField.delegate       = self;
    self.currentPwdTextField.delegate   = self;
    self.repeatPwdTextField.delegate    = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldValueChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 完成按钮点击事件
/**
 *  完成按钮点击事件
 *
 *  @param sender 完成按钮
 */
- (IBAction)finishBtnClick:(UIButton *)sender
{
#warning ...........设置重设密码没有处理
    MJLog(@"点击了完成按钮");
    
    if (![NSPredicate predicateIsUserPasswordWithText:self.oldPwdTextField.text block:nil])return;
    if (![NSPredicate predicateIsUserPasswordWithText:self.currentPwdTextField.text block:nil])return;
    if (![NSPredicate predicateIsUserPasswordWithText:self.repeatPwdTextField.text block:nil])return;

    
    NSString *currentPwdStr = [self.currentPwdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *repeatPwdStr  = [self.repeatPwdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (![currentPwdStr isEqualToString:repeatPwdStr]) {
        [[[UIAlertView alloc]initWithTitle:@"警告"
                                   message:@"两次输入密码不相同,请重新输入"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles: nil]
         show];
        return;
    }
    
    AFHTTPRequestOperationManager *resetManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"UpdatePwd" forKey:requestKey];
    
    [params setObject:self.currentPwdTextField.text forKey:@"password"];
    [params setObject:self.oldPwdTextField.text forKey:@"old_password"];
    
    
    [MMProgressHUD showWithTitle:@"正在修改" status:@"请稍后" cancelBlock:^{
        [[resetManager operationQueue] cancelAllOperations];
        [MMProgressHUD dismiss];
    }];
    
    [resetManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSString *str = [dic objectForKey:@"Message"];
        MJLog(@"修改密码-连接服务器成功%@",dic);
        NSString *isSuc = [NSString stringWithFormat:@"%@",[dic objectForKey:@"IsSuccess"]];
        
        if ([isSuc isEqualToString:@"1"])
        {
            [MMProgressHUD dismissWithSuccess:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MMProgressHUD dismissWithError:str afterDelay:1.5];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[resetManager operationQueue] cancelAllOperations];
        MJLog(@"修改密码-连接服务器失败%@",error);
        [MMProgressHUD dismissWithError:@"网络连接失败，请稍后再试" afterDelay:1.5];
    }];

}

#pragma mark - textField值改变
/**
 *  文本输入框值改变
 */
- (void)textFieldValueChange
{
    //  去掉空格
    NSString *oldPwdStr     = [self.oldPwdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *currentPwdStr = [self.currentPwdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *repeatPwdStr  = [self.repeatPwdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (oldPwdStr.length > 16)
    {
        self.oldPwdTextField.text = [oldPwdStr substringToIndex:16];
    }
    if (currentPwdStr.length > 16)
    {
        self.currentPwdTextField.text = [currentPwdStr substringToIndex:16];
    }
    if (repeatPwdStr.length > 16)
    {
        self.repeatPwdTextField.text = [repeatPwdStr substringToIndex:16];
    }
    //  判断完成按钮是否可用
    if ([oldPwdStr isEqualToString:@""] || [currentPwdStr isEqualToString:@""] || [repeatPwdStr isEqualToString:@""])return;
    
    self.finishBtn.enabled  = YES;
    
}

#pragma mark - 弹窗代理
/**
 *  当点击弹窗取消时
 *
 *  @param alertView 弹窗
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.currentPwdTextField.text   = @"";
    self.repeatPwdTextField.text    = @"";
    [self.currentPwdTextField becomeFirstResponder];
}


#pragma mark - 键盘代理
/**
 *  键盘返回键代理
 *
 *  @param textField 键盘
 *
 *  @return yes
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.oldPwdTextField isFirstResponder])
    {
        [self.currentPwdTextField becomeFirstResponder];
    }
    else if([self.currentPwdTextField isFirstResponder])
    {
        [self.repeatPwdTextField becomeFirstResponder];
    }
    else if([self.repeatPwdTextField isFirstResponder])
    {
        if(!self.finishBtn.enabled) return NO;
        //  当完成按钮可用时菜调用此方法
        [self finishBtnClick:nil];
    }
    return YES;
}

- (void)dealloc
{
    [MJNotifCenter removeObserver:self];
}

@end
