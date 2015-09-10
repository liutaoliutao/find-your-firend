//
//  MJBirthdaySelectedDatePickerView.h
//  Encounter
//
//  Created by 李明军 on 27/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MJBirthdaySelectedDatePickerView;
@protocol MJBirthdaySelectedDatePickerViewDelegate <NSObject>

/**
 *  日期选择器选择日期代理
 *
 *  @param datePickerView  自定义蒙版型日期选择器
 *  @param selectedDateStr 选择的日期字符串
 */
- (void)birthdaySelectedDatePickerView:(MJBirthdaySelectedDatePickerView *)datePickerView selectedDateStr:(NSString *)selectedDateStr;

@end


@interface MJBirthdaySelectedDatePickerView : UIView

/** 日期选择器代理 */
@property (nonatomic,weak) id<MJBirthdaySelectedDatePickerViewDelegate> delegate;

@end
