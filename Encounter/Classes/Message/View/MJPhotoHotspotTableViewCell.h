//
//  MJPhotoHotspotTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 18/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MJHotspotCellModel,MJPhotoHotspotTableViewCell;

@protocol MJPhotoHotspotTableViewCellDelegate <NSObject>

@optional
/**
 *  图片点击代理方法
 *
 *  @param photoTVC
 *  @param imgId
 */
- (void)photoHotspotTVC:(MJPhotoHotspotTableViewCell *)photoTVC didClickPhotoWithImgId:(NSString *)imgId WithUserId:(NSString *)userid;

/**
 *  头像点击代理方法
 *
 *  @param photoTVC
 *  @param imgId
 */
- (void)photoHotspotTVC:(MJPhotoHotspotTableViewCell *)photoTVC didClickHeadWithUserId:(NSString *)imgId;


@end

@interface MJPhotoHotspotTableViewCell : UITableViewCell


/** 模型数据 */
@property (nonatomic,strong) MJHotspotCellModel *hotspotCellModel;
/** 代理 */
@property (nonatomic,weak) id<MJPhotoHotspotTableViewCellDelegate> delegate;

/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)photoHotspotTVCellWithTableView:(UITableView *)tableView;

@end
