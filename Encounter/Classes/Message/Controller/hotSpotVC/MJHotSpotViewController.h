//
//  MJHotSpotViewController.h
//  Encounter
//
//  Created by 李明军 on 17/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJHotSpotViewController : UIViewController

/** title */
@property (nonatomic,copy) NSString *navTitle;
/** lat */
@property (nonatomic,assign) double lat;
/** lon */
@property (nonatomic,assign) double lon;
/** hotId */
@property (nonatomic,assign) NSInteger hotId;

@end
