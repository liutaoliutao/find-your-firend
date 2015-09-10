//
//  MJChatListTableVIewCellModel.h
//  Encounter
//
//  Created by mac on 15/6/4.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJChatListTableVIewCellModel : NSObject

/** 头像url */
@property (nonatomic,copy) NSString *headImgUrlStr;
/** 昵称 */
@property (nonatomic,copy) NSString *nameStr;
/** 时间 */
@property (nonatomic,copy) NSString *timeStr;
/** 描述 */
@property (nonatomic,copy) NSString *discStr;


/**
 *  模型类方法
 *
 *  @return 返回模型
 */
+ (instancetype)chatListTVCCellModel;


@end
