//
//  LSBMapLocation.h
//  HaoShiHuo
//
//  Created by apple on 14-9-1.
//  Copyright (c) 2014年 paris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
typedef void (^ReverseGeoCodeSuccess)(BMKReverseGeoCodeResult *result);
@interface ReverseGeocodeHelper : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    BMKGeoCodeSearch *geocodesearch;
    ReverseGeoCodeSuccess reverseCallback;
}
+ (ReverseGeocodeHelper *)shareInstancetype;
- (void)beginReverseGeocodeWith:(CLLocationCoordinate2D)coordinate success:(ReverseGeoCodeSuccess)block;
+ (CLLocationCoordinate2D )convertBaiduToGoogle:(CLLocationCoordinate2D)originalCoordinate;
@end
