//
//  NSPredicate+MJExtension.m
//  Encounter
//
//  Created by 李明军 on 21/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "NSPredicate+MJExtension.h"

@implementation NSPredicate (MJExtension)


/**
 *  判断是否位11位手机号码
 *
 *  @param phoneStr 传入的字符串
 *  @param block    block用于封装在未11位手机号码时处理办法
 */
+ (BOOL)predicateIsPhoneNumberWithText:(NSString *)phoneStr block:(void(^)()) block
{
    NSString *predi        = @"^(1)[3|4|5|7|8][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predi];
    if (![predicate evaluateWithObject:phoneStr])
    {
        [[[UIAlertView alloc]initWithTitle:@"错误"
                                   message:@"请输入正确手机号"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil]
         show];
        return NO;
    }else
    {
        if (!block)return YES;
        block();
        return YES;
    }
}


/**
 *  判断是否位6-16位且至少有一个字母和数字的字符串
 *
 *  @param userPwd 传入的字符串
 *  @param block   block用于封装为是时的处理办法
 */
+ (BOOL)predicateIsUserPasswordWithText:(NSString *)userPwd block:(void(^)()) block
{
//    //  1.0 包含字母个数
//    NSRegularExpression *regular = [NSRegularExpression
//                                    regularExpressionWithPattern:@"[a-zA-Z]+"
//                                    options:NSRegularExpressionCaseInsensitive
//                                    error:nil];
//    NSUInteger regularNum = [regular numberOfMatchesInString:userPwd
//                                                      options:NSMatchingReportProgress
//                                                        range:NSMakeRange(0, userPwd.length)];
//    //  2.0 包含数字个数
//    NSRegularExpression *regularT = [NSRegularExpression
//                                     regularExpressionWithPattern:@"[0-9]+"
//                                     options:NSRegularExpressionCaseInsensitive
//                                     error:nil];
//    NSUInteger regularTNum = [regularT numberOfMatchesInString:userPwd
//                                                        options:NSMatchingReportProgress
//                                                          range:NSMakeRange(0, userPwd.length)];
    NSString *pwdStr = [userPwd stringByReplacingOccurrencesOfString:@" " withString:@""];
    //  3.0 是否位6-16位
    NSString *predi        = @"^[a-zA-Z0-9]{8,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predi];
    if (![predicate evaluateWithObject:pwdStr])
    {
        NSString *showMessageStr;
        if (pwdStr.length < 8) {
            showMessageStr = @"密码必须大于8位";
        }
        if (pwdStr.length > 16)
        {
            showMessageStr = @"密码不能超过16位";
        }
        [[[UIAlertView alloc]initWithTitle:@"错误"
                                   message:showMessageStr
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil]
         show];
        return NO;
    }else
    {
        if (!block) return YES;
        block();
        return YES;
    }
}

@end
