//
//  MJHistoryHotTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 17/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>



@class MJHistoryHotSpotModel;

typedef enum{
    kMJHistoryHotTableViewCellInStrCurrent = 70000,
    kMJHistoryHotTableViewCellInStrHistory
} kMJHistoryHotTableViewCellInStr;


@interface MJHistoryHotTableViewCell : UITableViewCell

/** model */
@property (nonatomic,strong) MJHistoryHotSpotModel *historyModel;

/** 进入通道标识 */
@property (nonatomic,assign) kMJHistoryHotTableViewCellInStr inStr;




/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)historyHotTVCWithTableView:(UITableView *)tableView;


@end
