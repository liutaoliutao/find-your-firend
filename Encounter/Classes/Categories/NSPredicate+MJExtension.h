//
//  NSPredicate+MJExtension.h
//  Encounter
//
//  Created by 李明军 on 21/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSPredicate (MJExtension)

/**
 *  判断是否位11位手机号码
 *
 *  @param phoneStr 传入的字符串
 *  @param block    block用于封装在为11位手机号码时处理办法
 */
+ (BOOL)predicateIsPhoneNumberWithText:(NSString *)phoneStr block:(void(^)()) block;

/**
 *  判断是否位6-16位且至少有一个字母和数字的字符串
 *
 *  @param userPwd 传入的字符串
 *  @param block   block用于封装为是时的处理办法
 */
+ (BOOL)predicateIsUserPasswordWithText:(NSString *)userPwd block:(void(^)()) block;


@end
