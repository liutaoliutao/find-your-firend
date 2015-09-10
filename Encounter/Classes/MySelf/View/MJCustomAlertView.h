//
//  MJCustomAlertView.h
//  Encounter
//
//  Created by 李明军 on 24/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJCustomAlertView;
@protocol kMJCustomAlertViewDelegate <NSObject>

@optional
/**
 *  自定义弹窗
 *
 *  @param customView
 *  @param sender
 */
- (void)mjcustomAlertView:(MJCustomAlertView *)customView didClickYesBtn:(id)sender WithCommentId:(NSInteger)commentId;

/**
 *  自定义弹窗
 *
 *  @param customView
 *  @param sender
 */
- (void)mjcustomAlertView:(MJCustomAlertView *)customView didClickNoBtn:(id)sender;



@end


@interface MJCustomAlertView : UIView

/** 文字 */
@property (nonatomic,copy) NSString *labelStr;
/** daili */
@property (nonatomic,weak) id<kMJCustomAlertViewDelegate> delegate;
/** 评论id */
@property (nonatomic,assign) NSInteger commentId;

@end
