//
//  AppDelegate.h
//  Encounter
//
//  Created by 李明军 on 19/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKLocationServiceDelegate,RCIMConnectionStatusDelegate>
{
    BMKMapManager * _mapManager;
}
@property (strong, nonatomic) UIWindow              *window;

/** 定位管理器 */
@property (nonatomic,strong) CLLocationManager      *locationManager;
/** 定位定线程 */
@property (strong,nonatomic) NSThread               *myLocationTimerThread;
/** 上传足迹线程 */
@property (strong,nonatomic) NSThread               *upLocationTimerThread;
/** 定时获取新消息线程 */
@property (nonatomic,strong) NSThread               *geNoreadCountThread;
/** 获取新消息定时器 */
@property (nonatomic,strong) NSTimer                *geNoreadCountTimer;
/** 定位定时器 */
@property (nonatomic,strong) NSTimer                *timer;
/** 弹窗      */
@property (strong,nonatomic) UIAlertView            *authorityAlertView;
/** 足迹数组    */
@property (nonatomic,strong) NSMutableArray         *myFootArray;
/** 是否上传足迹 */
@property (assign,nonatomic) BOOL                   isUploadingFoot;
/** 百度定位服务 */
@property (nonatomic,strong) BMKLocationService     *baiduLocationService;
/** 记录上一个d定位 */
@property (nonatomic,assign) CLLocationCoordinate2D preLocation;
/** 记录当前足迹 */
@property (nonatomic,assign) CLLocationCoordinate2D currentLocation;
/** 通知用户信息字典 */
@property (nonatomic,strong) NSMutableDictionary    *notifUserInfoDic;


/**
 *  设置自动定位是否开启
 */
- (void)setLocationIsStart;


/**
 *  1. 启动定位线程
 */
- (void)startLocationTrack;

/**
 *  2. 停止定位线程
 */
- (void)stopLocationTrack;

/**
 *  请求当前热点
 */
- (void)requestCurrentHotWithBlock:(void(^)()) block;

/**
 *  获取历史足迹====特别注意，时在登录之后才能获取
 */
- (void)getfootArray;

/**
 *  停止是否为新足迹子线程
 */
- (void)stopIsUnknowThread;

/**
 *  开启判断是否位新足迹子线程
 */
- (void)startIsUnknowStark;

/**
 *  开启获取新消息线程
 */
- (void)startNoReadThread;

/**
 *  停止获取新消息线程
 */
- (void)stopNoReadThread;

@end

