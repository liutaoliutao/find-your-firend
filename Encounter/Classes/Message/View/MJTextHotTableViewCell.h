//
//  MJTextHotTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 17/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJHotspotCellModel,MJTextHotTableViewCell;

@protocol MJTextHotTableViewCellDelegate <NSObject>

@optional

/**
 *  头像点击代理方法
 *
 *  @param textHotTVC cell
 *  @param userId     userId
 */
- (void)textHotTableViewCell:(MJTextHotTableViewCell *)textHotTVC didClickHeadWithUserId:(NSString *)userId;

@end



@interface MJTextHotTableViewCell : UITableViewCell

/** 热点模型 */
@property (nonatomic,strong) MJHotspotCellModel *hotspotCellModel;
/** 代理 */
@property (nonatomic,weak) id<MJTextHotTableViewCellDelegate> delegate;

/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)textHotTableViewCell:(UITableView *)tableView;

@end
