//
//  MJPhotoDetailUserCellModel.m
//  Encounter
//
//  Created by 李明军 on 28/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#define margin          15
#define headImgWidth    50
#define labelHeight     21


#import "MJPhotoDetailUserCellModel.h"
#import "NSString+MJExtension.h"



@implementation MJPhotoDetailUserCellModel


/**
 *  setter方法设置frame
 *
 *  @param commnentStr 评论str
 */
- (void)setContent:(NSString *)Content
{
    _Content = Content;
    //  1.0 昵称
    CGFloat nameW           = ([UIScreen mainScreen].bounds.size.width - margin * 3) * 0.5;
    CGFloat nameX           = headImgWidth + margin * 2;
    self.nameFrame          = CGRectMake(nameX, margin, nameW, labelHeight);
    
    //  2.0 时间
    self.timeFrame          = CGRectMake([UIScreen mainScreen].bounds.size.width - margin - nameW, margin, nameW, labelHeight);
    
    //  3.0 评论
    CGSize  commentSize     = [NSString caculateStringSize:_Content];
    self.commentFrame       = CGRectMake(nameX, labelHeight + margin * 2, commentSize.width, commentSize.height);
    
    //  4.0 头像和cell
    if ((headImgWidth + margin * 2) >= (commentSize.height + labelHeight + margin * 3))
    {
        self.headImgFrame   = CGRectMake(margin, margin, headImgWidth, headImgWidth);
        self.cellHeight     = headImgWidth + margin * 2;
    }
    else
    {
        CGFloat headImgY    = (commentSize.height + labelHeight + margin * 3 - headImgWidth) * 0.5;
        self.headImgFrame   = CGRectMake(margin, headImgY, headImgWidth, headImgWidth);
        self.cellHeight     = commentSize.height + labelHeight + margin * 3;
    }

    
}


- (void)setDescribe:(NSString *)Describe
{
    _Describe = Describe;
    CGSize discSize         = [NSString caculateStringNoHeadSize:_Describe];
    self.detailCellHeight   = 470 - 20 + discSize.height;
}





/**
 *  转换模型数据
 *
 *  @param dic 字典
 *
 *  @return 返回模型
 */
+ (instancetype)photoDetailUserCellModelWithDic:(NSDictionary *)dic
{
    MJPhotoDetailUserCellModel *phtoDetailUserCellModel = [[MJPhotoDetailUserCellModel alloc]init];
    [phtoDetailUserCellModel setValuesForKeysWithDictionary:dic];
    return phtoDetailUserCellModel;
}

/**
 *  模型数组类方法
 *
 *  @return 返回模型数组
 */
+ (NSArray *)photoDetailUserCellModelsWithArray:(NSArray *)array
{
//    NSString *path                                      = [[NSBundle mainBundle]pathForResource:@"photDetailTest" ofType:@"plist"];
//    NSArray *dicArray                                   = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *photoCellModelArray                 = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        MJPhotoDetailUserCellModel *photoDetailModel    = [MJPhotoDetailUserCellModel photoDetailUserCellModelWithDic:dic];
        [photoCellModelArray addObject:photoDetailModel];
    }
    return photoCellModelArray;
}




@end
