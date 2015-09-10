//
//  MJPhotoDetailTableViewController.h
//  Encounter
//
//  Created by 李明军 on 28/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kMJPhotoDetailTableViewControllerInStrOther = 73000,
    kMJPhotoDetailTableViewControllerInStrSelf
}kMJPhotoDetailTableViewControllerInSignStr;

//typedef enum{
//    kMJPhotoLibViewControllerSignSelf = 72000,
//    kMJPhotoLibViewControllerSignOther
//}kMJPhotoLibViewControllerSign;




@interface MJPhotoDetailTableViewController : UITableViewController

/** imgId */
@property (nonatomic,assign) NSInteger imgId;
/** userid */
@property (nonatomic,copy) NSString *userid;
/** 进入通道标识 */
@property (nonatomic,assign) kMJPhotoDetailTableViewControllerInSignStr insign;

@end
