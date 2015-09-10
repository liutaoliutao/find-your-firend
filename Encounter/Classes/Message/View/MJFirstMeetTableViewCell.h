//
//  MJFirstMeetTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 15/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kMJFirstMeetTableViewCellInStrFirstMeet = 50000,
    kMJFirstMeetTableViewCellInStrRepeatMeet
} kMJFirstMeetTableViewCellInStr;

@class MJFirstMeetModel;
@interface MJFirstMeetTableViewCell : UITableViewCell


/** 模型 */
@property (nonatomic,strong) MJFirstMeetModel *firstMeetModel;
/** 进入通道标识 */
@property (nonatomic,assign) kMJFirstMeetTableViewCellInStr inStr;


/**
 *  初遇cell构造方法
 *
 *  @param tableView tableview
 *
 *  @return
 */
+ (instancetype)firstMeetTVCellWithTableView:(UITableView *)tableView;

@end
