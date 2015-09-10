//
//  MJBottomCommentView.h
//  Encounter
//
//  Created by 李明军 on 28/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MJBottomCommentView;
@protocol MJBottomCommentViewDelegate <NSObject>

@optional

/**
 *  表情代理
 *
 *  @param bottomCommentV 底部评论toolbar
 *  @param faceBtn        表情按钮
 */
- (void)bottomCommentView:(MJBottomCommentView *)bottomCommentV didClickFaceBtn:(UIButton *)faceBtn;

/**
 *  发送代理
 *
 *  @param bottomCommentV 底部评论toolbar
 *  @param sendBtn        发送按钮
 */
- (void)bottomCommentView:(MJBottomCommentView *)bottomCommentV didClickSendBtn:(UIButton *)sendBtn withStr:(NSString *)str withCommentId:(NSInteger)commentId;

@end


@interface MJBottomCommentView : UIView

/** 是否显示引导文字 */
@property (nonatomic,assign,getter = isEnablePlaceholder) BOOL enablePlaceholder;
/** 代理 */
@property (nonatomic,weak) id<MJBottomCommentViewDelegate> delegate;


/** 评论消息框 */
@property (weak, nonatomic) IBOutlet UITextView *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UILabel *placeHolder;

/** 标识 */
/**  */
@property (nonatomic,copy) NSString *nickStr;
/** 评论id */
@property (nonatomic,assign) NSInteger commontId;

/**
 *  底部view类方法
 *
 *  @return 返回view对象
 */
+ (instancetype)bottomCommentView;

@end
