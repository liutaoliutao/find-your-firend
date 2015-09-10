//
//  MJPersonPhotoTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 9/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MJPersonPhotoTableViewCell;
@protocol MJPersonPhotoTableViewCellDelegate <NSObject>

@optional
/**
 *  点击相册cell代理
 *
 *  @param personPhotoTVC
 *  @param btn
 */
- (void)personPhotoTVC:(MJPersonPhotoTableViewCell *)personPhotoTVC didClickBtn:(UIButton *)btn withUserId:(NSString *)userid withDic:(NSDictionary *)dic;

@end


@interface MJPersonPhotoTableViewCell : UITableViewCell

/** 数据源数组 */
@property (nonatomic,strong) NSArray *photoUrlStrArray;
/** userid */
@property (nonatomic,copy) NSString *userid;
/** dic */
@property (nonatomic,strong) NSDictionary *dic;
/**  */
@property (nonatomic,weak) id<MJPersonPhotoTableViewCellDelegate> delegate;

/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)photoTableViewCellWithTableView:(UITableView *)tableView;

@end
