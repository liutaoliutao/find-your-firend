//
//  MJMyMessageTableViewController.h
//  Encounter
//
//  Created by 李明军 on 8/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kMJMyMessageTableViewControllerInIdStrGuanzhu  = 30000,
    kMJMyMessageTableViewControllerInIdStrFirstMeet,
    kMJMyMessageTableViewControllerInIdStrRepeatMeet,
    kMJMyMessageTableViewControllerInIdStrRongYun
}kMJMyMessageTableViewControllerInIdStr;

@interface MJMyMessageTableViewController : UIViewController

/** 进入标识，自己或他人 */
@property (nonatomic,copy) NSString                                 *userId;
/** 进入通道标识 */
@property (nonatomic,assign) kMJMyMessageTableViewControllerInIdStr inIdStr;
/** 是否有红点 */
@property (nonatomic,assign) BOOL                                   redSpotIsHidden;


@end
