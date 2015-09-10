//
//  MJBottomCommentView.m
//  Encounter
//
//  Created by 李明军 on 28/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJBottomCommentView.h"


@interface MJBottomCommentView()



@end



@implementation MJBottomCommentView

/**
 *  设置是否显示placeHolder
 */
- (void)setEnablePlaceholder:(BOOL)enablePlaceholder
{
    _enablePlaceholder = enablePlaceholder;
    if (_enablePlaceholder)
    {
        if (self.nickStr) {
//            self.commentLabel.textColor = [UIColor lightGrayColor];
//            self.commentLabel.text  = [NSString stringWithFormat:@"回复%@：等待输入信息",self.nickStr];
//            [self.commentLabel setPlaceholder:[NSString stringWithFormat:@"回复%@：等待输入信息",self.nickStr]];
            self.placeHolder.text = [NSString stringWithFormat:@"回复%@：",self.nickStr];
        }
        else
        {
//            self.commentLabel.textColor = [UIColor lightGrayColor];
//            self.commentLabel.text  = @"评论：请输入";
//            [self.commentLabel setPlaceholder:@"评论：请输入"];
            self.placeHolder.text = @"请输入";
        }
        
    }
    else
    {
//        self.commentLabel.textColor = [UIColor lightGrayColor];
//        self.commentLabel.text  = @"";
//        [self.commentLabel setPlaceholder:@""];
        self.nickStr          = nil;
        self.placeHolder.text = @"";
    }
}




/**
 *  初始化view
 *
 *  @return self
 */
- (instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJButtomCommentView" owner:self options:nil] firstObject];
        self.commentLabel.layer.borderColor = UIColor.grayColor.CGColor;
        self.commentLabel.layer.borderWidth = 1;
        self.commentLabel.layer.cornerRadius = 6;
        self.commentLabel.layer.masksToBounds = YES;
    }
    return self;
}



#pragma mark - 监听控件事件

/**
 *  评论按钮点击事件
 *
 *  @param sender 评论按钮
 */
- (IBAction)commentBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(bottomCommentView:didClickSendBtn:withStr:withCommentId:)])
    {
        [self.delegate bottomCommentView:self didClickSendBtn:sender withStr:self.nickStr withCommentId:self.commontId];
    }
}


/**
 *  表情按钮点击事件
 *
 *  @param sender 表情按钮
 */
- (IBAction)lookBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(bottomCommentView:didClickFaceBtn:)])
    {
        [self.delegate bottomCommentView:self didClickFaceBtn:sender];
    }
}


/**
 *  底部view类方法
 *
 *  @return 返回view对象
 */
+ (instancetype)bottomCommentView
{
    return [[self alloc]init];
}

@end
