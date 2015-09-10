//
//  MJFirstMeetModel.m
//  Encounter
//
//  Created by 李明军 on 15/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJFirstMeetModel.h"

@implementation MJFirstMeetModel


/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)firstMeetModelWithDic:(NSDictionary *)dic
{
    MJFirstMeetModel *firstMeetModel = [[MJFirstMeetModel alloc] init];
    [firstMeetModel setValuesForKeysWithDictionary:dic];
    return firstMeetModel;
}

/**
 *  请求结果转为模型数组
 *
 *  @param array 结果数组
 *
 *  @return 模型数组
 */
+ (NSArray *)firstMeetModelsWithArray:(NSArray *)array
{
    NSMutableArray *firstMeetModelArray = [NSMutableArray array];
    
    for (NSDictionary *dic in array)
    {
        MJFirstMeetModel *firstMeetModel = [MJFirstMeetModel firstMeetModelWithDic:dic];
        [firstMeetModelArray addObject:firstMeetModel];
    }
    return firstMeetModelArray;
}

@end
