//
//  MJPhotoLibViewController.h
//  Encounter
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kMJPhotoLibViewControllerSignSelf = 72000,
    kMJPhotoLibViewControllerSignOther
}kMJPhotoLibViewControllerSign;

@interface MJPhotoLibViewController : UIViewController

/**  */
@property (nonatomic,strong) NSDictionary *dic;
/** 进入通道标识 */
@property (nonatomic,assign) kMJPhotoLibViewControllerSign inSign;
/** userid */
@property (nonatomic,copy) NSString *userId;


@end
