//
//  MJHotBottomView.h
//  Encounter
//
//  Created by 李明军 on 18/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJHotBottomView;
@protocol MJHotBottomViewDelegate <NSObject>

@optional

/**
 *  发送按钮点击事件
 *
 *  @param hotBottomView MJHotBottomView
 *  @param sendBtn       发送按钮
 */
- (void)hotBottomView:(MJHotBottomView *)hotBottomView didClickSendBtnWithTButton:(UIButton *)sendBtn;

/**
 *  照片按钮点击代理
 *
 *  @param hotBottomView MJHotBottomView
 *  @param photoBtn      照片按钮
 */
- (void)hotBottomView:(MJHotBottomView *)hotBottomView didClickPhotoBtnWithButton:(UIButton *)photoBtn;

/**
 *  表情按钮代理
 *
 *  @param hotBottomView MJHotBottomView
 *  @param faceBtn       表情按钮
 */
- (void)hotBottomView:(MJHotBottomView *)hotBottomView didClickFaceBtnWithButton:(UIButton *)faceBtn;

@end

@interface MJHotBottomView : UIView

/** 代理 */
@property (nonatomic,weak) id<MJHotBottomViewDelegate> delegate;
/** 聊天输入框 */
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)hotspotBottomView;

@end
