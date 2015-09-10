//
//  MJMyselfHeadTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 29/6/15.
//  Copyright (c) 2015年 AiTa. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MJMyselfHeadTableViewCell;
@protocol MJMyselfHeadTableViewCellDelegate <NSObject>

@optional

/**
 *  背景点击代理
 *
 *  @param myselfTVC
 *  @param bgImgV
 */
- (void)myselfHeadTVC:(MJMyselfHeadTableViewCell *)myselfTVC didClickBgImgV:(UIImageView *)bgImgV;

/**
 *  新消息点击代理
 *
 *  @param myselfTVC
 *  @param currentMessageBtn 
 */
- (void)myselfHeadTVC:(MJMyselfHeadTableViewCell *)myselfTVC didClickCurrentMessageBtn:(UIButton *)currentMessageBtn;

@end


@interface MJMyselfHeadTableViewCell : UITableViewCell

/** 数据 */
@property (nonatomic,strong) NSDictionary *dic;
/**  */
@property (nonatomic,strong) UIImage *bgImg;
/** 背景点击代理 */
@property (nonatomic,weak) id<MJMyselfHeadTableViewCellDelegate> delegate;

/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)myselfHeadTVCWithTableView:(UITableView *)tableView;

@end
