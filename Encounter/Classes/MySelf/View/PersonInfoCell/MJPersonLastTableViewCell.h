//
//  MJPersonLastTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 9/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJPersonCellModel;
@interface MJPersonLastTableViewCell : UITableViewCell


/** 模型数据 */
@property (nonatomic,strong) MJPersonCellModel *personCellModel;

/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)latestTableViewCellWithTableView:(UITableView *)tableView;



@end
