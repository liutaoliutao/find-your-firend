//
//  MJBirthdaySelectedDatePickerView.m
//  Encounter
//
//  Created by 李明军 on 27/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJBirthdaySelectedDatePickerView.h"
#import "MJConst.h"

@interface MJBirthdaySelectedDatePickerView()

/** 生日日期选择器 */
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdaySelectedDatePicher;

@end



@implementation MJBirthdaySelectedDatePickerView

- (instancetype)init
{
    if (self = [super init])
    {
        self = [[[NSBundle mainBundle]loadNibNamed:@"MJBirthdaySelectedDatePickerView"
                                             owner:self
                                           options:nil]
                firstObject];
        [self setDatePickerShowDate];
    }
    return self;
}


#pragma mark - 初始化时设置时间选择器显示时间

/**
 *  设置初始化时时间选择器的显示时间
 */
- (void)setDatePickerShowDate
{
    // 设置时间格式
    self.birthdaySelectedDatePicher.datePickerMode=UIDatePickerModeDate;
    //设置中文显示
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [self.birthdaySelectedDatePicher setLocale:locale];
    //  1.0 取出缓存
    NSString *userDefaultDateStr = [MJUserDefault objectForKey:userDefaultbirthdaySelectedStr];
    //  2.0 若为空，直接返回
    if ([userDefaultDateStr isEqualToString:@""]) return;
    //  3.0 根据缓存设置时间
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    dateformate.dateFormat = MJDateFormat;
    NSDate *date = [dateformate dateFromString:userDefaultDateStr];
//    self.birthdaySelectedDatePicher.date = date;
}


#pragma mark - 日期选择器值改变

/**
 *  日期选择器值改变事件
 */
- (IBAction)birthdaySelectedDatePicker:(UIDatePicker *)sender
{
    //  1.0 清楚生日历史偏好
    if ([MJUserDefault objectForKey:userDefaultbirthdaySelectedStr]) {
        [MJUserDefault removeObjectForKey:userDefaultbirthdaySelectedStr];
    }
    
    //  2.0 设置日期格式
    NSDateFormatter *dateFormate        = [[NSDateFormatter alloc]init];
    dateFormate.dateFormat              = MJDateFormat;
    NSString *birthdayStr               = [dateFormate stringFromDate:sender.date];
    
    //  3.0 通过代理传值
    if ([self.delegate respondsToSelector:@selector(birthdaySelectedDatePickerView:selectedDateStr:)])
    {
        [self.delegate birthdaySelectedDatePickerView:self selectedDateStr:birthdayStr];
    }
    
    //  4.0 设置生日用户偏好
    [MJUserDefault setObject:birthdayStr forKey:userDefaultbirthdaySelectedStr];
}


@end
