//
//  MJRequestSpotModel.h
//  Encounter
//
//  Created by 李明军 on 6/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJRequestSpotModel : NSObject

/** 热点创建时间 */
@property (nonatomic,copy) NSString         *CreateTime;
/** delflag */
@property (nonatomic,assign) NSNumber       *DelFlag;
/** 是否位用户当前热点 */
@property (nonatomic,assign) NSInteger      HotspotId;
/** 是否位商圈用户 */
@property (nonatomic,copy) NSString         *HotspotType;
/** id */
@property (nonatomic,assign) NSNumber       *ID;
/** 图片url */
@property (nonatomic,copy) NSString         *Image;
/** lat */
@property (nonatomic,assign) double      Lat;
/** lon */
@property (nonatomic,assign) double      Long;
/** 地名 */
@property (nonatomic,copy) NSString         *PlaceName;
/** Remark */
@property (nonatomic,copy) NSString         *Remark;
/** title */
@property (nonatomic,copy) NSString         *Title;
/** 距离 */
@property (nonatomic,assign) NSInteger      distance;



/**
 *  返回模型数组
 *
 *  @return 返回数组
 */
+ (instancetype)requestSpotModel;

@end
