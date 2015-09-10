//
//  LSBMapLocation.m
//  HaoShiHuo
//
//  Created by apple on 14-9-1.
//  Copyright (c) 2014年 paris. All rights reserved.
//

#import "ReverseGeocodeHelper.h"
#import "MJConst.h"
@implementation ReverseGeocodeHelper
static ReverseGeocodeHelper *location;
+ (ReverseGeocodeHelper *)shareInstancetype
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[ReverseGeocodeHelper alloc]init];
    });
    return location;
}

- (void)beginReverseGeocodeWith:(CLLocationCoordinate2D)coordinate success:(ReverseGeoCodeSuccess)block{
    reverseCallback=block;
    geocodesearch = [[BMKGeoCodeSearch alloc]init];
    geocodesearch.delegate=self;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        MJLog(@"反geo检索发送成功");
    }
    else
    {
        geocodesearch.delegate=nil;
        geocodesearch=nil;
        reverseCallback=nil;
        MJLog(@"反geo检索发送失败");
    }
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
	if (error == 0) {
        if(reverseCallback){
            reverseCallback(result);
        }
	}
    geocodesearch.delegate=nil;
    geocodesearch=nil;
    reverseCallback=nil;
}
+ (CLLocationCoordinate2D )convertBaiduToGoogle:(CLLocationCoordinate2D)originalCoordinate{
    NSDictionary *tempXY=BMKConvertBaiduCoorFrom(originalCoordinate, BMK_COORDTYPE_COMMON);
    CLLocationCoordinate2D tempCoordinate=BMKCoorDictionaryDecode(tempXY);
    double latitude=2*originalCoordinate.latitude-tempCoordinate.latitude;
    double longitude=2*originalCoordinate.longitude-tempCoordinate.longitude;
    return CLLocationCoordinate2DMake(latitude, longitude);
    //最开始的转换方法，误差稍大
//    double x_pi =  M_PI * 3000.0 / 180.0;
//    double x=originalCoordinate.longitude-0.0065;
//    double y=originalCoordinate.latitude-0.006;
//    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
//    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
//    return CLLocationCoordinate2DMake(z * sin(theta), z * cos(theta));
}
@end
