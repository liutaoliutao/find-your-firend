//
//  NSString+MJExtension.h
//  Encounter
//
//  Created by 李明军 on 22/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJEmojiModel.h"

@interface NSString (MJExtension)

/**
 *  判断手机位iPhone几或者iPad几
 */
+ (NSString *)platformString;

/**
 *  计算字符串的宽与高
 *
 *  @param string 字符串
 *
 *  @return size
 */
+ (CGSize)caculateStringSize :(NSString *)string;

/**
 *  全屏宽度计算字符串宽高
 *
 *  @param string 字符串
 *
 *  @return 返回size
 */
+ (CGSize)caculateStringNoHeadSize:(NSString *)string;

/**
 *  计算量日期的差
 *
 *  @param dateStr 日期字符串
 *
 *  @return 返回差
 */
+ (NSString *)caculateDateToNowWithDateStr:(NSString *)dateStr;

/**
 *  普通文字 --> 属性文字
 *
 *  @param text 普通文字
 *
 *  @return 属性文字
 */
+ (NSAttributedString *)attributedTextWithText:(NSString *)text;

/**
 *  属性文字--> 普通文字
 *
 *  @param attributeStr 属性文字
 *
 *  @return 普通文字
 */
+ (NSString *)stringTextWithAttributeStr:(NSAttributedString *)attributeStr;

@end
