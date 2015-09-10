//
//  MJHotspotCellModel.m
//  Encounter
//
//  Created by 李明军 on 12/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJHotspotCellModel.h"
#import "MJConst.h"

@implementation MJHotspotCellModel


/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 模型
 */
+ (instancetype)hotspotCellModelWithDic:(NSDictionary *)dic
{
    MJHotspotCellModel *hotspotCellModel = [[MJHotspotCellModel alloc] init];
    [hotspotCellModel setValuesForKeysWithDictionary:dic];
    return hotspotCellModel;
}

/**
 *  数组转模型数组
 *
 *  @param array 数组
 *
 *  @return 模型数组
 */
+ (NSArray *)hotspotCellModelsWithArray:(NSArray *)array
{
    if (array.count == 0) return nil;
    NSMutableArray *hotspotCellModelsArray = [NSMutableArray array];
    for (NSDictionary *dic in array)
    {
        MJHotspotCellModel *hotspotCellModel = [MJHotspotCellModel hotspotCellModelWithDic:dic];
        if (hotspotCellModel.IntType == 1)
        {
            [hotspotCellModel setTextFrame];
        }
        else
        {
            [hotspotCellModel setPhotoFrame];
        }
        
        [hotspotCellModelsArray addObject:hotspotCellModel];
    }
    return hotspotCellModelsArray;
}

/**
 *  设置frame
 */
- (void)setTextFrame
{
    CGFloat headImgWidth = 50;
    CGFloat margin = 10;
    CGFloat timeLWidth = 20;
    
    self.textTimeFrame = CGRectMake(margin, margin, systemSize.width - margin * 2, timeLWidth);
    
    CGFloat contentLX = headImgWidth + margin * 2;
    CGFloat contextLY = timeLWidth + margin * 2;
    CGFloat contentLW = systemSize.width - contentLX - margin;
    
    CGSize size = [self.Content boundingRectWithSize:CGSizeMake(contentLW, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                             context:nil].size;
    self.textContentFrame = CGRectMake(contentLX, contextLY, contentLW, size.height);
    
    CGFloat height = margin * 3 + timeLWidth + size.height;
    
    if (height < (headImgWidth + margin * 2))
    {
        self.textCellHeight = headImgWidth + margin * 2;
    }
    else
    {
        self.textCellHeight = height;
    }
    
    CGFloat headImgX = margin;
    CGFloat headImgY = (self.textCellHeight - headImgWidth) * 0.5;
    
    self.textheadImgFrame = CGRectMake(headImgX, headImgY, headImgWidth, headImgWidth);
}

/**
 *  设置照片frame
 */
- (void)setPhotoFrame
{
    CGFloat headImgWidth = 50;
    CGFloat margin = 10;
    CGFloat timeLWidth = 20;
    
    self.photoTimeFrame = CGRectMake(margin, margin, systemSize.width - margin * 2, timeLWidth);
    
    
    CGFloat discX = headImgWidth + headImgWidth + margin * 3 ;
    CGFloat discW = systemSize.width - discX - margin;
    
    CGSize size = [self.Content boundingRectWithSize:CGSizeMake(discW, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                             context:nil].size;
    if (size.height <= 50)
    {
        self.photoCellHeight    = headImgWidth + timeLWidth + margin * 3;
    }
    else
    {
        self.photoCellHeight    = size.height + timeLWidth + margin * 3;
    }
    
    CGFloat photoX              = headImgWidth + margin * 2;
    CGFloat photoY              = (self.photoCellHeight - headImgWidth) * 0.5;
//    CGFloat photoW = self.photoCellHeight - margin * 2;
    self.photoImgFrame          = CGRectMake(photoX, photoY, headImgWidth, headImgWidth);

    
    CGFloat discY               = (self.photoCellHeight - margin* 3 - timeLWidth - size.height) * 0.5 + margin * 2 + timeLWidth;
    self.photoDiscFrame         = CGRectMake(discX, discY, discW, size.height);

    CGFloat hedImgY             = (self.photoCellHeight - headImgWidth) * 0.5;
    self.photoHeadImgFrame      = CGRectMake(margin, hedImgY, headImgWidth, headImgWidth);
    
}



@end
