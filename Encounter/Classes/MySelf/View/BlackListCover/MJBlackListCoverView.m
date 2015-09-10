//
//  MJBlackListCoverView.m
//  Encounter
//
//  Created by 李明军 on 10/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJBlackListCoverView.h"
#import "MJConst.h"

@interface MJBlackListCoverView()

typedef enum
{
    kMJBlackListCoverViewBtnTagCancel,
    kMJBlackListCoverViewBtnTagAddBlack,
    kMJBlackListCoverViewBtnTagAlarm
}kMJBlackListCoverViewBtnTag;


/** 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/** 拉黑按钮 */
@property (weak, nonatomic) IBOutlet UIButton *addBlackBtn;
/** 举报按钮 */
@property (weak, nonatomic) IBOutlet UIButton *alarmBtn;

@end

@implementation MJBlackListCoverView

/**
 *  初始化加载
 *
 *  @return
 */
- (instancetype)init
{
    if (self = [super init])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJBlackListCoverView"
                                              owner:self
                                            options:nil] lastObject];
        [self addtagToBtn];
    }
    return self;
}

/**
 *  设置tag
 */
- (void)addtagToBtn
{
    self.cancelBtn.tag      = kMJBlackListCoverViewBtnTagCancel;
    self.addBlackBtn.tag    = kMJBlackListCoverViewBtnTagAddBlack;
    self.alarmBtn.tag       = kMJBlackListCoverViewBtnTagAlarm;
}

/**
 *  按钮点击事件
 *
 *  @param sender
 */
- (IBAction)btnClick:(UIButton *)sender
{
    switch (sender.tag)
    {
        case kMJBlackListCoverViewBtnTagCancel:
        {
            MJLog(@"点击了取消");
            if ([self.delegate respondsToSelector:@selector(blackListCoverView:didClickCancelButton:)])
            {
                [self.delegate blackListCoverView:self didClickCancelButton:sender];
            }
            break;
        }
        case kMJBlackListCoverViewBtnTagAddBlack:
        {
            MJLog(@"点击了拉黑");
            if ([self.delegate respondsToSelector:@selector(blackListCoverView:didClickAddBlackButton:)])
            {
                [self.delegate blackListCoverView:self didClickAddBlackButton:sender];
            }
            break;
        }
        case kMJBlackListCoverViewBtnTagAlarm:
        {
            MJLog(@"点击了举报");
            if ([self.delegate respondsToSelector:@selector(blackListCoverView:didClickAlarmButton:)])
            {
                [self.delegate blackListCoverView:self didClickAlarmButton:sender];
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)blackListCoverView
{
    return [[self alloc]init];
}


@end
