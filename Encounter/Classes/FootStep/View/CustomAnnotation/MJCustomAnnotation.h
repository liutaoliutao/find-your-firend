//
//  MJCustomAnnotation.h
//  Encounter
//
//  Created by mac on 15/5/31.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface MJCustomAnnotation : NSObject<BMKAnnotation>


///该点的坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/** 图标 */
@property (nonatomic,copy) NSString *icon;

/// 要显示的标题
@property (copy) NSString *title;
/// 要显示的副标题
@property (copy) NSString *subtitle;
/** 头像url */
@property (nonatomic,copy) NSString *headImgUrlStr;
/** 时间 */
@property (nonatomic,copy) NSString *timeStr;

///**
// *获取annotation标题
// *@return 返回annotation的标题信息
// */
//- (NSString *)title;
//
///**
// *获取annotation副标题
// *@return 返回annotation的副标题信息
// */
//- (NSString *)subtitle;



@end
