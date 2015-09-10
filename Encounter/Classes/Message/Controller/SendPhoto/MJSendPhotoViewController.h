//
//  MJSendPhotoViewController.h
//  Encounter
//
//  Created by 李明军 on 23/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJSendPhotoViewController;
@protocol MJSendPhotoViewControllerDelegate <NSObject>

@optional

/**
 *  点击了发送按钮代理
 *
 *  @param sendPhotoVC
 *  @param sendBtn
 */
- (void)sendPhotoViewC:(MJSendPhotoViewController *)sendPhotoVC didClickSendBtn:(UIButton *)sendBtn;

@end


@interface MJSendPhotoViewController : UIViewController


/** 热点区 */
@property (nonatomic,copy) NSString *hotPlaceStr;
/** hotId */
@property (nonatomic,assign) NSInteger hotId;
/** 地址 */
@property (nonatomic,copy) NSString *addressStr;
/** 代理 */
@property (nonatomic,weak) id<MJSendPhotoViewControllerDelegate> delegate;


@end
