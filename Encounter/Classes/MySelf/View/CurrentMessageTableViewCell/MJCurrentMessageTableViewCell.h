//
//  MJCurrentMessageTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 27/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJCurrentMessageCellModel;
@interface MJCurrentMessageTableViewCell : UITableViewCell

/** 模型 */
@property (nonatomic,strong) MJCurrentMessageCellModel *currentModel;

/**
 *  加载cell类方法
 *
 *  @return 返回cell
 */
+ (instancetype)currentMessageTableViewCellWithTableView:(UITableView *) tableView;

@end
