//
//  MJGuanzhuTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 15/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJGuanZhuPersonModel,MJGuanzhuTableViewCell;


@protocol MJGuanzhuTableViewCellDelegate <NSObject>

@optional
/**
 *  头像点击代理方法
 *
 *  @param gianzhuCell cell
 *  @param headImgV    头像
 */
- (void)guanzhuTableViewCell:(MJGuanzhuTableViewCell *) gianzhuCell didSelectedHeadimg:(UIImageView *)headImgV;

@end



@interface MJGuanzhuTableViewCell : UITableViewCell


/** 数据模型 */
@property (nonatomic,strong) MJGuanZhuPersonModel *guanzhuModel;
/** 代理 */
@property (nonatomic,weak) id<MJGuanzhuTableViewCellDelegate> delegate;


/**
 *  tableView构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)guanzhuTableViewCellWithTableView:(UITableView *)tableView;


@end
