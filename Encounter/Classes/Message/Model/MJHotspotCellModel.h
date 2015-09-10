//
//  MJHotspotCellModel.h
//  Encounter
//
//  Created by 李明军 on 12/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MJHotspotCellModel : NSObject



/** 内容 */
@property (nonatomic,copy)          NSString    *Content;
/** 时间 */
@property (nonatomic,copy)          NSString    *CreateTime;
/** FormatTimer */
@property (nonatomic,copy)          NSString    *FormatTimer;
/** HeadImg */
@property (nonatomic,copy)          NSString    *HeadImg;
/** 类型 */
@property (nonatomic,assign)        NSInteger   IntType;
/** 项目id */
@property (nonatomic,assign)        NSInteger   ItemId;
/** 昵称 */
@property (nonatomic,copy)          NSString    *NickName;
/** 图片id */
@property (nonatomic,copy)        NSString    *PhotoId;
/** 图片url */
@property (nonatomic,copy)          NSString    *PhotoUrl;
/** SysTimer */
@property (nonatomic,copy)          NSString    *SysTimer;
/** Timer */
@property (nonatomic,copy)          NSString    *Timer;
/** title */
@property (nonatomic,copy)          NSString    *Title;
/** 用户id */
@property (nonatomic,assign)        NSInteger   UserId;




/** 文字cell时间frame */
@property (nonatomic,assign) CGRect textTimeFrame;
/** 文字contentframe */
@property (nonatomic,assign) CGRect textContentFrame;
/** 文字cell头像frame */
@property (nonatomic,assign) CGRect textheadImgFrame;

/** 文字cell高度 */
@property (nonatomic,assign) CGFloat textCellHeight;

/** 照片cell时间 */
@property (nonatomic,assign) CGRect photoTimeFrame;
/** 照片cell头像 */
@property (nonatomic,assign) CGRect photoHeadImgFrame;
/** 照片cell照片 */
@property (nonatomic,assign) CGRect photoImgFrame;
/** 照片cell描述 */
@property (nonatomic,assign) CGRect photoDiscFrame;

/** 照片cell高度 */
@property (nonatomic,assign) CGFloat photoCellHeight;

/**
 *  计算文字cell高度
 *
 *  @return
 */
- (void)setTextFrame;

/**
 *  计算照片cell高度
 *
 *  @return
 */
- (void)setPhotoFrame;

/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)hotspotCellModelWithDic:(NSDictionary *)dic;

/**
 *  数组转模型数组
 *
 *  @param array 数组
 *
 *  @return 模型数组
 */
+ (NSArray *)hotspotCellModelsWithArray:(NSArray *)array;


@end
