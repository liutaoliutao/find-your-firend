//
//  MJFootStepViewController.m
//  Encounter
//
//  Created by 李明军 on 25/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//


#define requestM @"GetHotspot"



#import "MJFootStepViewController.h"
#import "MJConst.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"
#import "AppDelegate.h"
#import "MJCustomAnnotationView.h"
#import "MJCustomAnnotation.h"
#import "ReverseGeocodeHelper.h"
#import "MJRequestSpotModel.h"
#import "MJLuckListTableViewController.h"
#import "MJHistoryTableViewController.h"
#import "MJCustomPaopaoView.h"
#import "MJHotSpotViewController.h"
#import "TableFirstMeetListViewController.h"
#import "Reachability.h"//  检测网络状态，在asi三方中

@interface MJFootStepViewController ()<CLLocationManagerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKOfflineMapDelegate>
/** 自动定位开关 */
@property (weak, nonatomic) IBOutlet UISwitch   *autoLocationSwitch;
/** 热点信息label */
@property (weak, nonatomic) IBOutlet UILabel    *hotMessageLabel;
/** 热点地图 */
@property (weak, nonatomic) IBOutlet UIView     *mapKitView;
/** 最近热点label */
@property (weak, nonatomic) IBOutlet UILabel    *recentLabel;
/** 最近热点背景view */
@property (weak, nonatomic) IBOutlet UIView     *recentHotBgView;


/** 百度地图 */
@property (nonatomic,strong) BMKMapView         *mapView;
/** 离线地图 */
@property (nonatomic,strong) BMKOfflineMap      *offlineMap;
/** 记录定位次数 */
@property (nonatomic,assign) NSInteger          i;
/** 存放热点模型数组 */
@property (nonatomic,strong) NSMutableArray     *spotArray;
/** 存放图片 */
@property (nonatomic,strong) NSMutableArray     *iconArray;
/** 请求页数 */
@property (nonatomic,assign) NSInteger          indexNum;
/** 当前位置 */
@property (nonatomic,copy)   NSString           *currentPlaceStr;
/** 当前热点字典  */
@property (nonatomic,strong) NSDictionary       *hotDic;
/** 坐标 */
@property (nonatomic,assign) CLLocationCoordinate2D recognizerCoordinate;
/** 结果大头针数组 */
@property (nonatomic,strong) NSArray            *annotationArray;
/** 数组 */
@property (nonatomic,strong) NSMutableArray     *distanceArray;
/** 请求最近的十个热点 */
@property (nonatomic,strong) AFHTTPRequestOperationManager *requestCurrentHotManager;
/** 限制刷新太快 */
@property (nonatomic,assign) NSInteger refreshTimeNum;


@end

@implementation MJFootStepViewController


#pragma mark - 懒加载

- (NSMutableArray *)distanceArray
{
    if (!_distanceArray) {
        _distanceArray = [NSMutableArray array];
    }
    return _distanceArray;
}

/**
 *  1.0 图片数组
 */
- (NSMutableArray *)iconArray
{
    if (!_iconArray)
    {
        _iconArray = [NSMutableArray array];
    }
    return _iconArray;
}

/**
 *  2.0 热点数组
 */
- (NSMutableArray *)spotArray
{
    if (!_spotArray) {
        _spotArray = [NSMutableArray array];
    }
    return _spotArray;
}

/**
 *  3.0 百度地图
 */
- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]init];
    }
    return _mapView;
}

/**
 *  4.0 百度离线地图
 */
- (BMKOfflineMap *)offlineMap
{
    if (!_offlineMap) {
        _offlineMap = [[BMKOfflineMap alloc] init];
    }
    return _offlineMap;
}



#pragma mark - view加载事件

/**
 *  1.0 view已经加载
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshTimeNum = 1;
    //  加载百度离线地图
    [self loadOfflineBaiduMap];
    
    //  设置
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"bottom_zj_s"]];
    self.recentHotBgView.backgroundColor = systemColor;

    //  配置百度地图
    [self setBaiduMap];
   
    //  初始化定位次数
    self.i = 0;
    
  
    
    [MJNotifCenter addObserver:self
                      selector:@selector(locationNotificationCenter:)
                          name:notificationLocationName
                        object:nil];
}


/**
 *  view将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    self.indexNum = 0;
    
    //  清空图片数组
    [self.iconArray removeAllObjects];
    
    //  设置导航
    [self.navigationItem setTitle:@"我的足迹"];
    [self.tabBarController.tabBar setHidden:NO];
    //  百度地图
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.offlineMap.delegate = self;
    CLLocationCoordinate2D coor                    = CLLocationCoordinate2DMake(29.549170, 106.537770);
    self.mapView.region = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.1, 0.1));
    //  请求当前热点
    [self requestCurrentSpot];
 
}

/**
 *  view已经出现
 */
- (void)viewDidAppear:(BOOL)animated
{
    //  在百度地图加载大头针
    
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appD.baiduLocationService startUserLocationService];
    //    [self loadAnnotation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadAnnotation];
    });

    //  根据用户偏好设置，设置开关状态
        [self setSwitchIsOn];
    
}

/**
 *  view将要消失
 */
- (void)viewWillDisappear:(BOOL)animated
{
    //  清空地图
    [self cleanMap];
    [[self.requestCurrentHotManager operationQueue] cancelAllOperations];
    //  百度地图清除
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.offlineMap.delegate = nil; // 不用时，置nil
    [self.navigationItem setTitle:@"返回"];
}

#pragma mark - view加载时调用函数

#pragma mark 1. 根据用户偏好设置，设置自动定位开关是否打开
/**
 *  根据用户偏好设置，设置自动定位开关是否打开
 */
- (void)setSwitchIsOn
{
    if ([MJUserDefault objectForKey:userDefaultIsOnLocation])
    {
        //  获取代理
        AppDelegate *appD =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        BOOL locationIsOn = [[MJUserDefault objectForKey:userDefaultIsOnLocation] boolValue];
        if (!locationIsOn)
        {
            
            [appD startLocationTrack];
        }
        else
        {
            [appD stopLocationTrack];
        }
        //  在百度地图加载大头针
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self loadAnnotation];
            [self.autoLocationSwitch setOn:locationIsOn animated:NO];
//        });
        
    }
   
//        [self loadAnnotation];
 
}

#pragma mark 2. 加载百度离线地图
/**
 *  加载百度离线地图
 */
- (void)loadOfflineBaiduMap
{
    //  1.1.0 检查手机是否有百度离线地图包
    [self.offlineMap scan:YES];
    //  1.1.1 取出可加载离线地图的id和名称
    NSArray *arr                = [self.offlineMap getOfflineCityList];
    
    for (BMKOLSearchRecord *serr in arr)
    {
        MJLog(@"%d:%@",serr.cityID,serr.cityName);
    }
    
    //  1.1.2 检测网络状态，若为WiFi加载离线地图
    Reachability *checkNetWork  = [Reachability reachabilityWithHostName:@"m.yibaiwu.com"];
    NetworkStatus netStauts     = [checkNetWork currentReachabilityStatus];
    if (netStauts == kReachableViaWiFi)
    {
        MJLog(@"wifi");
        //  下载离线地图 1：全国 132: 重庆
        [self.offlineMap start:1];
    }
    else
    {
        MJLog(@"非wifi");
    }
}

#pragma mark 3. 配置百度地图
/**
 *  配置百度地图
 */
- (void)setBaiduMap
{
    CGRect mapViewFrame             = CGRectMake(0,
                                                 0,
                                                 systemSize.width,
                                                 self.view.bounds.size.height - self.mapView.frame.origin.x - 200);
    MJLog(@"%f",mapViewFrame.size.height);
    [self.mapView setFrame:mapViewFrame];
    
    //  设置定位模式
    self.mapView.userTrackingMode   = BMKUserTrackingModeNone;
    self.mapView.rotateEnabled      = NO;
    self.mapView.overlookEnabled    = NO;
    self.mapView.zoomEnabledWithTap = NO;
//    self.mapView.maxZoomLevel       = 15;
//    self.mapView.minZoomLevel       = 10;
    
    [self.mapKitView addSubview:self.mapView];
}


#pragma mark 4. 获取当前热点

/**
 *  4.1 获取当前热点
 */
- (void)requestCurrentSpot
{
    //  从缓存中取出定位状态
    NSString *str = [NSString stringWithFormat:@"%@",[MJUserDefault objectForKey:isOpenLocation]];
    if ([str isEqualToString:@"0"])
    {
        [self setRecentLabelText];
    }
    else
    {
        AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appD requestCurrentHotWithBlock:^{
            [self setRecentLabelText];
        }];
    }
}

/**
 *  4.2 设置当前热点
 */
- (void)setRecentLabelText
{
    NSDictionary *spotDic       = [MJUserDefault objectForKey:userDefaultCurrentSpot];
    self.hotDic = spotDic;
    NSString *str               = [spotDic objectForKey:userDefaultCurrentSpotPlaceNameStr];
    NSString *discStr           = [NSString stringWithFormat:@"当前初遇热点：%@",str];
    self.recentLabel.text       = discStr;
    NSString *placeStr          = [MJUserDefault objectForKey:userDefaultCurrentLocationStr];
    if (placeStr) {
        self.hotMessageLabel.text    = placeStr;
    }
    
}

#pragma mark - 定位通知方法

/**
 *  定位通知方法
 *
 *  @param lotification 通知
 */
- (void)locationNotificationCenter:(NSNotification *) lotification
{
    //  清除地图所有大头针
    [self cleanMap];
    
//    //  取出通知信息中得坐标信息
//    NSDictionary *userDic           = lotification.userInfo;
//    CLLocationDegrees lat           = [[userDic objectForKey:notificationUserInfoKeyLat] doubleValue];
//    CLLocationDegrees lon           = [[userDic objectForKey:notificationUserInfoKeyLon] doubleValue];
//    CLLocationDistance dis          = [[userDic objectForKey:notificationUserInfoKeyDis] doubleValue];
//    NSString *str                   = [userDic objectForKey:@"notificationUserInfoKeyPlaceStr"];
//    self.hotMessageLabel.text       = str;
//    CLLocationCoordinate2D locationCordinate = CLLocationCoordinate2DMake(lat, lon);
//    
//    //  请求当前坐标最近的十个热点
//    [self requestCurrenstSpotWithLocationCordinate:locationCordinate];
//   
//    //  根据距离设置标题
//    NSString *title;
//    if (dis > 300)
//    {
//        title = @"求初遇";
//    }
//    else
//    {
//        title = [NSString stringWithFormat:@"我再%@求初遇",self.currentPlaceStr];
//    }
//    
//    //  设置中心坐标
//    self.mapView.centerCoordinate   = locationCordinate;
//    self.mapView.region             = BMKCoordinateRegionMake(locationCordinate, BMKCoordinateSpanMake(0.1, 0.1));
//
//    //  设置大头针
//    [self settingAnnotationWithCoordinate:locationCordinate icon:[NSString stringWithFormat:@"2"] title:title subtitle:@""];
    
    [self loadAnnotation];
    
    self.i++;
}


#pragma mark - 加载大头针

/**
 *  向地图加载大头针
 */
- (void)loadAnnotation
{
    CLLocationCoordinate2D coor;
    //  清空地图
    [self cleanMap];
//    [[self.requestCurrentHotManager operationQueue] cancelAllOperations];
    //  如果缓存中有定位：注：定位成功才有值
    if ([MJUserDefault objectForKey:userDefaultCurrentLocationLat])
    {
        //  从缓存中取出定位反地理编码
        self.currentPlaceStr    = [MJUserDefault objectForKey:userDefaultCurrentLocationStr];
        //  从缓存取出定位坐标
        CLLocationDegrees lat       = [[MJUserDefault objectForKey:userDefaultCurrentLocationLat]
                                       doubleValue];
        CLLocationDegrees lon       = [[MJUserDefault objectForKey:userDefaultCurrentLocationLon]
                                       doubleValue];
        
        CLLocationDegrees latCurrentPage       = [[MJUserDefault objectForKey:@"annotationViewForBubbleLat"]
                                       doubleValue];
        CLLocationDegrees lonCurrentPage       = [[MJUserDefault objectForKey:@"annotationViewForBubbleLon"]
                                       doubleValue];
        //  根据定位时计算的移动距离
//        double distanc              = [[MJUserDefault objectForKey:@"userGoDistance"]
//                                       doubleValue];
        coor                        = CLLocationCoordinate2DMake(lat, lon);
        
        //  加载当前位置大头针
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate       = coor;
        
        if (latCurrentPage)
        {
            BMKMapPoint prePoint                        = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latCurrentPage, lonCurrentPage));
            BMKMapPoint currentPoint                    = BMKMapPointForCoordinate(coor);
            CLLocationDistance distance                 = BMKMetersBetweenMapPoints(currentPoint,prePoint);
            if (distance < 300)
            {
                annotation.title        = [NSString stringWithFormat:@"我在%@求初遇",self.currentPlaceStr];
            }
            else
            {
                annotation.title        = @"求初遇";
            }
        }
        else
        {
            annotation.title        = @"求初遇";
        }
        
        
        
        MJLog(@"%@",self.currentPlaceStr);
        if (self.currentPlaceStr && (![self.currentPlaceStr isEqualToString:@""]))
        {
            self.hotMessageLabel.text = self.currentPlaceStr;
            //  缓存大头针图片，2：标识我的位置
            [self saveIconWithTypeStr:2];
            [_mapView addAnnotation:annotation];
        }
        else
        {
            self.hotMessageLabel.text = @"正在解析地址，请重新刷新";
        }
        
    }
    else
    {
        self.hotMessageLabel.text = @"无法获取当前位置";
        NSArray *footArray          = [MJUserDefault objectForKey:userDefaultLatestFootPrint];
        MJLog(@"footArray%lu",(unsigned long)footArray.count);
        coor                    = CLLocationCoordinate2DMake(29.549170, 106.537770);
//        if (footArray.count > 0)
//        {
//            NSDictionary *dic       = [footArray lastObject];
//            CLLocationDegrees lat   = [[dic objectForKey:userDefaultLatestFootPrintDicLat]
//                                       doubleValue];
//            CLLocationDegrees lon   = [[dic objectForKey:userDefaultLatestFootPrintDicLon]
//                                       doubleValue];
//            coor                    = CLLocationCoordinate2DMake(lat, lon);
////            self.currentPlaceStr    = [dic objectForKey:userDefaultLatestFootPrintDicAddress];
//        }
//        else
//        {
//            
////            self.currentPlaceStr    = @"重庆市区";
//        }
    }
    
    
    //  请求当前位置附近最多十个热点
    [self requestCurrenstSpotWithLocationCordinate:coor];
    
    //  设置地图中心位置
    [self.mapView setCenterCoordinate:coor animated:YES];
    //  设置地图显示区域范围
    
    self.mapView.region = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.1, 0.1));
    
    
}


#pragma mark - 根据定位，请求当前最近的十个热点

/**
 *  根据当前位置，请求最近的十个热点
 *
 *  @param cordinate
 */
- (void)requestCurrenstSpotWithLocationCordinate:(CLLocationCoordinate2D) cordinate
{
    
    self.requestCurrentHotManager = [AFHTTPRequestOperationManager manager];
    
    //  1. 配置请求字段字符串
    NSString *latStr            = [NSString stringWithFormat:@"%0.6f",cordinate.latitude];
    NSString *lonStr            = [NSString stringWithFormat:@"%0.6f",cordinate.longitude];
    NSString *pageIndexStr      = [NSString stringWithFormat:@"%d",1];
    NSString *pageSizeStr       = [NSString stringWithFormat:@"%d",10];
    NSString *attributeStr      = [NSString stringWithFormat:@"%d",1];
    NSString *signStr           = [NSString stringWithFormat:@"%@%@%@%@%@",latStr,lonStr,pageIndexStr,pageSizeStr,requestSecuKey];
    MJLog(@"signStr%@",signStr);
    MJLog(@"mdt5%@",[signStr md5String]);
    
    //  2. 配置上传数据包
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:requestM              forKey:requestKey];
    [params setObject:latStr                forKey:@"Lat"];
    [params setObject:lonStr                forKey:@"Long"];
    [params setObject:pageIndexStr          forKey:@"PageIndex"];
    [params setObject:pageSizeStr           forKey:@"PageSize"];
    [params setObject:attributeStr          forKey:@"Attribute"];
    [params setObject:[signStr md5String]   forKey:requestKeySign];
    
    //  3. 发送请求
    [self.requestCurrentHotManager POST:[NSString stringWithFormat:@"%@V2/HotspotHandler.ashx?",SERVERADDRESS] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSString *isSucess = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
        NSString *message = [dic objectForKey:@"retMsg"];
   
        MJLog(@"请求最近的热点连接服务器成功dic%@\n isSucess:%@",dic,isSucess);
        if ([isSucess isEqualToString:@"1"])
        {
            MJLog(@"请求最近的热点-请求成功");
            NSArray *resultArray = [dic objectForKey:@"retData"];
            [self requestSucessWithArray:resultArray codinat:cordinate];
        }
        else
        {
            MJLog(@"请求最近的热点-请求失败retMsg%@",message);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[self.requestCurrentHotManager operationQueue] cancelAllOperations];
        MJLog(@"连接服务器失败");
        self.hotMessageLabel.text = @"无法获取当前位置";
        self.recentLabel.text = @"无法获取当前热点";
        [self cleanMap];
    }];
}

/**
 *  将返回热点字典转模型
 *
 *  @param array
 */
- (void)requestSucessWithArray:(NSArray *)array codinat:(CLLocationCoordinate2D) cordinate
{
    if (array.count < 1)return;
    self.annotationArray = array;
    self.recognizerCoordinate = cordinate;
    
    //  开辟子线程计算当前位置距热点距离，且设置热点大头针
    [[[NSThread alloc] initWithTarget:self selector:@selector(caculateAnnotation) object:nil] start];
}

/**
 *  子线程中计算当前位置到热点距离，并加载热点大头针
 */
- (void)caculateAnnotation
{
   
    for (NSDictionary *dic in self.annotationArray)
    {
        
        MJRequestSpotModel *model   = [MJRequestSpotModel requestSpotModel];
        model.CreateTime            = [dic          objectForKey:@"CreateTime"];
        model.DelFlag               = [dic          objectForKey:@"DelFlag"];
        model.HotspotId             = [[dic          objectForKey:@"HotspotId"] integerValue];
        model.HotspotType           = [dic          objectForKey:@"HotspotType"];
        model.ID                    = [dic          objectForKey:@"ID"];
        model.Image                 = [dic          objectForKey:@"Image"];
        model.Lat                   = [[dic         objectForKey:@"Lat"] doubleValue];
        model.Long                  = [[dic         objectForKey:@"Long"] doubleValue];
        model.PlaceName             = [dic          objectForKey:@"PlaceName"];
        model.Remark                = [dic          objectForKey:@"Remark"];
        model.Title                 = [dic          objectForKey:@"Title"];
        model.distance              = [[dic         objectForKey:@"distance"] doubleValue];
        //        [self settingAnnotationWithCoordinate:CLLocationCoordinate2DMake(model.Lat, model.Long) icon:model.HotspotType title:model.PlaceName subtitle:model.Title];
        [self.spotArray addObject:model];
    }
    if (self.spotArray.count > 0) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        [self.distanceArray removeAllObjects];
        
        NSArray *reArr = self.spotArray;
        
        [reArr enumerateObjectsUsingBlock:^(MJRequestSpotModel *requestModel, NSUInteger idx, BOOL *stop)
         {
             
//             *stop = YES;
//             
//             if (*stop == YES) {
             
                 BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc]init];
                 
                 annotation.coordinate           = CLLocationCoordinate2DMake(requestModel.Lat, requestModel.Long);
                 MJLog(@"%ld%ld",(long)requestModel.Lat,(long)requestModel.Long);
                 //        annotation.imageIcon                 = @"zj_point_1";
                 
                 annotation.title                = requestModel.PlaceName;
                 
                 BMKMapPoint prePoint                        = BMKMapPointForCoordinate(self.recognizerCoordinate);
                 BMKMapPoint curentPoint                     = BMKMapPointForCoordinate(annotation.coordinate);
                 CLLocationDistance distance                 = BMKMetersBetweenMapPoints(curentPoint,prePoint);
                 [self.distanceArray addObject:@(distance)];

                 
//             }
//             if (*stop) {
//             
//             
//             }
         }];
        
//        for (MJRequestSpotModel *requestModel in self.spotArray) {
//            BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc]init];
//            
//            annotation.coordinate           = CLLocationCoordinate2DMake(requestModel.Lat, requestModel.Long);
//            MJLog(@"%ld%ld",(long)requestModel.Lat,(long)requestModel.Long);
//            //        annotation.imageIcon                 = @"zj_point_1";
//            
//            annotation.title                = requestModel.PlaceName;
//            
//            BMKMapPoint prePoint                        = BMKMapPointForCoordinate(self.recognizerCoordinate);
//            BMKMapPoint curentPoint                     = BMKMapPointForCoordinate(annotation.coordinate);
//            CLLocationDistance distance                 = BMKMetersBetweenMapPoints(curentPoint,prePoint);
//            [self.distanceArray addObject:@(distance)];
//        }
        
        //  排序
        MJLog(@"%lu",(unsigned long)self.distanceArray.count);
        [self.distanceArray sortUsingComparator:^NSComparisonResult(NSString *part1, NSString *part2) {
            // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
            // 返回NSOrderedSame:两个一样大
            // NSOrderedAscending(升序):part2>part1
            // NSOrderedDescending(降序):part1>part2
            if ([part1 doubleValue] > [part2 doubleValue])
            {
                // part1>part2
                // part1放后面, part2放前面
                return NSOrderedDescending;
            }
            // part1<part2
            // part1放前面, part2放后面
            return NSOrderedAscending;
        }];

        
        NSArray *arr = [NSArray arrayWithArray:self.spotArray];
        [arr enumerateObjectsUsingBlock:^(MJRequestSpotModel *requestModel, NSUInteger idx, BOOL *stop)
         {
             
//             *stop = YES;
//             
//             if (*stop == YES) {
            
                 BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc]init];
                 
                 annotation.coordinate           = CLLocationCoordinate2DMake(requestModel.Lat, requestModel.Long);
                 MJLog(@"%ld%ld",(long)requestModel.Lat,(long)requestModel.Long);
                 //        annotation.imageIcon                 = @"zj_point_1";
                 
                 annotation.title                = requestModel.PlaceName;
                 
                 BMKMapPoint prePoint                        = BMKMapPointForCoordinate(self.recognizerCoordinate);
                 BMKMapPoint curentPoint                     = BMKMapPointForCoordinate(annotation.coordinate);
                 CLLocationDistance distance                 = BMKMetersBetweenMapPoints(curentPoint,prePoint);
                 
                 if ([[self.distanceArray firstObject] doubleValue] == distance)
                 {
                     [self saveIconWithTypeStr:5];
                     if (![requestModel.PlaceName isKindOfClass:[NSNull class]]) {
                         self.recentLabel.text = [NSString stringWithFormat:@"最近初遇热点：%@",requestModel.PlaceName];
                     }
                     
                 }
                 else
                 {
                     [self saveIconWithTypeStr:[requestModel.HotspotType integerValue]];
                 }
                 annotation.subtitle             = [NSString stringWithFormat:@"%0.2fkm",distance / 1000];
                 if (![requestModel.Title isKindOfClass:[NSNull class]]) {
                     annotation.subtitle             = requestModel.Title;
                 }
                 [mutableArray addObject:annotation];
                 
//             }
//             if (*stop) {
//                 
//                 
//             }
         }];
        

        
//        for (MJRequestSpotModel *requestModel in self.spotArray)
//        {
//            BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc]init];
//            
//            annotation.coordinate           = CLLocationCoordinate2DMake(requestModel.Lat, requestModel.Long);
//            MJLog(@"%ld%ld",(long)requestModel.Lat,(long)requestModel.Long);
//            //        annotation.imageIcon                 = @"zj_point_1";
//            
//            annotation.title                = requestModel.PlaceName;
//            
//            BMKMapPoint prePoint                        = BMKMapPointForCoordinate(self.recognizerCoordinate);
//            BMKMapPoint curentPoint                     = BMKMapPointForCoordinate(annotation.coordinate);
//            CLLocationDistance distance                 = BMKMetersBetweenMapPoints(curentPoint,prePoint);
//            
//            if ([[self.distanceArray firstObject] doubleValue] == distance)
//            {
//                [self saveIconWithTypeStr:5];
//            }
//            else
//            {
//                [self saveIconWithTypeStr:[requestModel.HotspotType integerValue]];
//            }
//            annotation.subtitle             = [NSString stringWithFormat:@"%0.2fkm",distance / 1000];
//            if (![requestModel.Title isKindOfClass:[NSNull class]]) {
//                annotation.subtitle             = requestModel.Title;
//            }
//            [mutableArray addObject:annotation];
//            
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotations:mutableArray];
        });
    }
    
    
    
}

#pragma mark - 百度地图代理

/**
 *  根据anntation生成对应的View
 *  @param mapView      地图View
 *  @param annotation   指定的标注
 *  @return             生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 根据anntation生成对应的View
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        //  1. 设置可重用标识
        static NSString *bmkAnnotationVId = @"bmkAnnotationVId";
        
        //  2. 从缓存池中取大头针view
        BMKAnnotationView *customAnnotationV = [mapView dequeueReusableAnnotationViewWithIdentifier:bmkAnnotationVId];
        //  3. 若没有，创建可重用大头针view
        if (!customAnnotationV)
        {
            customAnnotationV = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:bmkAnnotationVId];
            customAnnotationV.calloutOffset = CGPointMake(0, 8);
        }
        
        //  4. 从图片数组中取出图片设置大头针图片
        if (self.iconArray.count > self.indexNum) {
            customAnnotationV.image = [UIImage imageNamed:self.iconArray[self.indexNum]];
        }
        
        
        //  5. 第一个即我的位置大头针选中
        if (self.indexNum == 0) {
            customAnnotationV.selected = YES;
        }
        self.indexNum ++;
        return customAnnotationV;
    }
    return nil;
}

/**
 *  地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *  @param mapview  地图View
 *  @param status   此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status
{
   
}


/**====================================以后版本可能用到======================================*/

//- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//    
//    MJLog(@"%lu",(unsigned long)views.count);
//    for (NSInteger i = 0; i < views.count; i++) {
//        if (i == 0) {
//            BMKAnnotationView *custome = [views firstObject];
//            [custome setSelected:YES animated:YES];
//
//        }
//    }
//    
//    
//}
////
//- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
//{
//    [view.paopaoView setHidden:YES];
////    if ([view isKindOfClass:[MJCustomAnnotationView class]]) {
////        view.selected = !view.selected;
////    }
//    
//}

/**========================================================================================*/

/**
 *  当点击annotation view弹出的泡泡时，调用此接口
 *  @param mapView  地图View
 *  @param view     泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    //  1. 从缓存中取出距离
    //  从缓存取出定位坐标
    [MJUserDefault setObject:[NSString stringWithFormat:@"%0.6f",view.annotation.coordinate.latitude] forKey:@"annotationViewForBubbleLat"];
    [MJUserDefault setObject:[NSString stringWithFormat:@"%0.6f",view.annotation.coordinate.longitude] forKey:@"annotationViewForBubbleLon"];
    [MJUserDefault synchronize];
    if ([view.annotation.title isEqualToString:@"求初遇"])
    {
        [self sendMessageForFirstMeetWithMap:mapView bubble:view];
        [self loadAnnotation];
    }
    
    
}

- (void)sendMessageForFirstMeetWithMap:(BMKMapView *)mapView bubble:(BMKAnnotationView *)view
{
    //  2. 更具大头针图片，确定是否位我
    NSData *imageData = UIImageJPEGRepresentation(view.image, 1);
    NSData *cuImgData = UIImageJPEGRepresentation([UIImage imageNamed:@"zj_point_2"], 1);
    //  3. 若为我，改变标题，发送求初遇信息
    if ([imageData isEqualToData:cuImgData])
    {
        BMKPointAnnotation *an  = (BMKPointAnnotation *)view.annotation;
        an.title                = [NSString stringWithFormat:@"我在%@求初遇",self.currentPlaceStr];
        [mapView setCenterCoordinate:an.coordinate];
        [self sendMessageToHotSpotWithContent:an.title];
    }

}

#pragma mark - 发送求初遇信息

/**
 *  发送求初遇信息到热点
 *
 *  @param contentStr
 */
- (void)sendMessageToHotSpotWithContent:(NSString *)contentStr
{
    if (!self.hotDic)return;
    
    AFHTTPRequestOperationManager *sendTextManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *signStr = [NSString stringWithFormat:@"%ld%@",
                         (long)[[self.hotDic objectForKey:userDefaultCurrentSpotHotspotIdStr] integerValue],
                         requestSecuKey];
    
    MJLog(@"发送文字给服务器:%@\nmd5:%@",signStr,[signStr md5String]);
    
    [params setObject:@"SendText"               forKey:requestKey];
    [params setObject:contentStr                forKey:@"Content"];
    [params setObject:@([[self.hotDic objectForKey:userDefaultCurrentSpotLatStr] integerValue])
               forKey:@"Lat"];
    [params setObject:@([[self.hotDic objectForKey:userDefaultCurrentSpotLonStr] integerValue])
               forKey:@"Long"];
    [params setObject:[self.hotDic objectForKey:userDefaultCurrentSpotPlaceNameStr]
               forKey:@"Place"];
    [params setObject:@([[self.hotDic objectForKey:userDefaultCurrentSpotHotspotIdStr] integerValue])
               forKey:@"HotId"];
    [params setObject:[signStr md5String]       forKey:requestKeySign];
    
    
    [sendTextManager POST:[SERVERADDRESS stringByAppendingString:@"V2/HotspotHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dic = responseObject;
         
         MJLog(@"发送文字给服务器-连接服务器成功%@%@",dic,[dic objectForKey:@"retMsg"]);
     }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         MJLog(@"发送文字给服务器-连接服务器成功%@",error);
     }];

}

#pragma mark - 设置单个大头针
/**
 *  设置大头针
 *
 *  @param cordinate 大头针坐标
 *  @param icon      大头针图标
 *  @param title     大头针标注title
 *  @param subtitle  大头针下标注
 */
- (void)settingAnnotationWithCoordinate:(CLLocationCoordinate2D)cordinate icon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle
{
    BMKPointAnnotation * annotation         = [[BMKPointAnnotation alloc]init];
    annotation.coordinate                   = cordinate;
    [self saveIconWithTypeStr:[icon integerValue]];
    annotation.title                        = title;
    if (![subtitle isKindOfClass:[NSNull class]])
    {
         annotation.subtitle                = subtitle;
    }
   
    [self.mapView addAnnotation:annotation];
}

#pragma mark - 设置组大头针

/**
 *  设置组大头针
 *
 *  @param array     需要设置的大头针数据数组
 *  @param cordinate 当前坐标
 */
- (void)settingAnnotationWithArray:(NSArray *)array codinat:(CLLocationCoordinate2D) cordinate
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (MJRequestSpotModel *requestModel in array)
    {
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc]init];
        
        annotation.coordinate           = CLLocationCoordinate2DMake(requestModel.Lat, requestModel.Long);
        MJLog(@"%ld%ld",(long)requestModel.Lat,(long)requestModel.Long);
        [self saveIconWithTypeStr:[requestModel.HotspotType integerValue]];
        annotation.title                = requestModel.PlaceName;
        
        BMKMapPoint prePoint                        = BMKMapPointForCoordinate(cordinate);
        BMKMapPoint curentPoint                     = BMKMapPointForCoordinate(annotation.coordinate);
        CLLocationDistance distance                 = BMKMetersBetweenMapPoints(curentPoint,prePoint);
        
        annotation.subtitle             = [NSString stringWithFormat:@"%0.2fkm",distance / 1000];
        if (![requestModel.Title isKindOfClass:[NSNull class]]) {
            annotation.subtitle             = requestModel.Title;
        }
        [mutableArray addObject:annotation];
        [self.mapView addAnnotations:mutableArray];
    }
    

}




#pragma mark - 控件事件处理

/**
 *  1.0 自动定位开关值改变
 */
- (IBAction)autoLocationSwitch:(UISwitch *)sender
{
    //  获取代理
    AppDelegate *appD =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    //  设置用户是否打开或者关闭自动定位开关，用于在appdelegate中判断是否打开自动定位
    [MJUserDefault setObject:@(sender.on) forKey:userDefaultIsOnLocation];
    [MJUserDefault synchronize];
//    
//    if ([MJUserDefault objectForKey:userDefaultIsOnLocation])
//    {
//        BOOL locationIsOn = [[MJUserDefault objectForKey:userDefaultIsOnLocation] boolValue];
//        if (locationIsOn)
//        {
//            [self loadAnnotation];
//        }
//        else
//        {
//            [appD startLocationTrack];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self loadAnnotation];
//                            [appD stopLocationTrack];
//            });
//        }
//    }
//    else
//    {
//        [self loadAnnotation];
//    }

    
    
//    BOOL appStartIsOnLocation = [[MJUserDefault objectForKey:userDefaultAppStartIsOnLocation] boolValue];
    if (sender.on)
    {
//        [appD startIsUnknowStark];
        //  开启定位
        [appD startLocationTrack];
//        [self loadAnnotation];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self loadAnnotation];
////            [appD stopLocationTrack];
//        });
    
    }
    else
    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self loadAnnotation];
//            if (appStartIsOnLocation)   [appD stopLocationTrack];
//            //            [appD stopLocationTrack];
//        });
//        [self loadAnnotation];
        [appD stopLocationTrack];
//        //  停止定位
        
        
    }
    
}

/**
 *  2.0 刷新按钮点击事件
 *
 *  @param sender 按钮
 */
- (IBAction)refreshBtn:(UIButton *)sender
{
//    [MJUserDefault removeObjectForKey:userDefaultCurrentLocationLat];
//    [MJUserDefault removeObjectForKey:userDefaultCurrentLocationLon];
    // 2.创建动画
    // 2.1创建组组动画
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.5;

    // 2.3 添加一个 ”旋转的动画“
    CAKeyframeAnimation *rotationAni = [CAKeyframeAnimation animation];
    rotationAni.keyPath = @"transform.rotation";
    rotationAni.values  = @[@0,@(M_PI * 2),@(M_PI * 4),@(M_PI * 6)];
    sender.center = sender.center;
    group.animations = @[rotationAni];
    [sender.layer addAnimation:group forKey:nil];
    if (self.refreshTimeNum == 2)return;
    self.refreshTimeNum = 2;
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appD.baiduLocationService startUserLocationService];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.refreshTimeNum = 1;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadAnnotation];
    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//    });
    
}

/**
 *  3.0 初遇热点按钮点击事件
 *
 *  @param sender 按钮
 */
- (IBAction)firstMeetSpotBtn:(UIButton *)sender
{
    TableFirstMeetListViewController *firstMeetCotrllor = [[TableFirstMeetListViewController alloc] init];
    [self.navigationController pushViewController:firstMeetCotrllor animated:YES];
}

/**
 *  4.0 缘分热点按钮点击事件
 *
 *  @param sender 缘分热点
 */
- (IBAction)yuanfenSpotBtn:(UIButton *)sender
{
    MJLuckListTableViewController *luckListTVC = [[MJLuckListTableViewController alloc]init];
    [self.navigationController pushViewController:luckListTVC animated:YES];
}


/**
 *  5.0 热点点击
 *
 *  @param sender
 */
- (IBAction)hotBtnClick:(UIButton *)sender
{
    MJHotSpotViewController *hotSpotViewC = [[MJHotSpotViewController alloc]init];
    NSDictionary *spotDic       = [MJUserDefault objectForKey:userDefaultCurrentSpot];
    NSString *str           = [spotDic objectForKey:userDefaultCurrentSpotPlaceNameStr];
    
    double  lat             = [[spotDic objectForKey:userDefaultCurrentSpotLatStr] doubleValue];
    double  lon             = [[spotDic objectForKey:userDefaultCurrentSpotLonStr] doubleValue];
    //            NSString *hotid          = [dic objectForKey:userDefaultCurrentSpotHotspotIdStr];
    NSInteger hotid          = [[spotDic objectForKey:userDefaultCurrentSpotHotspotIdStr] integerValue];
    MJLog(@"hotid%d",(int)hotid);
    
    hotSpotViewC.hotId      = hotid;
    hotSpotViewC.lat        = lat;
    hotSpotViewC.lon        = lon;
    hotSpotViewC.navTitle   = str;
    
    [self.navigationController pushViewController:hotSpotViewC animated:YES];
}

#pragma mark - 离线地图代理方法，检测及下载离线地图
/**
 *  返回通知结果
 *  @param type     
                    事件类型： TYPE_OFFLINE_UPDATE,TYPE_OFFLINE_ZIPCNT,TYPE_OFFLINE_UNZIP, TYPE_OFFLINE_ERRZIP, TYPE_VER_UPDATE,     TYPE_OFFLINE_UNZIPFINISH, TYPE_OFFLINE_ADD
 *  @param state 
                    事件状态，
                    当type为TYPE_OFFLINE_UPDATE时，     表示正在下载或更新城市id为state的离线包，
                    当type为TYPE_OFFLINE_ZIPCNT时，     表示检测到state个离线压缩包，
                    当type为TYPE_OFFLINE_ADD时，        表示新安装的离线地图数目，
                    当type为TYPE_OFFLINE_UNZIP时，      表示正在解压第state个离线包，
                    当type为TYPE_OFFLINE_ERRZIP时，     表示有state个错误包，
                    当type为TYPE_VER_UPDATE时，         表示id为state的城市离线包有更新，
                    当type为TYPE_OFFLINE_UNZIPFINISH时，表示扫瞄完成，成功导入state个离线包
 */
- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    NSArray *paths                      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory         = [paths objectAtIndex:0];
    MJLog(@"%@",documentDirectory);
    if (type == TYPE_OFFLINE_UPDATE)
    {
        //  id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        MJLog(@"城市名：%@,下载比例:%d",updateInfo.cityName,updateInfo.ratio);
        
    }
    if (type == TYPE_OFFLINE_NEWVER)
    {
        //  id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        MJLog(@"是否有更新%d",updateInfo.update);
    }
    if (type == TYPE_OFFLINE_UNZIP)
    {
        //  正在解压第state个离线包，导入时会回调此类型
    }
    if (type == TYPE_OFFLINE_ZIPCNT)
    {
        //  检测到state个离线包，开始导入时会回调此类型
        MJLog(@"检测到%d个离线包",state);
        if(state==0)
        {
            
        }
    }
    if (type == TYPE_OFFLINE_ERRZIP)
    {
        //  有state个错误包，导入完成后会回调此类型
        MJLog(@"有%d个离线包导入错误",state);
    }
    if (type == TYPE_OFFLINE_UNZIPFINISH)
    {
        MJLog(@"成功导入%d个离线包",state);
        //  导入成功state个离线包，导入成功后会回调此类
    }

    
    
}

#pragma mark - 更具类型保存图片到大头针图片数组
/**
 *  根据类型保存图片
 *
 *  @param typeStr
 */
- (void)saveIconWithTypeStr:(NSInteger )typeStr
{
    
    if (typeStr == 1)
    {
        [self.iconArray addObject:@"zj_point_1"];
    }
    else if (typeStr == 2)
    {
        [self.iconArray addObject:@"zj_point_2"];
    }else if (typeStr == 3)
    {
        [self.iconArray addObject:@"zj_point_3"];
    }
    else if (typeStr == 4)
    {
        [self.iconArray addObject:@"zj_point_4"];
    }
    else
    {
        [self.iconArray addObject:@"zj_point_1_2"];
    }
    
}

#pragma mark - 清除定位

/**
 *  清除定位
 */
-(void)cleanMap
{
    //  一开始以为这种写法多此一举，后来测试发现必须这样才可以删除???太操蛋了~~~~
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.iconArray removeAllObjects];
    self.indexNum = 0;
    [self.mapView removeAnnotations:array];
}

#pragma mark - 页面释放

/**
 *  释放时移除通知
 */
- (void)dealloc
{
    MJLog(@"释放了");
    if (_mapView) {
        _mapView = nil;
    }
    [MJNotifCenter removeObserver:self name:notificationLocationName object:nil];
}

@end
