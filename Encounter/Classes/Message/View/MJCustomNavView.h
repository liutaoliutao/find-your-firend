//
//  MJCustomNavView.h
//  Encounter
//
//  Created by 李明军 on 7/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJSignView.h"

@class MJCustomNavView;
@protocol MJCustomNavViewDelegate <NSObject>

- (void)customNavView:(MJCustomNavView *)customView segmentControlSelected:(NSInteger) segmentControlSelected;

@end


@interface MJCustomNavView : UIView


/** 第一个小红点 */
@property (nonatomic,strong)IBOutlet MJSignView *firstSignView;
/** 第二个小红点 */
@property (nonatomic,strong)IBOutlet MJSignView *secondSignView;
/** 第三个小红点 */
@property (nonatomic,strong)IBOutlet MJSignView *thirdSignView;
/** 第四个小红点 */
@property (nonatomic,strong)IBOutlet MJSignView *forthSignView;
/** 代理 */
@property (nonatomic,weak) id<MJCustomNavViewDelegate> delegate;

/** 选中 */
@property (nonatomic,assign) NSInteger selectedIndex;

/**
 *  类方法
 *
 *  @return
 */
+ (instancetype)vustomNav;

@end
