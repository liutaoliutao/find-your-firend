
//
//  MJGuanZhuPersonModel.m
//  Encounter
//
//  Created by 李明军 on 15/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJGuanZhuPersonModel.h"

@implementation MJGuanZhuPersonModel


/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)guanzhuPersonModelWithDic:(NSDictionary *)dic
{
    MJGuanZhuPersonModel *guanzhuModel = [[MJGuanZhuPersonModel alloc]init];
    [guanzhuModel setValuesForKeysWithDictionary:dic];
    return guanzhuModel;
}

/**
 *  请求结果转为模型数组
 *
 *  @param array 结果数组
 *
 *  @return 模型数组
 */
+ (NSArray *)guanzhuPersonModelsWithArray:(NSArray *)array
{
    NSMutableArray *guanzhuModelsArray = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        MJGuanZhuPersonModel *guanzhuModel = [MJGuanZhuPersonModel guanzhuPersonModelWithDic:dic];
        [guanzhuModelsArray addObject:guanzhuModel];
    }
    return guanzhuModelsArray;
}



@end
