//
//  MJHistoryHotSpotModel.h
//  Encounter
//
//  Created by 李明军 on 17/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJHistoryHotSpotModel : NSObject

/** Content */
@property (nonatomic,copy)      NSString    *Content;
/** CreateTime */
@property (nonatomic,copy)      NSString    *CreateTime;
/** DelFlag */
@property (nonatomic,assign)    NSInteger   DelFlag;
/** HotspotId */
@property (nonatomic,assign)    NSInteger   HotspotId;
/** HotspotType */
@property (nonatomic,assign)    NSInteger   HotspotType;
/** ID */
@property (nonatomic,assign)    NSInteger   ID;
/** Image */
@property (nonatomic,copy)      NSString    *Image;
/** Lat */
@property (nonatomic,assign)    NSInteger   Lat;
/** Long */
@property (nonatomic,assign)    NSInteger   Long;
/** NickName */
@property (nonatomic,copy)      NSString    *NickName;
/** PlaceName */
@property (nonatomic,copy)      NSString    *PlaceName;
/** Remark */
@property (nonatomic,copy)      NSString    *Remark;
/** ServerTime */
@property (nonatomic,copy)      NSString    *ServerTime;
/** Title */
@property (nonatomic,copy)      NSString    *Title;
/** distance */
@property (nonatomic,assign)    NSInteger   distance;


/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)historyHotspotModelWithDic:(NSDictionary *)dic;

/**
 *  请求结果转为模型数组
 *
 *  @param array 结果数组
 *
 *  @return 模型数组
 */
+ (NSArray *)historyHotspotModelsWithArray:(NSArray *)array;


@end
