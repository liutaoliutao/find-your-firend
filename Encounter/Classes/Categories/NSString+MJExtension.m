//
//  NSString+MJExtension.m
//  Encounter
//
//  Created by 李明军 on 22/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#define margin          15
#define headImgWidth    50


#import "NSString+MJExtension.h"
#import <sys/utsname.h>
#import "MJConst.h"
#import "MJFaceImgModel.h"
#import "MJAttriubuteStrToNSString.h"

@implementation NSString (MJExtension)

/**
 *  判断手机位iPhone几或者iPad几
 */
+ (NSString *)platformString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//    NSString *platform = [self platform];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad mini 2G (Cellular)";
    
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3 (China Model)";
    
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2 (Cellular)";
    
    if ([platform isEqualToString:@"i386"]) return @"Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"Simulator";
    
    return platform;
}

/**
 *  计算字符串的宽与高
 *
 *  @param string 字符串
 *
 *  @return size
 */
+ (CGSize)caculateStringSize :(NSString *)string{
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - margin * 3 - headImgWidth, MAXFLOAT);
    return [string boundingRectWithSize:size
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                context:nil].size;
}

/**
 *  全屏宽度计算字符串宽高
 *
 *  @param string 字符串
 *
 *  @return 返回size
 */
+ (CGSize)caculateStringNoHeadSize:(NSString *)string
{
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - margin * 2, MAXFLOAT);
    return [string boundingRectWithSize:size
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                context:nil].size;

}

/**
 *  计算量日期的差
 *
 *  @param dateStr 日期字符串
 *
 *  @return 返回差
 */
+ (NSString *)caculateDateToNowWithDateStr:(NSString *)dateStr
{
    NSString *dateContent;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *endStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSDate *  senddate=[NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:dateStr];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    MJLog(@"%@",endDate);
    //得到相差秒数
    NSTimeInterval time=[senderDate timeIntervalSinceDate:endDate];

    int days = ((int)time)/(3600*24);
    int hours = (((int)time)%(3600 * 24))/3600;
    int minute = ((((int)time)%(3600 * 24))%3600)/60;
//    int ss = ((((int)time)%(3600 * 24))%3600)%60;
//    dateContent = [NSString stringWithFormat:@"%i天%i小时%i分钟%i前",days,hours,minute,ss];
//    if (days <= 0 && hours<= 0 && minute <= 0)
//    {
//        
//    }
//    else if (days <= 0 && hours <= 0)
//    {
//            }
//    else if (days <= 0)
//    {
//            }
//    else
//    {
//            }
    if (days > 365)
    {
        NSDateFormatter *datefo = [[NSDateFormatter alloc] init];
        datefo.dateFormat = @"yyyy-MM";
        dateContent = [datefo stringFromDate:endDate];
    }
    else if (days > 7)
    {
        NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
        dateformate.dateFormat = @"MM-dd";
        
        dateContent = [dateformate stringFromDate:endDate];
    }
    else if (days > 0) {
        dateContent = [NSString stringWithFormat:@"%i天前",days];

    }
    else if(hours > 0)
    {
        dateContent=[NSString stringWithFormat:@"%i小时前",hours];
    }
    else if(minute > 0)
    {
        dateContent = [NSString stringWithFormat:@"%i分钟前",minute];
    }else
    {
        dateContent= [NSString stringWithFormat:@"1分钟前"];
    }
    
    return dateContent;
}


/**
 *  普通文字 --> 属性文字
 *
 *  @param text 普通文字
 *
 *  @return 属性文字
 */
+ (NSAttributedString *)attributedTextWithText:(NSString *)text
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
//    // 表情的规则
//    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
//    // @的规则
//    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
//    // #话题#的规则
//    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
//    // url链接的规则
//    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
//    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    
    NSString *enmotionPattern = @"(e)(m)(o)(j)(i)(_)[0-9]{2}";
    
    
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:enmotionPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
//        HWTextPart *part = [[HWTextPart alloc] init];
//        part.special = YES;
//        part.text = *capturedStrings;
//        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
//        part.range = *capturedRanges;
//        [parts addObject:part];
        
        MJEmojiModel *emojiModel    = [[MJEmojiModel alloc] init];
        emojiModel.special          = YES;
        emojiModel.text             = *capturedStrings;
        emojiModel.range            = *capturedRanges;
        [parts addObject:emojiModel];
        MJLog(@"表情字符%@",emojiModel);
    }];
    // 遍历所有的非特殊字符
    [text enumerateStringsSeparatedByRegex:enmotionPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
//        HWTextPart *part = [[HWTextPart alloc] init];
//        part.text = *capturedStrings;
//        part.range = *capturedRanges;
//        [parts addObject:part];
        MJEmojiModel *emojiModel    = [[MJEmojiModel alloc] init];
//        emojiModel.special          = YES;
        emojiModel.text             = *capturedStrings;
        emojiModel.range            = *capturedRanges;
        [parts addObject:emojiModel];
        MJLog(@"非表情字符%@",emojiModel);
    }];
    
    // 排序
    // 系统是按照从小 -> 大的顺序排列对象
    [parts sortUsingComparator:^NSComparisonResult(MJEmojiModel *part1, MJEmojiModel *part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.range.location > part2.range.location) {
            // part1>part2
            // part1放后面, part2放前面
            return NSOrderedDescending;
        }
        // part1<part2
        // part1放前面, part2放后面
        return NSOrderedAscending;
    }];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    // 按顺序拼接每一段文字
    for (MJEmojiModel *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
        if (part.special) { // 表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            MJFaceImgModel *faceModel = [MJFaceImgModel faceImgModelWithStr:part.text];
            
            NSString *name = faceModel.imgName;
            MJLog(@"name%@",name);
            if (name) { // 能找到对应的图片
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                substr = [NSAttributedString attributedStringWithAttachment:attch];
            } else { // 表情图片不存在
                substr = [[NSAttributedString alloc] initWithString:part.text];
            }
//        } else if (part.special) { // 非表情的特殊文字
//            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{
//                                                                                       NSForegroundColorAttributeName : [UIColor redColor]
//                                                                                       }];
        } else { // 非特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attributedText appendAttributedString:substr];
    }
    
    // 一定要设置字体,保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    
    return attributedText;
}

/**
 *  属性文字--> 普通文字
 *
 *  @param attributeStr 属性文字
 *
 *  @return 普通文字
 */
+ (NSString *)stringTextWithAttributeStr:(NSAttributedString *)attributeStr
{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的属性文字（图片、emoji、普通文字）
    [attributeStr enumerateAttributesInRange:NSMakeRange(0, attributeStr.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        MJLog(@"attrs%@",attrs);
        NSTextAttachment *attch = attrs[@"NSAttachment"];
        
        if (attch) { // 图片
//            MJLog(@"%@",attch.emotion);
            NSArray *arr = [MJFaceImgModel faceModels];
            for (MJFaceImgModel *model in arr) {
                UIImage *image = [UIImage imageNamed:model.imgName];
                NSData *imageData = UIImageJPEGRepresentation(image, 1);
                NSData *cuImgData = UIImageJPEGRepresentation(attch.image, 1);
                
//                MJLog(@"imageData\n%@\ncuImgData\n%@",imageData,cuImgData);
                if ([imageData isEqualToData:cuImgData]) {
                    [fullText appendString:model.imgName];
                }
                
                
            }
            
            
            
        } else { // emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString *str = [attributeStr attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}


@end
