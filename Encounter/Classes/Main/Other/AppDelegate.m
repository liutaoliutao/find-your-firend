//
//  AppDelegate.m
//  Encounter
//
//  Created by 李明军 on 19/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#define locateFrequence 180
#define locationFootRequestM @"RecordFootprint"
#define requestHander       @"HotspotHandler.ashx?"
#define requestM            @"GetUserHotspot"
#define requestLat          @"Lat"
#define requestLon          @"Long"

#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]

#define IsIOS7Later                         !(IOSVersion < 7.0 )

#define IsIOS8Later                         !(IOSVersion < 8.0 )

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


#import "AppDelegate.h"
#import "MJLoginViewController.h"
#import "AFNetworking.h"
#import "NSString+Hash.h"
#import "IQKeyboardManager.h"
#import "MJConst.h"
#import <CoreLocation/CoreLocation.h>

#import "ReverseGeocodeHelper.h"
#import "RCDChatViewController.h"
#import "MJMyConViewController.h"

@interface AppDelegate ()<BMKGeneralDelegate,CLLocationManagerDelegate,RCIMReceiveMessageDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate>

/** 判断当前定位权限状态 */
@property (nonatomic,assign) NSInteger          openLocationMa;
/** 记录足迹数组 */
@property (nonatomic,strong) NSMutableArray     *recordFootArray;
/** 失败次数 */
//@property (nonatomic,assign) NSInteger          errerNum;
/** 成功定位次数 */
@property (nonatomic,assign) NSInteger          successNum;
/** 定位次数 */
@property (nonatomic,assign) NSInteger locationNu;
/** 上传足迹次数 */
@property (nonatomic,assign) NSInteger          sendFootNum;
/** 上传足迹请求 */
@property (nonatomic,strong) AFHTTPRequestOperationManager *upFootRequestManager;


@end

@implementation AppDelegate

#pragma mark - 懒加载

#pragma mark  1. 定位管理
/**
 *  定位管理
 *
 *  @return 定位管理
 */
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
    }
    return _locationManager;
}

#pragma mark  2. 记录当前足迹数组
/**
 *  记录当前足迹数组
 *
 *  @return 足迹数组
 */
- (NSMutableArray *)recordFootArray
{
    if (!_recordFootArray) {
        _recordFootArray = [NSMutableArray array];
    }
    return _recordFootArray;
}

#pragma mark  3. 定位通知用户信息字典
/**
 *  定位通知用户信息字典
 *
 *  @return 定位通知字典
 */
- (NSMutableDictionary *)notifUserInfoDic
{
    if (!_notifUserInfoDic) {
        _notifUserInfoDic = [NSMutableDictionary dictionary];
    }
    return _notifUserInfoDic;
}

#pragma mark  4. 百度定位服务
/**
 *  百度定位服务
 *
 *  @return 百度定位服务
 */
- (BMKLocationService *)baiduLocationService
{
    if (!_baiduLocationService) {
        _baiduLocationService = [[BMKLocationService alloc]init];;
    }
    return _baiduLocationService;
}


#pragma mark - application

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //  添加程序崩溃捕获
    UIWindow *window            = [[UIWindow alloc]init];
    window.frame                = [UIScreen mainScreen].bounds;
    UIStoryboard *loginSbd      = [UIStoryboard storyboardWithName:@"MJLogin" bundle:nil];
    window.rootViewController   = [loginSbd instantiateInitialViewController];
    [window makeKeyAndVisible];
    self.window                 = window;
   [self requestCurrentDevice];
     NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    [MJUserDefault removeObjectForKey:@"sendFootNum"];
//    [MJUserDefault removeObjectForKey:userDefaultLatestFootPrint];
    
    //  开启日志记录线程
//    [self startLogTrack];
    
    if (launchOptions)
    {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        MJLog(@"%@",userInfo);
//        if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
//        {
//            MJLog(@"推送userInfo%@",notification);
//            RCMessage *userMessage = notification.object;
//            RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
//            _conversationVC.conversationType = userMessage.conversationType;
//            _conversationVC.targetId = userMessage.targetId;
//            _conversationVC.targetName = userMessage.objectName;
//            _conversationVC.name = userMessage.objectName;
//            
//            if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
//                
//                MJMyConViewController *rongYunMessageVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageRongYunC"];
//                [rongYunMessageVC.navigationController pushViewController:_conversationVC animated:YES];
//            }
//            
//            
//            
//        }

    }
    
/**===========================================================================================*/
    
    //  缓存用户定位状态
    self.openLocationMa = 0;
    self.locationNu       = 0;
    self.successNum     = 0;
    
    [MJUserDefault setObject:@(self.openLocationMa) forKey:isOpenLocation];
    [MJUserDefault synchronize];
    
/**===========================================================================================*/
    
   
    
//    [self requestCurrentDeviceToDevice];
    
/**===========================================================================================*/
    
    
    //  定位权限获取，百度地图KPI初始化授权
    [self baiduMapApiSet];
    
/**===========================================================================================*/
    
    //  推送权限
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:notiSettings];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }

/**===========================================================================================*/
    
    //  初始化融云sdk
    [self setRongCloudDeviceToken];
    NSString *_deviceTokenCache = [MJUserDefault objectForKey:userDefaultDeviceToken];
    
    //  初始化融云SDK
    [[RCIM sharedKit] initWithAppKey:@"x4vkb1qpv60vk" deviceToken:_deviceTokenCache];
    //  设置会话列表头像和会话界面头像
    [[RCIM sharedKit] setConnectionChangedDelegate:self];
    //  [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [[RCIM sharedKit] setReceiveMessageDelegate:self];
    if (iPhone6Plus)
    {
        [RCIM sharedKit].globalConversationPortraitSize = CGSizeMake(56, 56);
    }
    else
    {
        NSLog(@"iPhone6 %d", iPhone6);
        [RCIM sharedKit].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    
    //  融云demo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)
                                                 name:RCKitDispatchMessageNotification
                                               object:nil];
    
/**===========================================================================================*/

    
    
    
    //  设置键盘工具条不可见
    [self setKeyBoardTooBar];
    
    //  是否保存到真机调试
//    UIDevice *device = [UIDevice currentDevice];
//    if ([[device model] isEqualToString:@"iPhone Simulator"])
//    {
//        [self addRecordFileForSelf];
//    }
//
    
    return YES;
    
    
}

#pragma mark - 测试版本请求

- (void)requestCurrentDevice
{
    //  测试版本请求
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *str = [NSString stringWithFormat:@"IosLogo%@",requestSecuKey];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[str md5String]        forKey:@"Sign"];
        [param setObject:@"GetSysConfig"        forKey:@"M"];
        [param setObject:@"IosLogo"          forKey:@"ParamFlag"];

    
        [manager POST:[NSString stringWithFormat:@"%@V2/SysConfig.ashx?",SERVERADDRESS] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            MJLog(@"......版本检测%@",dic);
            if ([[dic objectForKey:@"retCode"] integerValue] == 1) {
//                NSDictionary *dict = [dic objectForKey:@"retData"];
                NSArray *resultA = [dic objectForKey:@"retData"];
                [self requestDeviceWithDic:resultA[0]];
            }
            else
            {
                MJLog(@"请求失败");
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            MJLog(@"....%@",error);
            [[manager operationQueue] cancelAllOperations];
        }];

}



- (void)requestDeviceWithDic:(NSDictionary *)dic
{
    NSString  *paramValue           = [dic objectForKey:@"ParamValue"];
    NSString *paramName         = [dic objectForKey:@"ParamName"];
    NSString *paramFlag         = [dic objectForKey:@"ParamFlag"];
    NSString *paramCreateTime   = [dic objectForKey:@"CeateTime"];
    NSString *markStr           = [dic objectForKey:@"Remark"];
    
    [MJUserDefault setObject:paramValue forKey:@"ServiceRemark"];
    MJLog(@"ParamValue%@",paramValue);
    MJLog(@"paramName%@",paramName);
    MJLog(@"paramFlag%@",paramFlag);
    MJLog(@"markStr%@",markStr);
    
}

#ifdef __IPHONE_8_0
/**
 *  注册推送通知
 *
 *  @param application          application
 *  @param notificationSettings 通知
 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
// 获取苹果推送权限成功。
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    [MJUserDefault removeObjectForKey:userDefaultDeviceToken];
    // 设置 deviceToken。
    [MJUserDefault setObject:token forKey:userDefaultDeviceToken];
    [MJUserDefault synchronize];
    [self setRongCloudDeviceToken];
    MJLog(@"获取苹果deviceToken%@",token);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    int unreadMsgCount = [[RCIMClient sharedClient]getUnreadCount: @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_PUBLICSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self isDangerUser];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{

    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    
//    MJLog(@"推送userInfo%@",userInfo);
////    if (application.applicationState != UIApplicationStateActive)
////    {
////        MJLog(@"推送userInfo%@",userInfo);
////        
////    }
//}
//
//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    MJLog(@"推送userInfo%@",userInfo);
//    
//}

#pragma mark - 检测是否被封号

- (void)isDangerUser
{
    AFHTTPRequestOperationManager *isDangerManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"GetAccountState"       forKey:requestKey];
    
    [isDangerManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dic = responseObject;
        MJLog(@"检测是否被封号-连接服务器成功%@",dic);
        NSArray *resultA = [dic objectForKey:@"Result"];
        NSDictionary *resultDic = [resultA firstObject];
        BOOL bloc = [[resultDic objectForKey:@"isblock"] boolValue];
        BOOL isdel = [[resultDic objectForKey:@"isdel"] boolValue];
        if (bloc == 1 && isdel == 1)
        {
            [self loginOut];
            [MMProgressHUD showAlert:@"账号因严重违规已被禁止使用和注册"];
        }
        if (bloc)
        {
            [self loginOut];
            [MMProgressHUD showAlert:@"账号因违规已被封禁请，请等待解封"];
        }
        if (isdel)
        {
            [self loginOut];
            [MMProgressHUD showAlert:@"账号因违规已被删除，请重新注册"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"检测是否被封号-连接服务器失败%@",error);
    }];
    
}

/**
 *  退出登录
 */
- (void)loginOut
{
    [MJUserDefault removeObjectForKey:@"userNameTextLogin"];
    //            [MJUserDefault removeObjectForKey:@"userPwdTextLogin"];
    [MJNotifCenter removeObserver:self];
    [SFHFKeychainUtils deleteItemForUsername:[MJUserDefault objectForKey:@"userNameTextLogin"] andServiceName:@"yibaiwuUserName" error:nil];
    [MJUserDefault removeObjectForKey:@"userGoDistance"];
    [MJUserDefault removeObjectForKey:userDefaultCurrentLocationLat];
    [MJUserDefault removeObjectForKey:userDefaultCurrentLocationLon];
    [MJUserDefault removeObjectForKey:userDefaultIsOnLocation];
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    [[RCIM sharedKit] removeInactiveController];
    [[RCIM sharedKit] disconnect];
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appD stopLocationTrack];
    [appD stopNoReadThread];
    UIStoryboard *loginSbd              = [UIStoryboard storyboardWithName:@"MJLogin" bundle:nil];
    appD.window.rootViewController      = [loginSbd instantiateInitialViewController];
}

#pragma mark - 设置键盘工具条
/**
 *  设置键盘工具条
 */
- (void)setKeyBoardTooBar
{
    IQKeyboardManager *keyboardManager  = [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar   = NO;
}

#pragma mark - 注册融云
/**
 *  注册融云，设置权限
 */
- (void)setRongCloudDeviceToken
{
    if ([MJUserDefault objectForKey:userDefaultDeviceToken])
    {
        [[RCIM sharedKit] initWithAppKey:@"x4vkb1qpv60vk" deviceToken:[MJUserDefault objectForKey:userDefaultDeviceToken]];
//         initWithAppKey:@"x4vkb1qpv60vk" deviceToken:deviceTokenCache];
        MJLog(@"缓存有deviceToken");
    }
    else
    {
        [[RCIM sharedKit] initWithAppKey:@"x4vkb1qpv60vk" deviceToken:nil];
        MJLog(@"缓存没有deviceToken");
    }
//    // 快速集成第二步，连接融云服务器
//    [[RCIM sharedKit] connectWithToken:RONGCLOUD_IM_USER_TOKEN success:^(NSString *userId) {
//        // Connect 成功
//        MJLog(@"融云链接成功");
//        
//    } error:^(RCConnectErrorCode status) {
//        // Connect失败
//        MJLog(@"融云链接失败%@",status);
//    }];
}


#pragma mark - 防止重复弹窗

/**
 *  通过弹窗代理，防止重复弹窗
 *
 *  @param alertView   弹窗
 *
 *  @param buttonIndex 点击按钮
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //防止重复弹出提示框
    if (alertView==_authorityAlertView) {
        _authorityAlertView=nil;
    }
}


#pragma mark - 根据用户是否设置自动定位，设置定位状态

/**
 *  设置自动定位是否开启
 */
- (void)setLocationIsStart
{
    //  记录程序启动时定位状态，在足迹中用于判断定位状态，来决定是否可以结束或者开启定位
    BOOL appStartIsOn;
    //  用户偏好有用户定位偏好设置，足迹中自动定位开关是否打开
    if ([MJUserDefault objectForKey:userDefaultIsOnLocation])
    {
        //  取出用户偏好设置
        BOOL isOnLocation = [[MJUserDefault objectForKey:userDefaultIsOnLocation] boolValue];
        appStartIsOn = isOnLocation;
        //  记录定位开启状态
        [MJUserDefault setObject:@(appStartIsOn) forKey:userDefaultAppStartIsOnLocation];
        [MJUserDefault synchronize];
        //  如果设置开启，自动等位
        if (isOnLocation)
        {
            MJLog(@"用户设置开启，启动自动定位");
            [self startLocationTrack];
        }
        else
        {
            MJLog(@"用户设置关闭，不开启自动定位");
        }
        
    }
    //  用户偏好中没有用户定位偏好设置，默认开启
    else
    {
        appStartIsOn = YES;
        //  记录启动时定位状态
        [MJUserDefault setObject:@(appStartIsOn) forKey:userDefaultAppStartIsOnLocation];
        [MJUserDefault synchronize];
        MJLog(@"用户未设置，默认开启");
        [self startLocationTrack];
    }
}

#pragma mark - 百度地图sdk配置及百度定位服务

#pragma mark 1. 百度地图配置
/**
 *  1. 百度地图配置
 */
- (void)baiduMapApiSet
{
    //  1. 定位权限请求
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权

        //获取授权认证
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    //  2. 配置百度地图
    _mapManager     = [[BMKMapManager alloc]init];

    //  3. 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret        = [_mapManager start:@"wwy9iP9xCkGzTrH24kORHjHk"  generalDelegate:self];
    if (!ret)
    {
        
        MJLog(@"百度地图授权失败!");
        [self sendLogToServiceWithMessage:@"百度地图授权失败" withType:[NSString stringWithFormat:@"1"] errorStr:@""];
    }
    else
    {
       
        
        MJLog(@"百度地图授权成功");
       
    }
}


#pragma mark 2. 启动定位线程
/**
 *  2. 启动定位线程
 */
- (void)startLocationTrack{
//    [MJUserDefault removeObjectForKey:userDefaultCurrentLocationLat];
//    [MJUserDefault removeObjectForKey:userDefaultCurrentLocationLon];
//    [MJUserDefault removeObjectForKey:userDefaultCurrentLocationStr];
    //  定位和足迹对比这种事情还是放在子线程比较好
    MJLog(@"%@",self.myLocationTimerThread);
    //  初始化子线程
    self.myLocationTimerThread        = [[NSThread alloc]initWithTarget:self
                                                               selector:@selector(startTimerThread)
                                                                 object:nil];
        self.myLocationTimerThread.name   = @"locationThread";
    //  线程开启
    [self.myLocationTimerThread start];
}

#pragma mark 3. 开启定位线程方法
/*
 *  3. 开启定位线程方法
 */
- (void)startTimerThread{
    //开启足迹定位的定时器，注意，这个方法是在timerThread上执行的
    [self locationBegain];
//    [self.baiduLocationService startUserLocationService];
    self.timer              = [NSTimer scheduledTimerWithTimeInterval:180
                                                               target:self
                                                             selector:@selector(locationBegain)
                                                             userInfo:nil
                                                              repeats:YES];
    MJLog(@"%@%@",self.timer,[NSThread currentThread]);
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

#pragma mark 4. 足迹定位
/**
 *  4. 足迹定位
 */
- (void)locationBegain
{
    self.locationNu++;
    [MJUserDefault setObject:@(self.locationNu) forKey:@"lo"];
    
    [self.baiduLocationService stopUserLocationService];
    //  设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //  指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //  初始化BMKLocationService
    self.baiduLocationService.delegate  = self;
    //  启动LocationService
    [self.baiduLocationService startUserLocationService];
}


- (void)requestMyFootPrint
{
    
}


#pragma mark 5. 停止定位
/**
 *  5. 停止定位
 */
- (void)locationStop
{
    [self.baiduLocationService stopUserLocationService];
}

#pragma mark - 百度定位代理方法

#pragma mark 1. 在将要启动定位时，会调用此函数
/**
 *  1. 在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    MJLog(@"定位将要启动");
}

#pragma mark 2. 在停止定位后，会调用此函数
/**
 *  2. 在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    MJLog(@"定位终止");
}

#pragma mark 3. 用户方向更新后，会调用此函数
/**
 *  3. 用户方向更新后，会调用此函数
 *
 *  @param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    MJLog(@"用户方向改变");
}

#pragma mark 4. 用户位置更新后，会调用此函数
/**
 *  4. 用户位置更新后，会调用此函数
 *
 *  @param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
/**=========================记录成功定位次数==================================*/
    //  成功定位次数
    self.successNum++;
    [MJUserDefault setObject:@(self.successNum) forKey:@"su"];
    [MJUserDefault synchronize];
    
/**=========================当前坐标==================================*/
    //  当前坐标
    self.currentLocation = userLocation.location.coordinate;
//    [self sendLogToServiceWithMessage:[NSString stringWithFormat:@"定位成功%ld次",(long)self.successNum] withRemark:@"定位成功"];
    
/**==========================定位权限状态标识设置 1：标识开启了定位=================================*/
    //  定位权限状态标识设置 1：标识开启了定位
    self.openLocationMa = 1;
    [MJUserDefault removeObjectForKey:isOpenLocation];
    [MJUserDefault setObject:@(self.openLocationMa) forKey:isOpenLocation];
    [MJUserDefault synchronize];
    
    
/**============================将坐标转换为百度坐标系,返回base64加密坐标===============================*/
    //  将坐标转换为百度坐标系,返回base64加密坐标
    NSDictionary *baiduLoaction =  BMKConvertBaiduCoorFrom(userLocation.location.coordinate,BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D baiduCoordinate2D        = BMKCoorDictionaryDecode(baiduLoaction);
    
    //  缓存当前坐标，使用地点。。。融云会话列表获取当前热点
    [MJUserDefault setObject:[NSString stringWithFormat:@"%0.6f",userLocation.location.coordinate.latitude]              forKey:userDefaultCurrentLocationLat];
    [MJUserDefault setObject:[NSString stringWithFormat:@"%0.6f",userLocation.location.coordinate.longitude]             forKey:userDefaultCurrentLocationLon];
    [MJUserDefault synchronize];
    
    MJLog(@"%f",baiduCoordinate2D.latitude);
    MJLog(@"%f",baiduCoordinate2D.longitude);
    
/**===========================百度反地理编码，将编码结果在代理中缓存，足迹页面使用================================*/
    //  百度反地理编码，将编码结果在代理中缓存，足迹页面使用
    BMKReverseGeoCodeOption *option             = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint                      = userLocation.location.coordinate;
    BMKGeoCodeSearch *ser                       = [[BMKGeoCodeSearch alloc] init];
    ser.delegate                                = self;
    [ser reverseGeoCode:option];
    
/**==============================计算两次定位距离=============================*/
    //  计算两次定位距离
    BMKMapPoint currentPoint                    = BMKMapPointForCoordinate(baiduCoordinate2D);
    //  根据上一次坐标是否有值，判断是否位第一次定位
    if (self.preLocation.latitude)
    {
        MJLog(@"不是初次定位，比较足迹");
        
        //  计算两次定位距离
        BMKMapPoint prePoint                        = BMKMapPointForCoordinate(self.preLocation);
        CLLocationDistance distance                 = BMKMetersBetweenMapPoints(currentPoint,prePoint);
        [MJUserDefault setObject:[NSString stringWithFormat:@"%0.2f",distance] forKey:@"userGoDistance"];
        [MJUserDefault synchronize];
        //  如果距离大于300，进一步判断是否位新足迹
        if (distance/1000 >= 300)
        {
            MJLog(@"距离大于三百米，继续判断是否位新足迹");
            //  开启子线程，循环判断是否为新足迹
            [self stopIsUnknowThread];
            [self startIsUnknowStark];
            [MJUserDefault setObject:@"距离大于三百米，上传足迹" forKey:@"distanceIs"];
            [MJUserDefault synchronize];
        }
        else
        {
            [MJUserDefault setObject:@"距离小于三百米,仅测试用" forKey:@"distanceIs"];
            [MJUserDefault synchronize];
            MJLog(@"距离小于三百米,仅测试用");
            NSDateFormatter *formate    = [[NSDateFormatter alloc]init];
            formate.dateFormat          = MJDateFormat;
            //  发送定位日志
            NSString *message = [NSString stringWithFormat:@"累计记录%lu次，本次第%ld次未记录（指本地和服务器比对都未通过），未记录原因：距离小于三百米，经度%@，纬度%@，记录时间：%@",(unsigned long)self.myFootArray.count,(long)(self.successNum - self.myFootArray.count),@(baiduCoordinate2D.latitude),@(baiduCoordinate2D.longitude),[formate stringFromDate:[NSDate date]]];
            [self sendLogToServiceWithMessage:message withType:[NSString stringWithFormat:@"3"] errorStr:@""];
        }
        
    }
    else
    {
        [MJUserDefault setObject:[NSString stringWithFormat:@"%d",0] forKey:@"userGoDistance"];
        [MJUserDefault synchronize];
        [self footUpdateRequestWithCoordinate:baiduCoordinate2D distance:0];
        MJLog(@"打开应用，初次定位，上传足迹");
        [MJUserDefault setObject:@"打开应用，初次定位，上传足迹" forKey:@"distanceIs"];
        [MJUserDefault synchronize];
    }
/**=========================定位结果处理完毕，将坐标设为上一次坐标，留待下一次定位使用=================================*/
    //  定位结果处理完毕，将坐标设为上一次坐标，留待下一次定位使用
    self.preLocation                                = baiduCoordinate2D;
    //  停止定位，待下一次定时器开启定位
    [self.baiduLocationService stopUserLocationService];
}





#pragma mark 5. 定位失败后，会调用此函数
/**
 *  5. 定位失败后，会调用此函数
 *
 *  @param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = MJDateFormat;
    NSString *message = [NSString stringWithFormat:@"累计定位%ld次，本次第%ld次失败，失败原因：%@，记录时间：%@",(unsigned long)self.locationNu,(long)(self.locationNu - self.successNum),[NSString stringWithFormat:@"%@",error],[formate stringFromDate:[NSDate date]]];
    [self sendLogToServiceWithMessage:message withType:[NSString stringWithFormat:@"2"] errorStr:@""];

    MJLog(@"%@",error);
}

#pragma mark - 百度反地理编码代理方法（坐标转地名），返回结果
/**
 *  百度反地理编码代理方法（坐标转地名），返回结果
 *
 *  @param searcher geo搜索服务
 *  @param result   编码结果
 *  @param error    错误信息
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSString *placeName;
    if (result)
    {
        placeName = [NSString stringWithFormat:@"%@", result.address];
        MJLog(@"placeName%@",placeName);
        [MJUserDefault setObject:placeName              forKey:userDefaultCurrentLocationStr];
        [MJUserDefault synchronize];
        
    }else{
        [MJUserDefault setObject:nil                    forKey:userDefaultCurrentLocationStr];
        [MJUserDefault synchronize];
    }
}


#pragma mark - 开辟子线程-判断当前足迹是否位新足迹

#pragma mark 1. 开启判断是否位新足迹子线程
/**
 *  开启判断是否位新足迹子线程
 */
- (void)startIsUnknowStark
{
    if ([MJUserDefault objectForKey:userDefaultIsOnLocation])
    {
        BOOL locationIsOn = [[MJUserDefault objectForKey:userDefaultIsOnLocation] boolValue];
        if (locationIsOn)
        {
            [self stopIsUnknowThread];
        }
    }
    
    self.upLocationTimerThread = [[NSThread alloc] initWithTarget:self
                                                         selector:@selector(isUnKnowFoot)
                                                           object:nil];
    [self.upLocationTimerThread start];
}

#pragma mark 2. 停止是否为新足迹子线程
/**
 *  停止是否为新足迹子线程
 */
- (void)stopIsUnknowThread
{
    
    [self performSelector:@selector(stopUnThread) onThread:self.myLocationTimerThread withObject:nil waitUntilDone:NO];
}

- (void)stopUnThread
{
    self.upLocationTimerThread  =   nil;
    [NSThread exit];

}

#pragma mark 3. 循环判断同历史足迹距离，是否位新足迹
/**
 *  循环判断同历史足迹距离，是否位新足迹
 *
 *  @param coor 当前坐标
 */
- (void)isUnKnowFoot
{
    //  从缓存中取出历史足迹数组
    NSArray *array = [MJUserDefault objectForKey:userDefaultLatestFootPrint];
    for (NSDictionary *dic in array)
    {
        CLLocationDegrees lat = [[dic objectForKey:userDefaultLatestFootPrintDicLat] doubleValue];
        CLLocationDegrees lon = [[dic objectForKey:userDefaultLatestFootPrintDicLon] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
        CLLocationDegrees currentLat = [[MJUserDefault objectForKey:userDefaultCurrentLocationLat] doubleValue];
        CLLocationDegrees currentLon = [[MJUserDefault objectForKey:userDefaultCurrentLocationLon] doubleValue];
        CLLocationCoordinate2D current = CLLocationCoordinate2DMake(currentLat, currentLon);
        BMKMapPoint sspoint                         = BMKMapPointForCoordinate(coordinate);
        BMKMapPoint currentPoint                    = BMKMapPointForCoordinate(current);
        CLLocationDistance distance                 = BMKMetersBetweenMapPoints(currentPoint,sspoint);
        MJLog(@"循环比较距离%f",distance);
        //  如果距离大于300更新足迹
        if (distance/1000 >= 300)
        {
            //  上传足迹
            [self footUpdateRequestWithCoordinate:current distance:distance];
            MJLog(@"距离大于三百米，上传足迹");
            [MJUserDefault setObject:@"距离大于三百米，上传足迹" forKey:@"distanceIs"];
            [MJUserDefault synchronize];
        }
        else
        {
            //                        [self footUpdateRequestWithCoordinate:self.currentLocation distance:distance];
            [MJUserDefault setObject:@"距离小于三百米,仅测试用" forKey:@"distanceIs"];
            [MJUserDefault synchronize];
            MJLog(@"距离小于三百米,仅测试用");
            NSDateFormatter *formate = [[NSDateFormatter alloc]init];
            formate.dateFormat = MJDateFormat;
            
            NSString *message = [NSString stringWithFormat:@"累计记录%lu次，本次第%ld次未记录（指本地和服务器比对都未通过），未记录原因：距离小于三百米，经度%@，纬度%@，记录时间：%@",(unsigned long)self.myFootArray.count,(long)(self.successNum - self.myFootArray.count),@(lat),@(lon),[formate stringFromDate:[NSDate date]]];
            [self sendLogToServiceWithMessage:message withType:[NSString stringWithFormat:@"3"] errorStr:@""];
            
        }
        
    }
}


#pragma mark - 获取历史足迹


/**
 *  获取历史足迹====特别注意，时在登录之后才能获取
 */
- (void)getfootArray
{
    AFHTTPRequestOperationManager *footManager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"GetMyFootprint" forKey:requestKey];
    [params setObject:@"2015-01-01"     forKey:@"Begin_date"];
    [params setObject:@"2020-01-01"     forKey:@"End_date"];
    [params setObject:@"0"              forKey:@"Pagesize"];
    [params setObject:@"0"              forKey:@"Pageindex"];
    //http://m.yibaiwu.com/Handler/GetData.ashx?
    //M=GetMyFootprint&&Begin_date=1990&End_date=3000&GetMyFootprint=0&Pageindex=0
    [footManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        MJLog(@"获取历史足迹-连接服务器成功%@",dic);
        BOOL isSuccess = [[dic objectForKey:@"IsSuccess"] boolValue];
        if (isSuccess)
        {
            MJLog(@"获取成功");
            NSArray *resultArray = [dic objectForKey:@"Result"];
            [self getfootSucessWithArray:resultArray];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"获取历史足迹-连接服务器失败%@%@",error,operation);
    }];
}

/**
 *  获取历史足迹处理
 *
 *  @param array
 */
- (void)getfootSucessWithArray:(NSArray *)array
{
    for (NSDictionary *dic in array) {
        NSString *latStr            = [dic objectForKey:@"Lat"];
        NSString *longStr           = [dic objectForKey:@"Long"];
        NSString *creatTimeStr      = [dic objectForKey:@"Create_time"];
        NSString *placeStr          = [dic objectForKey:@"Place"];
        
        NSMutableDictionary *recordFootDic          = [NSMutableDictionary dictionary];
        [recordFootDic setObject:latStr             forKey:userDefaultLatestFootPrintDicLat];
        [recordFootDic setObject:longStr            forKey:userDefaultLatestFootPrintDicLon];
        [recordFootDic setObject:creatTimeStr       forKey:userDefaultLatestFootPrintDicTime];
        [recordFootDic setObject:placeStr           forKey:userDefaultLatestFootPrintDicAddress];
        
        [self saveFootArrayWithDic:recordFootDic];
    }
    
    
}

#pragma mark - 上传足迹

#pragma mark 1.上传足迹
/**
 *  上传足迹
 *
 *  @param coordinate 坐标
 */
- (void)footUpdateRequestWithCoordinate:(CLLocationCoordinate2D)coordinate distance:(CLLocationDistance) distance
{
    self.sendFootNum++;
    [MJUserDefault setObject:@(self.sendFootNum) forKey:@"sendFoot"];
    [MJUserDefault synchronize];
    
    //  在上传服务器足迹的同时，发出通知，通知足迹页，足迹改变
    [self postNotificationOfLocationWithUserInfo:coordinate distance:distance];
    
    //  将所有坐标转换为百度坐标系编码
    [[ReverseGeocodeHelper shareInstancetype] beginReverseGeocodeWith:coordinate success:^(BMKReverseGeoCodeResult *result) {
        
        //  1. 创建网络请求管理器
        self.upFootRequestManager = [AFHTTPRequestOperationManager manager];
        //  1.1. 获取上传字符串
        NSMutableDictionary *params                    = [NSMutableDictionary dictionary];
        NSString *latStr                               = [NSString stringWithFormat:@"%0.6f",coordinate.latitude];
        MJLog(@"%@",latStr);
        NSString *longStr                              = [NSString stringWithFormat:@"%0.6f",coordinate.longitude];
        MJLog(@"%@",longStr);
        //  1.2. 将地址编为UTF-8
        //        NSString *ufStr = [result.address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        MJLog(@"ufStr\n%@",ufStr);
        //  1.3. 拼接sign字符串，并进行MD5加密
        NSString *signString                           = [NSString stringWithFormat:@"%@%@%@",latStr,longStr,requestSecuKey];
        MJLog(@"signString\n%@",signString);
        NSString *signStr                              = [signString md5String];
        
        MJLog(@"%@",signStr);
        
        //  1.4. 创建数据包M=RecordFootprint&Lat=29.708740&Long=106.517020&Place=%E9%87%8D%E5%BA%86%E5%B8%82%E5%8C%97%E7%A2%9A%E5%8C%BA&Sign=2007bf0748cb716887e9cfbb35c66ce4
        [params setObject:locationFootRequestM         forKey:requestKey];
        [params setObject:latStr                       forKey:requestKeyLocationLat];
        [params setObject:longStr                      forKey:requestKeyLocationLong];
        [params setObject:result.address               forKey:requestKeyLocationPlace];
        [params setObject:signStr                      forKey:requestKeySign];
        
        //  2. 拼接url
        NSString *urlStr = [NSString stringWithFormat:@"%@V2/FootprintHandler.ashx?",SERVERADDRESS];
        
        //  3， 发送请求
        [self.upFootRequestManager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic                       = responseObject;
            NSString *dica                          = [dic objectForKey:@"retMsg"];
            MJLog(@"请求成功:%@\n%@",dica,dic);
            NSDictionary *resultDic                 = [dic objectForKey:@"retData"];
            
            NSString *creatTimeStr                  = [resultDic objectForKey:@"Create_time"];
            BOOL isSuccess                          = [[resultDic objectForKey:@"IsSuccess"] boolValue];
            if (isSuccess)
            {
                //  3.1.创建缓存足迹字典
                NSMutableDictionary *recordFootDic      = [NSMutableDictionary dictionary];
                [recordFootDic setObject:latStr             forKey:userDefaultLatestFootPrintDicLat];
                [recordFootDic setObject:longStr            forKey:userDefaultLatestFootPrintDicLon];
                [recordFootDic setObject:creatTimeStr       forKey:userDefaultLatestFootPrintDicTime];
                [recordFootDic setObject:result.address     forKey:userDefaultLatestFootPrintDicAddress];
                
                [self saveFootArrayWithDic:recordFootDic];
                
            }
            else
            {
                
                NSString *me = [resultDic objectForKey:@"Message"];
                MJLog(@"me%@",me);
                NSDateFormatter *formate = [[NSDateFormatter alloc]init];
                formate.dateFormat = MJDateFormat;
                
                NSString *message = [NSString stringWithFormat:@"累计记录%lu次，本次第%ld次未记录（指本地和服务器比对都未通过），未记录原因：%@，地址：%@，记录时间：%@",(unsigned long)self.myFootArray.count,(long)(self.successNum - self.myFootArray.count),me,result.address,[formate stringFromDate:[NSDate date]]];
                [self sendLogToServiceWithMessage:message withType:[NSString stringWithFormat:@"3"] errorStr:@""];
            }
            MJLog(@"creatTimeStr%@",creatTimeStr);
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSDateFormatter *formate = [[NSDateFormatter alloc]init];
            formate.dateFormat = MJDateFormat;
            
            NSString *message = [NSString stringWithFormat:@"累计记录%lu次，本次第%ld次未记录（指本地和服务器比对都未通过），未上传原因：网络请求失败，地址：%@，记录时间：%@",(unsigned long)self.myFootArray.count,(long)(self.successNum - self.myFootArray.count),result.address,[formate stringFromDate:[NSDate date]]];
            [self sendLogToServiceWithMessage:message withType:[NSString stringWithFormat:@"3"] errorStr:@""];
            MJLog(@"请求失败%@",error);
        }];
    }];
    
    
}

#pragma mark 2.保存最近的一百条足迹
/**
 *  保存最近的一百条足迹
 *
 *  @param footDic 字典
 */
- (void)saveFootArrayWithDic:(NSDictionary *)footDic
{
    if (100 > self.recordFootArray.count)
    {
        MJLog(@"不足一百条足迹%lu",(unsigned long)self.recordFootArray.count);
        [self.recordFootArray addObject:footDic];
    }
    else
    {
        MJLog(@"超过一百条足迹%lu",(unsigned long)self.recordFootArray.count);
        [self.recordFootArray removeObjectAtIndex:0];
        [self.recordFootArray addObject:footDic];
    }
    [MJUserDefault removeObjectForKey:userDefaultLatestFootPrint];
    [MJUserDefault setObject:self.recordFootArray forKey:userDefaultLatestFootPrint];
    [MJUserDefault synchronize];
}


#pragma mark - 当定位置后发出通知
/**
 *  当定位置后发出通知
 *
 *  @param coordinate 通知传出当前定位坐标
 */
- (void)postNotificationOfLocationWithUserInfo:(CLLocationCoordinate2D) coordinate distance:(CLLocationDistance) dis
{
    [self.notifUserInfoDic removeAllObjects];
    [self.notifUserInfoDic setObject:@(coordinate.latitude)     forKey:notificationUserInfoKeyLat];
    [self.notifUserInfoDic setObject:@(coordinate.longitude)    forKey:notificationUserInfoKeyLon];
    [self.notifUserInfoDic setObject:@(dis)                     forKey:notificationUserInfoKeyDis];
    NSString *str = [MJUserDefault objectForKey:userDefaultCurrentLocationStr];
    if(str) [self.notifUserInfoDic setObject:str                        forKey:@"notificationUserInfoKeyPlaceStr"];
    [MJNotifCenter postNotificationName:notificationLocationName object:nil userInfo:self.notifUserInfoDic];
}


#pragma mark - 请求当前热点

#pragma mark   1. 请求当前热点
/**
 *  请求当前热点
 */
- (void)requestCurrentHotWithBlock:(void(^)()) block
{
    //  创建请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //  如果当前定位有缓存，从缓存中取，如果当前定位没有缓存，从足迹数组中取最新足迹作为当前位置
    CLLocationDegrees lat;
    CLLocationDegrees lon;
    if ([MJUserDefault objectForKey:userDefaultCurrentLocationLat])
    {
        lat = [[MJUserDefault objectForKey:userDefaultCurrentLocationLat] doubleValue];
        lon = [[MJUserDefault objectForKey:userDefaultCurrentLocationLon] doubleValue];
    }else
    {
        NSArray *footArray = [MJUserDefault objectForKey:userDefaultLatestFootPrint];
        MJLog(@"footArray%lu",(unsigned long)footArray.count);
        if (footArray.count > 0)
        {
            NSDictionary *dic = [footArray lastObject];
            lat = [[dic objectForKey:userDefaultLatestFootPrintDicLat] doubleValue];
            lon = [[dic objectForKey:userDefaultLatestFootPrintDicLon] doubleValue];
        }
        else
        {
            lat = 30.85317;
            lon = 106.160466;
        }
    }
    //  拼接请求字符串
    NSString *latStr    = [NSString stringWithFormat:@"%f",lat];
    NSString *lonStr    = [NSString stringWithFormat:@"%f",lon];
    NSString *signStr   = [NSString stringWithFormat:@"%@",requestSecuKey];
    MJLog(@"latStr%@",latStr);
    MJLog(@"lonStr%@",lonStr);
    MJLog(@"signStr%@\nmd5%@",signStr,[signStr md5String]);
    
    //  拼接上传数据包
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:requestM                  forKey:requestKey];
    [params setObject:latStr                    forKey:requestLat];
    [params setObject:lonStr                    forKey:requestLon];
    [params setObject:[signStr md5String]       forKey:requestKeySign];
    
    //  发送请求
    [manager POST:[NSString stringWithFormat:@"%@V2/%@",SERVERADDRESS,requestHander]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        //  获取当前返回数据
        MJLog(@"请求最近的热点-连接服务器成功");
        NSDictionary *dic                   = responseObject;
        MJLog(@"请求最近的热点 -返回%@",dic);
        NSString *message                   = [dic objectForKey:@"retMsg"];
        MJLog(@"请求最近的热点%@",message);
        
        //  判断请求状态
        NSString *isSuccessStr              = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
        
        //  若成功取出热点信息，并缓存
        if ([isSuccessStr isEqualToString:@"1"])
        {
            NSDictionary *reDic             = [dic objectForKey:@"retData"];
            
            [self successWithDic:reDic];
            block();
        }
        //  若请求失败
        else
        {
            MJLog(@"请求最近的热点-请求失败%@",message);
        }
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSHTTPCookieStorage *cookieJar      = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
            MJLog(@"%@", cookie);
        }
        MJLog(@"请求最近的热点-连接服务器失败%@",error);
    }];
}

#pragma mark   2. 处理热点请求成功事件，因为用到之处很多，所以写在这里
/**
 *  处理热点请求成功事件，因为用到之处很多，所以写在这里
 *
 *  @param dic 返回数据
 */
- (void)successWithDic:(NSDictionary *)dic
{
    //  取出热点信息
    NSString *creatTimeStr                          = [dic objectForKey:@"CreateTime"];
    NSInteger currentSpot                           = [[dic objectForKey:@"HotspotId"] integerValue];
    NSInteger shoppingSpotStr                       = [[dic objectForKey:@"HotspotType"] integerValue];
    NSString *imageUrlStr                           = [dic objectForKey:@"Image"];
    NSString *place                                 = [dic objectForKey:@"PlaceName"];
    NSString *title                                 = [dic objectForKey:@"Title"];
    NSInteger lat                                   = [[dic objectForKey:@"Lat"] integerValue];
    NSInteger lon                                   = [[dic objectForKey:@"Long"] integerValue];
    NSString *content                               = [dic objectForKey:@"Content"];
    
    MJLog(@"creatTimeStr%@"     ,    creatTimeStr           );
    MJLog(@"currentSpotStr%ld"  ,    (long)currentSpot      );
    MJLog(@"shoppingSpotStr%ld" ,    (long)shoppingSpotStr  );
    MJLog(@"imageUrlStr%@"      ,    imageUrlStr            );
    MJLog(@"place%@"            ,    place                  );
    MJLog(@"title%@"            ,    title                  );
    
    //  缓存当前热点信息
    NSMutableDictionary *spotDic = [NSMutableDictionary dictionary];
    
    
    if (![creatTimeStr isEqualToString:@""] || creatTimeStr)
        [spotDic setObject:creatTimeStr        forKey:userDefaultCurrentSpotCreatTimeStr];
    if (currentSpot)
        [spotDic setObject:@(currentSpot)      forKey:userDefaultCurrentSpotHotspotIdStr];
    if (shoppingSpotStr)
        [spotDic setObject:@(shoppingSpotStr)  forKey:userDefaultCurrentSpotHotspotTypeStr];
    if (![imageUrlStr  isEqualToString:@""] || imageUrlStr)
        [spotDic setObject:imageUrlStr         forKey:userDefaultCurrentSpotImageStr];
    if (![place        isEqualToString:@""] || place)
        [spotDic setObject:place               forKey:userDefaultCurrentSpotPlaceNameStr];
    if (![title isKindOfClass:[NSNull class]])
        [spotDic setObject:title               forKey:userDefaultCurrentSpotTitleStr];
    if (lat)
        [spotDic setObject:@(lat)              forKey:userDefaultCurrentSpotLatStr];
    if (lon)
        [spotDic setObject:@(lon)              forKey:userDefaultCurrentSpotLonStr];
    if (content)
        [spotDic setObject:content              forKey:@"userDefaultCurrentSpotContentStr"];
    [MJUserDefault setObject:spotDic           forKey:userDefaultCurrentSpot];
    [MJUserDefault synchronize];

}



#pragma mark - 停止定位

#pragma mark 1. 停止定位线程
/**
 *  1. 停止定位线程
 */
- (void)stopLocationTrack
{
    [MJUserDefault removeObjectForKey:userDefaultCurrentLocationLat];
    [MJUserDefault removeObjectForKey:userDefaultCurrentLocationLon];
    [MJUserDefault removeObjectForKey:userDefaultCurrentLocationStr];
    [MJUserDefault removeObjectForKey:@"userGoDistance"];
    [self performSelector:@selector(stopTimerThread) onThread:self.myLocationTimerThread withObject:nil waitUntilDone:NO];
}

#pragma mark 2. 停止定位，并清空定时器和线程
/**
 *  2. 停止定位，并清空定时器和线程
 */
- (void)stopTimerThread
{
    [self.timer invalidate];
    self.timer                  =   nil;
    self.myLocationTimerThread  =   nil;
    [NSThread exit];
}

#pragma mark - 设置日志文件，保存到沙盒中，文件名dr.log
/**
 *  开启日志记录线程
 */
- (void)startLogTrack
{
    [[[NSThread alloc] initWithTarget:self
                             selector:@selector(addRecordFileForSelf)
                               object:nil]
     start];
}

/**
 *  设置日志文件，保存到沙盒中，文件名dr.log
 *
 *  沙盒路径
 *   /Users/limingjun/Library/Developer/CoreSimulator/Devices/0F43C80D-CDDC-43D9-9FC0-9F7CD9A96E31/data/Containers/Data/Application/C3F4F922-E2B2-4ADD-A697-D01564DE84D6/Documents/dr.log
 */
- (void)addRecordFileForSelf
{
    NSArray *paths                      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory         = [paths objectAtIndex:0];
    NSString *fileName                  = [NSString stringWithFormat:@"dr.log"];
    NSString *logFilePath               = [documentDirectory stringByAppendingPathComponent:fileName];
    
    MJLog(@"%@",logFilePath);
    //  删除已存在同名文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:logFilePath error:nil];
    
    //  将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+" , stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "A+" , stderr);
    
    
}

#pragma mark - 融云demo设置badgeNum
/**
 *  融云demo  - （本想获取推送后台点击前往页面，但是不起作用）
 *
 *  @param notification 通知
 */
- (void)didReceiveMessageNotification:(NSNotification *)notification
{
//    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
    {
        MJLog(@"推送userInfo%@",notification);
        RCMessage *userMessage                  = notification.object;
        RCDChatViewController *_conversationVC  = [[RCDChatViewController alloc]init];
        _conversationVC.conversationType        = userMessage.conversationType;
        _conversationVC.targetId                = userMessage.targetId;
        _conversationVC.targetName              = userMessage.objectName;
        _conversationVC.name                    = userMessage.objectName;
        
        if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {

            MJMyConViewController *rongYunMessageVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageRongYunC"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [rongYunMessageVC.navigationController pushViewController:_conversationVC animated:YES];
            });
            
        }
        


    }
//     MJLog(@"推送userInfo%@",notification);
    
}

#pragma mark - 融云连接状态代理
/**
 *  融云代理，同账号登陆，退回登陆界面
 *
 *  @param status
 */
- (void)onKitConnectionStatusChanged:(RCConnectionStatus)status
{
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert                  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                         message:@"您的帐号在别的设备上登录，您被迫下线！"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"知道了"
                                                               otherButtonTitles:nil, nil];
        [alert show];
        [MJUserDefault removeObjectForKey:@"userNameTextLogin"];
        //            [MJUserDefault removeObjectForKey:@"userPwdTextLogin"];
        [MJNotifCenter removeObserver:self];
        [SFHFKeychainUtils deleteItemForUsername:[MJUserDefault objectForKey:@"userNameTextLogin"] andServiceName:@"yibaiwuUserName" error:nil];
        [[RCIM sharedKit] removeInactiveController];
        [[RCIM sharedKit] disconnect];
//        AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [self stopLocationTrack];
        UIStoryboard *loginSbd              = [UIStoryboard storyboardWithName:@"MJLogin" bundle:nil];
        self.window.rootViewController      = [loginSbd instantiateInitialViewController];
    }

}

/**
 *  接收消息到消息后执行。
 *  @param message 接收到的消息。
 *  @param left    剩余消息数.
 */
- (void)onKitReceivedMessage:(RCMessage *)message left:(int)left
{
    MJLog(@"");
}

#pragma mark - 开辟子线程，定时获取新消息
/**
 *  开启获取新消息线程
 */
- (void)startNoReadThread
{
    self.geNoreadCountThread = [[NSThread alloc] initWithTarget:self selector:@selector(geNOreadCountTimerThread) object:nil];
    [self.geNoreadCountThread start];
}

/**
 *  开启获取新消息定时器
 */
- (void)geNOreadCountTimerThread
{
    [self geNoreadCountBegain];
    self.geNoreadCountTimer              = [NSTimer scheduledTimerWithTimeInterval:60
                                                               target:self
                                                             selector:@selector(geNoreadCountBegain)
                                                             userInfo:nil
                                                              repeats:YES];
    MJLog(@"%@%@",self.geNoreadCountTimer,[NSThread currentThread]);
    [[NSRunLoop currentRunLoop] addTimer:self.geNoreadCountTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];

}

/**
 *  获取新消息
 */
- (void)geNoreadCountBegain
{
     NSString *userId = [MJUserDefault objectForKey:userDefaultUserId];
    if (userId)
    {
        [self requestMessageWithUserId:userId];
    }
}

/**
 *  获取用户信息
 *
 *  @param userId
 */
- (void)requestMessageWithUserId:(NSString *)userId
{
    //从后台服务器获取用户信息
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params             = [[NSMutableDictionary alloc]init];
    [params setObject:@"GetUserInfo" forKey:@"M"];
    [params setObject:userId forKey:@"Userid"];
    [manager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic                   = responseObject;
        MJLog(@"responseObject%@",dic);
        NSString *statuCode                 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"IsSuccess"]];
        if ([statuCode isEqualToString:@"1"]) {
            NSDictionary *personInfor;
            if ([[dic objectForKey:@"Result"] count]>0) {
                NSDictionary *resultDic                    = [dic objectForKey:@"Result"][0];
                NSInteger notReadCount                 = [[resultDic objectForKey:@"NotReadCount"] integerValue];
                if (notReadCount > 0)
                {
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    [userInfo setObject:[NSString stringWithFormat:@"%d",notReadCount] forKey:notificationNoreadCountKey];
                    [MJNotifCenter postNotificationName:notificationGetNoreadCount object:nil userInfo:userInfo];
                }
        
            }else{
                
                personInfor                 = [dic objectForKey:@"Result"];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
    
}



/**
 *  停止获取新消息线程
 */
- (void)stopNoReadThread
{
    [self performSelector:@selector(geNoreadCountStop) onThread:self.geNoreadCountThread withObject:nil waitUntilDone:NO];
}

/**
 *  停止获取新消息定时器
 */
- (void)geNoreadCountStop
{
    [self.geNoreadCountTimer invalidate];
    [[self.upFootRequestManager operationQueue] cancelAllOperations];
    self.geNoreadCountTimer                  =   nil;
    self.geNoreadCountThread  =   nil;
    [NSThread exit];
}

#pragma mark - 发送日志
/**
 *  上传日志
 *
 *  @param str 日志信息
 */
- (void)sendLogToServiceWithMessage:(NSString *)str withType:(NSString *)typeStr  errorStr:(NSString *) errorStr
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *threadStr =[NSString stringWithFormat:@"%@",[NSThread currentThread]];
    NSString *phoneNumStr = [MJUserDefault objectForKey:userDefaultPhoneNum];
    
    [params setObject:@"AddLogDetails"              forKey:requestKey];
    [params setObject:threadStr                     forKey:@"Thread"];
    [params setObject:@(1)                          forKey:@"Level"];
    [params setObject:str                           forKey:@"Message"];
    [params setObject:[NSString platformString]     forKey:@"PhoneModel"];
    MJLog(@"%@",[NSString platformString]);
    [params setObject:@""                           forKey:@"Logger"];
    [params setObject:typeStr                       forKey:@"LogType"];
    [params setObject:phoneNumStr                   forKey:@"PhoneNum"];
    [params setObject:@""                           forKey:@"Remark"];
    [params setObject:@"ios"                        forKey:@"Platform"];
    [params setObject:errorStr                      forKey:@"Exception"];
    [params setObject:[requestSecuKey md5String]    forKey:requestKeySign];
    
    [manager POST:[SERVERADDRESS stringByAppendingString:@"V2/LogDetailsHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        MJLog(@"连接服务器成功%@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"连接服务器失败");
    }];
}

#pragma mark - 崩溃捕获，程序崩溃捕获回调
/**
 *  程序崩溃捕获回调
 *
 *  @param exception
 */
void UncaughtExceptionHandler(NSException *exception)
{
    NSArray *arr        = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason    = [exception reason];//非常重要，就是崩溃的原因
    NSString *name      = [exception name];//异常类型
    
    MJLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat  = MJDateFormat;
    NSString *message   = [NSString stringWithFormat:@"ios得到当前调用栈信息%@，就是崩溃的原因%@，异常类型%@，记录时间：%@",arr,reason,name,[formate stringFromDate:[NSDate date]]];
     AppDelegate *appD  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appD sendLogToServiceWithMessage:message withType:[NSString stringWithFormat:@"1"] errorStr:[NSString stringWithFormat:@"%@",exception]];
}

#pragma mark - 通知释放

/**
 *  通知释放
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RCKitDispatchMessageNotification object:nil];
//    [MJNotifCenter removeObserver:self  name:notificationGetNoreadCount object:nil];
}

@end
