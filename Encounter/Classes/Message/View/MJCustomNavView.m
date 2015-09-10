//
//  MJCustomNavView.m
//  Encounter
//
//  Created by 李明军 on 7/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#define signSWH 10


#import "MJCustomNavView.h"

#import "MJConst.h"


@interface MJCustomNavView()


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation MJCustomNavView

#pragma mark - 小红点懒加载

///**
// *  1. 第一个小红点懒加载
// *
// *  @return
// */
//- (MJSignView *)firstSignView
//{
//    if (!_firstSignView)
//    {
//        _firstSignView = [[MJSignView alloc] init];
//    }
//    return _firstSignView;
//}
//
///**
// *  2. 第二个小红点懒加载去
// *
// *  @return
// */
//- (MJSignView *)secondSignView
//{
//    if (!_secondSignView)
//    {
//        _secondSignView = [[MJSignView alloc] init];
//    }
//    return _secondSignView;
//}
//
///**
// *  3. 第三个小红点懒加载
// *
// *  @return
// */
//- (MJSignView *)thirdSignView
//{
//    if (!_thirdSignView)
//    {
//        _thirdSignView = [[MJSignView alloc] init];
//    }
//    return _thirdSignView;
//}
//
///**
// *  4. 第四个小红点懒加载
// *
// *  @return 
// */
//- (MJSignView *)forthSignView
//{
//    if (!_forthSignView)
//    {
//        _forthSignView = [[MJSignView alloc] init];
//    }
//    return _forthSignView;
//}


#pragma mark - 初始化添加小红点和加载xib
/**
 *  初始化添加小红点和加载xib
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //  1. 初始化加载xib
        self = [[[NSBundle mainBundle]loadNibNamed:@"MJCustomNavView"
                                             owner:self
                                           options:nil]
                lastObject];
        CGFloat x = (systemSize.width - 250) * 0.5;
        self.frame = CGRectMake(x, 10, 250, 30);
        //  2. 添加小红点
        self.firstSignView.hidden   = YES;
        self.secondSignView.hidden  = YES;
        self.thirdSignView.hidden   = YES;
        self.forthSignView.hidden   = YES;
        [self addSubview:self.firstSignView];
        [self addSubview:self.secondSignView];
        [self addSubview:self.thirdSignView];
        [self addSubview:self.forthSignView];
        
//        [MJNotifCenter addObserver:self selector:@selector(firstMeetRedNoHidden) name:@"firstMeetRedNoHidden" object:nil];
//        [MJNotifCenter addObserver:self selector:@selector(firstMeetRedHidden) name:@"firstMeetRedHidden"   object:nil];
        //  3. 接收会话新消息通知
//        [MJNotifCenter addObserver:self selector:@selector(rongYunNewMessage:) name:notificationRongYunName object:nil];
    }
    return self;
}

//- (void)firstMeetRedNoHidden
//{
//    self.thirdSignView.hidden = NO;
//}
//
//- (void)firstMeetRedHidden
//{
//    self.thirdSignView.hidden = YES;
//}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    self.segmentControl.selectedSegmentIndex = _selectedIndex;
}
/**
 *  设置frame
 *
 *  @param rect rect
 */
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat width   = rect.size.width;
    CGFloat height  = rect.size.height;
    CGFloat forthW  = rect.size.width * 0.25;
    CGFloat eightW  = forthW * 0.5;
    CGFloat minW    = eightW * 0.5;
    
    //  1. 设置第一个红点位置
    self.firstSignView.frame    = CGRectMake(forthW - minW, height * 0.25, signSWH, signSWH);
    //  2. 设置第二个红点位置
    self.secondSignView.frame   = CGRectMake(forthW * 2 - minW, height * 0.25, signSWH, signSWH);
    //  3. 设置第三个红点位置
    self.thirdSignView.frame    = CGRectMake(forthW * 3 - minW, height * 0.25, signSWH, signSWH);
    //  4. 设置第四个红点位置
    self.forthSignView.frame    = CGRectMake(width - minW, height * 0.25, signSWH, signSWH);
    
}


/**
 *  类方法
 *
 *  @return
 */
+ (instancetype)vustomNav
{
    return [[self alloc] init];
}


#pragma mark - 分段控件值改变
/**
 *  分段控件值改变
 *
 *  @param sender
 */
- (IBAction)segmentedC:(UISegmentedControl *)sender
{
    
    self.selectedIndex = self.segmentControl.selectedSegmentIndex;
    //  当值改变，调用代理
    if ([self.delegate respondsToSelector:@selector(customNavView:segmentControlSelected:)]) {
        [self.delegate customNavView:self segmentControlSelected:sender.selectedSegmentIndex];
    }
}

//#pragma mark - 收到融云新消息通知
///**
// *  收到融云新消息通知
// *
// *  @param notification 通知内容
// */
//- (void)rongYunNewMessage:(NSNotification *)notification
//{
//    NSDictionary *dic = notification.userInfo;
//    self.firstSignView.drawStr = [dic objectForKey:notificationNewMessCountKey];
//}


@end
