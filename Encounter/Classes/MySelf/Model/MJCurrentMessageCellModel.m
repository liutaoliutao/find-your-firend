//
//  MJCurrentMessageCellModel.m
//  Encounter
//
//  Created by 李明军 on 27/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#define headImgWidth            50
#define hotImgWidth             50
#define titleLabelWidth         160
#define labelHeight             21
#define timeLabelWidth          80
#define commentLabelHeight      40
#define margin                  15
#define screenWidth [UIScreen mainScreen].bounds.size.width

#import "MJCurrentMessageCellModel.h"

@implementation MJCurrentMessageCellModel

- (instancetype)init
{
    if (self = [super init]) {
        [self setCotrolFrame];
    }
    return self;
}

/**
 *  设置控件frame
 */
- (void)setCotrolFrame
{
    CGFloat commentViewHeight       =  labelHeight + commentLabelHeight;
    
    
    //  1.0 设置头部title frame
    CGFloat titleLabelX             = headImgWidth + margin * 2;
    self.titleLabelFrame            = CGRectMake(titleLabelX, margin, titleLabelWidth, labelHeight);
    
    //  2.0 设置时间label的frame
    CGFloat timeLabelX              = screenWidth - margin - timeLabelWidth;
    self.timeLabelFrame             = CGRectMake(timeLabelX, margin, timeLabelWidth, labelHeight);
    
    //  3.0 设置评论描述label的frame
    CGFloat commentLabelW           = screenWidth - margin * 3 - headImgWidth;
    CGFloat commentLabelY           = labelHeight + margin;
    self.commentLabelFrame          = CGRectMake(titleLabelX, commentLabelY, commentLabelW, commentLabelHeight);
    
    //  4.0 设置头像frame
    CGFloat headImgY                = (commentViewHeight + margin - headImgWidth) * 0.5;
    self.headImgFrame               = CGRectMake(margin, headImgY, headImgWidth, headImgWidth);
    
    //  5.0 设置相片Frame
    CGFloat hotImgY                 = commentViewHeight + margin;
    self.hotImgFrame                = CGRectMake(margin, hotImgY, hotImgWidth, hotImgWidth);
    
    //  6.0 设置热点描述frame
    CGFloat footDiscW               = screenWidth - margin * 3 - hotImgWidth;
    CGFloat footDiscX               = hotImgWidth + margin * 2;
    CGFloat footDiscY               = (hotImgWidth - labelHeight) * 0.5 + margin + commentViewHeight;
    self.footDiscLabelFrame         = CGRectMake(footDiscX, footDiscY, footDiscW, labelHeight);
    
    self.cellHeight                 = commentViewHeight + margin * 2 + hotImgWidth;
}



/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 返回模型
 */
+ (instancetype)currentMessageModelWithDic:(NSDictionary *)dic
{
    MJCurrentMessageCellModel *currentMessageModel = [[self alloc]init];
    [currentMessageModel setValuesForKeysWithDictionary:dic];
    return currentMessageModel;
}

/**
 *  测试模型数组
 *
 *  @return 返回模型数组
 */
+ (NSArray *)currentMessageCellModelsWithArray:(NSArray *)array
{
//    NSString *path                              = [[NSBundle mainBundle] pathForResource:@"testPlist" ofType:@"plist"];
//    NSArray *dicArray                           = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *modelArray                  = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        MJCurrentMessageCellModel *currentModel = [MJCurrentMessageCellModel currentMessageModelWithDic:dic];
        [modelArray addObject:currentModel];
    }
    return modelArray;
}



@end
