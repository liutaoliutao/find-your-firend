//
//  MJHotSpotListModel.h
//  Encounter
//
//  Created by 李明军 on 16/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJHotSpotListModel : NSObject

/** CreateTime */
@property (nonatomic,copy)          NSString *CreateTime;
/** DelFlag */
@property (nonatomic,assign)        NSInteger DelFlag;
/** HotspotId */
@property (nonatomic,assign)        NSInteger HotspotId;
/** HotspotType */
@property (nonatomic,assign)        NSInteger HotspotType;
/** ID */
@property (nonatomic,assign)        NSInteger ID;
/** Image */
@property (nonatomic,copy)          NSString *Image;
/** Lat */
@property (nonatomic,assign)        NSInteger Lat;
/** Long */
@property (nonatomic,assign)        NSInteger Long;
/** PlaceName */
@property (nonatomic,copy)          NSString *PlaceName;
/** Ranking */
@property (nonatomic,assign)        NSInteger Ranking;
/** Remark */
@property (nonatomic,copy)          NSString *Remark;
/** Title */
@property (nonatomic,copy)          NSString *Title;
/** distance */
@property (nonatomic,assign)        double distance;

/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)hotspotModelWithDic:(NSDictionary *)dic;

/**
 *  请求结果转为模型数组
 *
 *  @param array 结果数组
 *
 *  @return 模型数组
 */
+ (NSArray *)hotspotModelsWithArray:(NSArray *)array;


@end
