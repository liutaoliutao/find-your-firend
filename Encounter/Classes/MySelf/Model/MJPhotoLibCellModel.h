//
//  MJPhotoLibCellModel.h
//  Encounter
//
//  Created by mac on 15/5/31.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJPhotoLibCellModel : NSObject


/** 时间 */
@property (nonatomic,copy) NSString *Create_Time;
/** 图片url */
@property (nonatomic,copy) NSString *Contents;
/** 描述 */
@property (nonatomic,copy) NSString *Describe;
/** 热点 */
@property (nonatomic,copy) NSString *PlaceName;
/** title */
@property (nonatomic,copy) NSString *Title;
/** id */
@property (nonatomic,assign) NSInteger Recordid;
/**  */
@property (nonatomic,assign) NSInteger isDelete;
/** tim */
@property (nonatomic,copy) NSString *FormatTime;



/** 左边时间 */
@property (nonatomic,copy) NSString *leftTimeStr;
/** 左边图片url */
@property (nonatomic,copy) NSString *leftImgUrlStr;
/** 左边描述 */
@property (nonatomic,copy) NSString *leftDiscStr;
/** 左边热点 */
@property (nonatomic,copy) NSString *leftHotStr;
/** id */
@property (nonatomic,assign) NSInteger leftId;


/** 右边时间 */
@property (nonatomic,copy) NSString *rightTimeStr;
/** 右边图片url */
@property (nonatomic,copy) NSString *rightImgUrlStr;
/** 右边描述 */
@property (nonatomic,copy) NSString *rightDiscStr;
/** 右边热点 */
@property (nonatomic,copy) NSString *rightHotStr;
/** id */
@property (nonatomic,assign) NSInteger rightId;

/**
 *  数据模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)photoLibCellModelWithDic:(NSDictionary *)dic;

/**
 *  模型数组
 *
 *  @return 数组
 */
+ (NSArray *)photoLibCellModelsWithArray:(NSArray *)array withPageNum:(NSInteger)pageNum withPreArray:(NSArray *)preArray;





@end
