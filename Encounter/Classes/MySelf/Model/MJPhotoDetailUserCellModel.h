//
//  MJPhotoDetailUserCellModel.h
//  Encounter
//
//  Created by 李明军 on 28/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MJPhotoDetailUserCellModel : NSObject

/** 头像url */
@property (nonatomic,copy) NSString *HeadImg;
/** 名称字符串 */
@property (nonatomic,copy) NSString *NickName;
/** 事件字符串 */
@property (nonatomic,copy) NSString *Timer;


/** 评论数字字符串 */
@property (nonatomic,assign) NSInteger CommentCount;
/** 时间 */
@property (nonatomic,copy) NSString *Create_Time;
/** 描述字符串 */
@property (nonatomic,copy) NSString *Describe;
/** IsPraise */
@property (nonatomic,assign) NSInteger IsPraise;
/** PhotoId */
@property (nonatomic,assign) NSInteger PhotoId;
/** 图片url */
@property (nonatomic,copy) NSString *PhotoImg;
/** 热点字符串 */
@property (nonatomic,copy) NSString *Place;
/** SupportCount */
@property (nonatomic,assign) NSInteger SupportCount;

/** 时间 */
@property (nonatomic,copy) NSString *CreateTime;
/** AuditState */
@property (nonatomic,assign) NSInteger AuditState;
/** Batch */
@property (nonatomic,copy) NSString *Batch;
/** CommentId */
@property (nonatomic,assign) NSInteger CommentId;
/** Content */
@property (nonatomic,copy) NSString *Content;
/** IntType */
@property (nonatomic,assign) NSInteger IntType;
/** InterCode */
@property (nonatomic,assign) NSInteger InterCode;
/** IsRead */
@property (nonatomic,assign) NSInteger IsRead;
/** ParentId */
@property (nonatomic,assign) NSInteger ParentId;
/** ParentNickName */
@property (nonatomic,copy) NSString *ParentNickName;
/** ToUserId */
@property (nonatomic,assign) NSInteger ToUserId;
/** UserId */
@property (nonatomic,assign) NSInteger UserId;

///** 点赞数量自出串 */
//@property (nonatomic,copy) NSString *goodNumStr;
//
//
//
///** 评论信息 */
//@property (nonatomic,copy) NSString *commnentStr;

#pragma mark - frame属性

/** 头像frame */
@property (nonatomic,assign) CGRect headImgFrame;
/** 昵称frame */
@property (nonatomic,assign) CGRect nameFrame;
/** 时间frame */
@property (nonatomic,assign) CGRect timeFrame;
/** 评论frame */
@property (nonatomic,assign) CGRect commentFrame;
/** cell高度 */
@property (nonatomic,assign) CGFloat cellHeight;

/** 图片详情cell高度 */
@property (nonatomic,assign) CGFloat detailCellHeight;

#pragma mark - 数据模型类方法

/**
 *  转换模型数据
 *
 *  @param dic 字典
 *
 *  @return 返回模型
 */
+ (instancetype)photoDetailUserCellModelWithDic:(NSDictionary *)dic;

/**
 *  模型数组类方法
 *
 *  @return 返回模型数组
 */
+ (NSArray *)photoDetailUserCellModelsWithArray:(NSArray *)array;

@end
