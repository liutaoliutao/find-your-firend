//
//  MJGuanZhuPersonModel.h
//  Encounter
//
//  Created by 李明军 on 15/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJGuanZhuPersonModel : NSObject

/** Age */
@property (nonatomic,assign)    NSInteger Age;
/** Appellation */
@property (nonatomic,copy)      NSString *Appellation;
/** Create_time */
@property (nonatomic,copy)      NSString *Create_time;
/** Headimg */
@property (nonatomic,copy)      NSString *Headimg;
/** Lastlogintime */
@property (nonatomic,copy)      NSString *Lastlogintime;
/** Lastmeetplace */
@property (nonatomic,copy)      NSString *Lastmeetplace;
/** Lastmeettime */
@property (nonatomic,copy)      NSString *Lastmeettime;
/** Luckprice */
@property (nonatomic,assign)    NSNumber *Luckprice;
/** Motto */
@property (nonatomic,copy)      NSString *Motto;
/** Nickname */
@property (nonatomic,copy)      NSString *Nickname;
/** Sex */
@property (nonatomic,assign)    NSInteger Sex;
/** Userid */
@property (nonatomic,assign)    NSInteger Userid;

/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)guanzhuPersonModelWithDic:(NSDictionary *)dic;

/**
 *  请求结果转为模型数组
 *
 *  @param array 结果数组
 *
 *  @return 模型数组
 */
+ (NSArray *)guanzhuPersonModelsWithArray:(NSArray *)array;


@end
