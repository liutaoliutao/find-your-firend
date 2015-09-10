//
//  MJLoveSelectedView.h
//  Encounter
//
//  Created by 李明军 on 27/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJLoveSelectedView;
@protocol MJLoveSelectedViewDelegate <NSObject>

/**
 *  选中情感状态代理
 *
 *  @param loveSelectedView   情感状态选择器
 *  @param selectedLoveString 选中的情感状态字符串
 */
- (void)loveSelectedView:(MJLoveSelectedView *)loveSelectedView selectedLoveString:(NSString *)selectedLoveString;

@end


@interface MJLoveSelectedView : UIView

/** 选中情感状态代理 */
@property (nonatomic,weak) id<MJLoveSelectedViewDelegate> delegate;

@end
