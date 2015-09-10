//
//  MJHotspotTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 16/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MJHotSpotListModel;
@interface MJHotspotTableViewCell : UITableViewCell

/** 模型数据 */
@property (nonatomic,strong) MJHotSpotListModel *hotspotListModel;

/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)hotspotTabCellWithTableView:(UITableView *)tableView;

@end
