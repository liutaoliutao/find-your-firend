//
//  MJPersonCellModel.h
//  Encounter
//
//  Created by 李明军 on 9/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJPersonCellModel : NSObject


/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 内容 */
@property (nonatomic,copy) NSString *content;

/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)personCellModel;

@end
