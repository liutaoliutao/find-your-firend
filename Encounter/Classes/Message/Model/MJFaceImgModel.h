//
//  MJFaceImgModel.h
//  Encounter
//
//  Created by 李明军 on 10/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJFaceImgModel : NSObject

/** 图片名称 */
@property (nonatomic,copy) NSString *imgName;

/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)faceImgModelWithDic:(NSDictionary *)dic;

/**
 *  返回模型数组
 *
 *  @return
 */
+ (NSArray *)faceModels;

+ (MJFaceImgModel *)faceImgModelWithStr:(NSString *)str;


@end
