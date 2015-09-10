//
//  MJFaceKeyBoardView.h
//  Encounter
//
//  Created by 李明军 on 18/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJFaceKeyBoardViewDelegate <NSObject>

@optional

/**
 *  表情键盘选中表情代理
 *
 *  @param faceBtnImgStr
 */
- (void)faceKeyBoardDidSelectedFaceBtnWithFaceBtnStr:(NSString *)faceBtnImgStr;

@end


@interface MJFaceKeyBoardView : UIView


/** 表情键盘代理 */
@property (nonatomic,weak) id<MJFaceKeyBoardViewDelegate> delegate;

@end
