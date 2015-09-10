//
//  MJCustomAnnotationView.h
//  Encounter
//
//  Created by mac on 15/5/31.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "BMapKit.h"

@interface MJCustomAnnotationView : BMKAnnotationView

/**
 *  自定义大头针view类方法
 *
 *  @param mapView 百度地图
 *
 *  @return 返回self
 */
+ (instancetype)customAnnotationViewWithMapView:(BMKMapView *)mapView annotation:(id <BMKAnnotation>)annotation;


@end
