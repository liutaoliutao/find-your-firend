//
//  MJHistoryHotSpotModel.m
//  Encounter
//
//  Created by 李明军 on 17/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJHistoryHotSpotModel.h"

@implementation MJHistoryHotSpotModel

/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)historyHotspotModelWithDic:(NSDictionary *)dic
{
    MJHistoryHotSpotModel *historyModel = [[MJHistoryHotSpotModel alloc] init];
    [historyModel setValuesForKeysWithDictionary:dic];
    return historyModel;
}

/**
 *  请求结果转为模型数组
 *
 *  @param array 结果数组
 *
 *  @return 模型数组
 */
+ (NSArray *)historyHotspotModelsWithArray:(NSArray *)array
{
    NSMutableArray *historyModelArray = [NSMutableArray array];
    
    for (NSDictionary *dic in array)
    {
        MJHistoryHotSpotModel *historyHotModel = [MJHistoryHotSpotModel historyHotspotModelWithDic:dic];
        [historyModelArray addObject:historyHotModel];
    }
    return historyModelArray;
}




@end
