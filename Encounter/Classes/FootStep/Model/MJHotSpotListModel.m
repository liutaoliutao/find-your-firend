//
//  MJHotSpotListModel.m
//  Encounter
//
//  Created by 李明军 on 16/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJHotSpotListModel.h"

@implementation MJHotSpotListModel


/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)hotspotModelWithDic:(NSDictionary *)dic
{
    MJHotSpotListModel *hotSpotModel = [[MJHotSpotListModel alloc] init];
    [hotSpotModel setValuesForKeysWithDictionary:dic];
    return hotSpotModel;
}

/**
 *  请求结果转为模型数组
 *
 *  @param array 结果数组
 *
 *  @return 模型数组
 */
+ (NSArray *)hotspotModelsWithArray:(NSArray *)array
{
    NSMutableArray *hotspotModelsArray = [NSMutableArray array];
    
    for (NSDictionary *dic in array)
    {
        MJHotSpotListModel *hotspotModel = [MJHotSpotListModel hotspotModelWithDic:dic];
        [hotspotModelsArray addObject:hotspotModel];
    }
    return hotspotModelsArray;
    
}


@end
