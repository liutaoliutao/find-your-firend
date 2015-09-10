//
//  MJBlackListCoverView.h
//  Encounter
//
//  Created by 李明军 on 10/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJBlackListCoverView;
@protocol MJBlackListCoverViewDelegate <NSObject>

/**
 *  点击取消按钮代理
 *
 *  @param blackListCV 黑名单覆盖物
 *  @param sender      取消按钮
 */
- (void)blackListCoverView:(MJBlackListCoverView *)blackListCV didClickCancelButton:(UIButton *)sender;

@optional

/**
 *  点击举报按钮代理
 *
 *  @param blackListCV 黑名单覆盖物
 *  @param sender      取消按钮
 */
- (void)blackListCoverView:(MJBlackListCoverView *)blackListCV didClickAlarmButton:(UIButton *)sender;

/**
 *  点击拉黑按钮代理
 *
 *  @param blackListCV 黑名单覆盖物
 *  @param sender      取消按钮
 */
- (void)blackListCoverView:(MJBlackListCoverView *)blackListCV didClickAddBlackButton:(UIButton *)sender;

@end


@interface MJBlackListCoverView : UIView


/** 按钮点击代理 */
@property (nonatomic,weak) id<MJBlackListCoverViewDelegate> delegate;


/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)blackListCoverView;

@end
