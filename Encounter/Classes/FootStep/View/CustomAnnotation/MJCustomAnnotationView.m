//
//  MJCustomAnnotationView.m
//  Encounter
//
//  Created by mac on 15/5/31.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJCustomAnnotationView.h"
#import "MJCustomAnnotation.h"
#import "MJCustomPaopaoView.h"

@interface MJCustomAnnotationView()

/** view */
@property (nonatomic,strong) MJCustomPaopaoView *paopa;

@end

@implementation MJCustomAnnotationView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    BOOL sel = !selected;
    [super setSelected:selected animated:animated];
}

- (void)setAnnotation:(MJCustomAnnotation *)annotation
{
    

    [super setAnnotation:annotation];
    self.image                  = [UIImage imageNamed:annotation.icon];
    self.paopa.title            = annotation.title;
    self.paopa.subtitle         = annotation.subtitle;
    self.paopa.headImgUrlStr    = annotation.headImgUrlStr;
    //    self.paopa.timeStr          = annotation.timeStr;

}


/**
 *  自定义大头针view类方法
 *
 *  @param mapView 百度地图
 *
 *  @return 返回self
 */
+ (instancetype)customAnnotationViewWithMapView:(BMKMapView *)mapView annotation:(id <BMKAnnotation>)annotation
{
    static NSString *annotationID = @"annotationssID";
    MJCustomAnnotationView *customView = (MJCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationID];
    if (!customView) {
        customView = [[MJCustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationID];
        
//        customView.draggable = YES;
        MJCustomPaopaoView *cust = [[MJCustomPaopaoView alloc]init];
        cust.bounds = CGRectMake(0, 0, 200, 56);
        customView.calloutOffset = CGPointMake(0, 0);
        BMKActionPaopaoView *paopao = [[BMKActionPaopaoView alloc] initWithCustomView:cust];
        customView.paopaoView = nil;
        [customView setPaopaoView:paopao];
        customView.paopa = cust;
        customView.canShowCallout = YES;
    }
    
    return customView;
}

@end
