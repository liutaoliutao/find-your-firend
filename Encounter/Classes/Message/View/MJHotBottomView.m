
//
//  MJHotBottomView.m
//  Encounter
//
//  Created by 李明军 on 18/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJHotBottomView.h"

@interface MJHotBottomView()




@end

@implementation MJHotBottomView

- (instancetype)init
{
    if (self = [super init])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJHotBottomView"
                                              owner:self
                                            options:nil]
                firstObject];
        self.textField.layer.borderColor = UIColor.grayColor.CGColor;
        self.textField.layer.borderWidth = 1;
        self.textField.layer.cornerRadius = 6;
        self.textField.layer.masksToBounds = YES;
    }
    return self;
}


/**
 *  发送按钮点击事件
 *
 *  @param sender
 */
- (IBAction)sendBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(hotBottomView:didClickSendBtnWithTButton:)])
    {
        [self.delegate hotBottomView:self didClickSendBtnWithTButton:sender];
    }
}

/**
 *  图片按钮点击事件
 *
 *  @param sender
 */
- (IBAction)photoBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(hotBottomView:didClickPhotoBtnWithButton:)])
    {
        [self.delegate hotBottomView:self didClickPhotoBtnWithButton:sender];
    }
}

/**
 *  表情按钮点击事件
 *
 *  @param sender
 */
- (IBAction)faceBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(hotBottomView:didClickFaceBtnWithButton:)])
    {
        [self.delegate hotBottomView:self didClickFaceBtnWithButton:sender];
    }
}

/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)hotspotBottomView
{
    return [[self alloc] init];
}

@end
