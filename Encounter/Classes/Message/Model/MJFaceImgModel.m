//
//  MJFaceImgModel.m
//  Encounter
//
//  Created by 李明军 on 10/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJFaceImgModel.h"



@implementation MJFaceImgModel


/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)faceImgModelWithDic:(NSDictionary *)dic
{
    MJFaceImgModel *faceModel = [[MJFaceImgModel alloc] init];
    [faceModel setValuesForKeysWithDictionary:dic];
    return faceModel;
}

/**
 *  返回模型数组
 *
 *  @return
 */
+ (NSArray *)faceModels
{
    NSString *path      = [[NSBundle mainBundle]pathForResource:@"MJTextAndImage" ofType:@"plist"];
    NSArray *dicArray   = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *faceModelsArray = [NSMutableArray array];
    
    for (NSDictionary *dic in dicArray)
    {
        MJFaceImgModel *faceModel = [MJFaceImgModel faceImgModelWithDic:dic];
        [faceModelsArray addObject:faceModel];
    }
    return faceModelsArray;
}

+ (MJFaceImgModel *)faceImgModelWithStr:(NSString *)str
{
    NSArray *faceImgModelArray = [MJFaceImgModel faceModels];
    for (MJFaceImgModel *faceImgModel in faceImgModelArray)
    {
        if ([str isEqualToString:faceImgModel.imgName]) return faceImgModel;
    }
    return nil;
}



@end
