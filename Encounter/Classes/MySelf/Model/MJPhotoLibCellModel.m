//
//  MJPhotoLibCellModel.m
//  Encounter
//
//  Created by mac on 15/5/31.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJPhotoLibCellModel.h"
#import "MJConst.h"

@implementation MJPhotoLibCellModel


/**
 *  数据模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)photoLibCellModelWithDic:(NSDictionary *)dic
{
    MJPhotoLibCellModel *photoLibCellModel = [[MJPhotoLibCellModel alloc]init];
    [photoLibCellModel setValuesForKeysWithDictionary:dic];
    return photoLibCellModel;
}

/**
 *  模型数组
 *
 *  @return 数组
 */
+ (NSArray *)photoLibCellModelsWithArray:(NSArray *)array  withPageNum:(NSInteger)pageNum withPreArray:(NSArray *)preArray
{
//    //  1.0 字典转模型
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"photoLibTest" ofType:@"plist"];
//    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *photoCellModelsArray = [NSMutableArray array];
//
    if (pageNum == 1)
    {
        for (NSDictionary *dic in array) {
            MJPhotoLibCellModel *photoLicCellModel = [MJPhotoLibCellModel photoLibCellModelWithDic:dic];
            [photoCellModelsArray addObject:photoLicCellModel];
        }
    }
    else
    {
    
        for (MJPhotoLibCellModel *model in preArray[0])
        {
            [photoCellModelsArray addObject:model];
        }
        for (MJPhotoLibCellModel *model in preArray[1])
        {
            [photoCellModelsArray addObject:model];
        }
        
        for (NSDictionary *dic in array) {
            MJPhotoLibCellModel *photoLicCellModel = [MJPhotoLibCellModel photoLibCellModelWithDic:dic];
            [photoCellModelsArray addObject:photoLicCellModel];
        }
    }
    
    
    
//    NSString *userId = [MJUserDefault objectForKey:userDefaultUserId];
//    NSArray *photoCellModelsArray = [self requestPhotoLibWithUserId:userId];
    
    //  2.0 将模型数组分为左右两个模型数组
    NSMutableArray *leftModelArray              = [NSMutableArray array];
    NSMutableArray *rightModelArray             = [NSMutableArray array];
    for (NSInteger i = 0; i < photoCellModelsArray.count; i++) {
        MJPhotoLibCellModel *model = photoCellModelsArray[i];
        if (i % 2 == 0)
        {
            MJPhotoLibCellModel *leftModel      = [[MJPhotoLibCellModel alloc]init];
            leftModel.leftTimeStr               = model.FormatTime;
            leftModel.leftImgUrlStr             = model.Contents;
            leftModel.leftDiscStr               = model.Describe;
            leftModel.leftHotStr                = model.PlaceName;
            leftModel.leftId                    = model.Recordid;
            [leftModelArray addObject:leftModel];
        }
        else
        {
            MJPhotoLibCellModel *rightModel     = [[MJPhotoLibCellModel alloc]init];
            rightModel.rightTimeStr             = model.FormatTime;
            rightModel.rightImgUrlStr           = model.Contents;
            rightModel.rightDiscStr             = model.Describe;
            rightModel.rightHotStr              = model.PlaceName;
            rightModel.rightId                  = model.Recordid;
            [rightModelArray addObject:rightModel];
        }
    }
    
    NSMutableArray *finalArray = [NSMutableArray array];
    [finalArray addObject:leftModelArray];
    [finalArray addObject:rightModelArray];
    
    
    return finalArray;
}



@end
