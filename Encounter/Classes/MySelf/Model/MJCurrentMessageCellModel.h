//
//  MJCurrentMessageCellModel.h
//  Encounter
//
//  Created by 李明军 on 27/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MJCurrentMessageCellModel : NSObject

#pragma mark - frame
/** 头部img的frame            */
@property (nonatomic,assign) CGRect headImgFrame;
/** 热点描述frame             */
@property (nonatomic,assign) CGRect hotImgFrame;
/** title的frame             */
@property (nonatomic,assign) CGRect titleLabelFrame;
/** timeLabel的frame         */
@property (nonatomic,assign) CGRect timeLabelFrame;
/** commentLabel的frame      */
@property (nonatomic,assign) CGRect commentLabelFrame;
/** footDiscLabel的Frame     */
@property (nonatomic,assign) CGRect footDiscLabelFrame;
/** cell高度                 */
@property (nonatomic,assign) CGFloat cellHeight;

#pragma mark - 属性

/** 评论字符串                */
@property (nonatomic,copy) NSString *content;
/** 头像图片url字符串          */
@property (nonatomic,copy) NSString *headimg;
/** isreply */
@property (nonatomic,assign) NSInteger isreply;
/** title字符串               */
@property (nonatomic,copy) NSString *nickname;
/** photodescribe */
@property (nonatomic,copy) NSString *photodescribe;
/** photoid */
@property (nonatomic,assign) NSInteger photoid;
/** 热点图片url字符串          */
@property (nonatomic,copy) NSString *photourl;
/** 时间字符串                */
@property (nonatomic,copy) NSString *timer;





/**
 *  字典转模型
 *
 *  @param dic 字典
 *
 *  @return 返回模型
 */
+ (instancetype)currentMessageModelWithDic:(NSDictionary *)dic;

/**
 *  测试模型数组
 *
 *  @return 返回模型数组
 */
+ (NSArray *)currentMessageCellModelsWithArray:(NSArray *)array;


@end
