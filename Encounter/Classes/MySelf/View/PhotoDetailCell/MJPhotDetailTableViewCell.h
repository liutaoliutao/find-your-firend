//
//  MJPhotDetailTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 28/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MJPhotoDetailUserCellModel,MJPhotDetailTableViewCell;



@protocol MJPhotDetailTableViewCellDelegate <NSObject>

@optional
/**
 *  头像点击代理方法
 *
 *  @param photoDetailTVC 本类
 *  @param headImgView    头像
 */
- (void)photoDetailTVC:(MJPhotDetailTableViewCell *) photoDetailTVC didClickHeadImgView:(UIImageView *)headImgView;

/**
 *  图片信息点击代理方法
 *
 *  @param photoDetailTVC 本类
 *  @param imgMessageView 图片信息
 */
- (void)photoDetailTVC:(MJPhotDetailTableViewCell *) photoDetailTVC didClickImgMessageView:(UIImageView *)imgMessageView;

/**
 *  赞按钮点击代理方法
 *
 *  @param photoDetailTVC 本类
 *  @param imgMessageView 图片信息
 */
- (void)photoDetailTVC:(MJPhotDetailTableViewCell *) photoDetailTVC didClickgoodBtn:(UIButton *)goodBtn withImgId:(NSInteger)imgId;

@end







@interface MJPhotDetailTableViewCell : UITableViewCell


/** 数据模型 */
@property (nonatomic,strong) MJPhotoDetailUserCellModel *pthoDetailUserCellModel;
/** 代理 */
@property (nonatomic,weak) id<MJPhotDetailTableViewCellDelegate> delegate;
/** 蒙版view */
@property (nonatomic,weak) UIView *maskingView;
/** 蒙版图片 */
@property (nonatomic,weak) UIImageView *maskingImgView;

/**
 *  可重用tableViewCell
 *
 *  @param tableView tableView
 *
 *  @return cell
 */
+ (instancetype)photoDetailTableViewCellWithTableView:(UITableView *) tableView;


@end
