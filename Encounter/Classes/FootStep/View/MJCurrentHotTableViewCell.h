//
//  MJCurrentHotTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 30/6/15.
//  Copyright (c) 2015年 AiTa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJHotSpotListModel;
@interface MJCurrentHotTableViewCell : UITableViewCell

/** 数据模型 */
@property (nonatomic,strong) MJHotSpotListModel *hotListModel;

/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)currentHotTableViewCellWithTableView:(UITableView *)tableView;

@end
