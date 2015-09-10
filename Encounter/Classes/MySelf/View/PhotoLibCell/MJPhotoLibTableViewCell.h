//
//  MJPhotoLibTableViewCell.h
//  Encounter
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJPhotoLibCellModel,MJPhotoLibTableViewCell;


@protocol MJPhotoLibTableViewCellDelegate <NSObject>

@optional
/**
 *  点击图片代理方法
 *
 *  @param photoLibTVC 本类
 *  @param imgView     图片view
 */
- (void)photoLibTableViewCell:(MJPhotoLibTableViewCell *)photoLibTVC tapImgView:(UIImageView *)imgView withImgId:(NSInteger)imgid;

/**
 *  点击删除代理
 *
 *  @param photoLibTVC
 *  @param btn
 *  @param model
 */
- (void)photoLibTableViewCell:(MJPhotoLibTableViewCell *)photoLibTVC clickDeleteBtn:(UIButton *)btn withModel:(MJPhotoLibCellModel *)model withId:(NSInteger)imgId;



@end



@interface MJPhotoLibTableViewCell : UITableViewCell


/**  */
@property (nonatomic,assign) NSInteger inNum;

/** 左边模型 */
@property (nonatomic,strong) MJPhotoLibCellModel *leftCellModel;

/** 右边模型 */
@property (nonatomic,strong) MJPhotoLibCellModel *rightCellModel;

/** 图片点击代理 */
@property (nonatomic,weak) id<MJPhotoLibTableViewCellDelegate> delegate;


/**
 *  自定义cell类方法
 */
+ (instancetype)photoLibTableViewCellWithTableView:(UITableView *) tableView;



@end
