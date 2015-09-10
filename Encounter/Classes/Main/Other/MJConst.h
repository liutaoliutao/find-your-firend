#import <Foundation/Foundation.h>

/** 导入头文件 */
/** 自定义predicate分类 */
#import "NSPredicate+MJExtension.h"
/** 图片裁剪 */
#import "UIImage+CZ.h"
/** 字符串分类返回当前手机版本字符串 */
#import "NSString+MJExtension.h"
/** 网络请求 */
#import "AFNetworking.h"
/** 网络请求提示框 */
#import "MMProgressHUD.h"
/** 加密文件 */
#import "NSString+Hash.h"
/** 设置图片 */
#import "UIImageView+WebCache.h"
/** 缓存文件 */
#import "LSFileCacheHelper.h"
/** post请求上传文件数据体拼接 */
//#import "NSData+MJExtension.h"
/** 上传图片 */
#import "ASIFormDataRequest.h"
/** 数据体拼接 */
#import "NSMutableURLRequest+MJPostDataAppend.h"
/** json框架 */
#import "JSONKit.h"
/** 设置frame分类 */
#import "UIView+Extension.h"
/** 图文混排 */
#import "FaceBoard.h"
/** 刷新文件 */
#import "MJRefresh.h"
/** 图文混排截取 */
#import "RegexKitLite.h"
/** 钥匙串保存密码 */
#import "SFHFKeychainUtils.h"

#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
/** 系统声音提醒 */
#import "MJSystemSound.h"
/** 裁剪图片 */
#import "UIImageView+Extension.h"

#ifdef DEBUG
#define MJLog(...) NSLog(__VA_ARGS__)
#else
#define MJLog(...)
#endif

/** 外网网址 */
#define SERVERADDRESS           @"http://m.yibaiwu.com/"

/** 内网汪洋服务器地址 */
//#define SERVERADDRESS     @"http://192.168.3.116:8082/"
/** 内网张茹林地址 */
//#define SERVERADDRESS    @"http://192.168.3.177:8082/"
/** 2.0足迹外网地址 */
//#define outServerFootAddress    @"http://m.yibaiwu.com/V2/"
/** RGB颜色设置 */
#define MJColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
/** 系统导航条颜色 */
#define systemColor MJColor(0.0,122.0,255.0)
/** 用户偏好 */
#define MJUserDefault [NSUserDefaults standardUserDefaults]
/** 通知中心 */
#define MJNotifCenter [NSNotificationCenter defaultCenter]
/** 主窗口 */
#define systemWindow [[UIApplication sharedApplication].delegate window]
/** 主窗口size */
#define systemSize [UIScreen mainScreen].bounds.size
/** post上传bondary */
#define bondary                     @"23154645687145123123145645"

//  登录成功状态返回结果字典key
/** 返回结果头像url key */
#define resultKeyHeadImgUrl         @"headImageUrl"
/** 是否是第一次请求，决定是否需要填写详情页 */
#define resultKeyIsFirst            @"isFirst"
/** 性别 */
#define resultKeySex                @"sex"
/** 用户userId */
#define resultKeyUserId             @"userId"
/** 从服务器获得的融云token */
#define rongYunToKen                @"RCToken"
/** 融云userId */
#define rongYunUserId               @"rongYunUserId"
/** 用户userName */
#define resultKeyUserName           @"userName"
/** 请求密匙 */
#define requestSecuKey              @"!@#YuanFeiWang2015SysTem%^*"

/** 定位通知名称 */
#define notificationLocationName    @"notificationLocationName"
/** 定位通知lat key */
#define notificationUserInfoKeyLat  @"notificationUserInfoKeyLat"
/** 定位通知lon key */
#define notificationUserInfoKeyLon  @"notificationUserInfoKeyLon"
/** 定位通知lon key */
#define notificationUserInfoKeyDis  @"notificationUserInfoKeyDis"

/** 获取新消息通知 */
#define notificationGetNoreadCount  @"notificationGetNoreadCount"
/** 我的新消息数量key */
#define notificationNoreadCountKey  @"notificationNoreadCountKey"

/** 融云新消息通知 */
#define notificationRongYunName     @"notificationRongYunName"
/** 新消息数量key */
#define notificationNewMessCountKey @"notificationNewMessCountKey"


/** 网络连接错误消息 */
#define connectionErrorMessage      @"网络连接错误，请稍后再试"
/** 手机是否开放定位权限 */
#define isOpenLocation              @"isOpenLocation"

//  个人资料请求结果字典
/** 头像url */
#define personInfoResultDicHeadimg  @"Headimg"
/** 性别 */
#define personInfoResultDicSex      @"Sex"
/** 昵称 */
#define personInfoResultDicNickname @"Nickname"
/** 描述 */
#define personInfoResultDicMotto    @"Motto"
/** 背景 */
#define personInfoResultDicBackImg  @"BackImg"

//  网络延迟
extern NSString *const errorMessage;

//  设置全局日期格式
extern NSString *const MJDateFormat;
//  设置全局日期格式
extern NSString *const MJDateFormatTwo;
//  设置全局日期格式
extern NSString *const MJDateFormatThree;


/**------------------------------------------------------------------------*/
/**------------------------------------------------------------------------*/

//  MJLogin.storyboard跳转segue的identifier
/** 1.1 从手机验证页跳转到新用户注册密码页 */
extern NSString *const MJSegueToRigesterIdentifier;
/** 1.2 手机验证页跳转到密码重设页 */
extern NSString *const MJSegueToResetPwdIdentifier;
/** 1.3 登录页跳转到资料详情页 */
extern NSString *const MJSegueToUserInfoSetIdentifier;

/**------------------------------------------------------------------------*/
/**------------------------------------------------------------------------*/

//  MJUserInfoTableViewController控制器中用户相册及相机权限显示消息
/** 2.1 用户尚未做出了选择这个应用程序的问候 */
extern NSString *const MJPhotoLibNotDetermined;
/** 2.2 此应用程序没有被授权访问的照片数据。可能是家长控制权限 */
extern NSString *const MJPhotoLibRestricted;
/** 2.3 用户已经明确否认了这一照片数据的应用程序访问 */
extern NSString *const MJPhotoLibStatusDenied;

/** 3.1 用户尚未做出了选择这个应用程序的问候 */
extern NSString *const MJCameraNotDetermined;
/** 3.2 此应用程序没有被授权访问的相机。可能是家长控制权限 */
extern NSString *const MJCameraRestricted;
/** 3.3 用户已经明确否认了这一相机的应用程序访问 */
extern NSString *const MJCameraStatusDenied;

/** 4.0 用户初遇热点 */
extern NSString *const MJMyRecentMeetHotSpot;

/**------------------------------------------------------------------------*/
/**------------------------------------------------------------------------*/

//  用户偏好设置key值

/** 缓存电话号码 */
extern NSString *const userDefaultPhoneNum;

/** 情感状态 */
extern NSString *const userDefaultLoveSelectedStr;
/** 生日 */
extern NSString *const userDefaultbirthdaySelectedStr;
/** 融云token */
extern NSString *const userDefaultDeviceToken;

/** 登录模块头像url缓存 */
extern NSString *const userDefaultHeadImgUrlStr;
/** 性别 */
extern NSString *const userDefaultSex;
/** userId */
extern NSString *const userDefaultUserId;
/** userName */
extern NSString *const userDefaultUserName;
/** userPwd */
extern NSString *const userDefaultUserPwd;

/** 定位开关是否开启 */
extern NSString *const userDefaultIsOnLocation;
/** 程序启动时，定位状态 */
extern NSString *const userDefaultAppStartIsOnLocation;
/** 程序是否登录 */
extern NSString *const userDefaultAppStartIsLogin;

/** 缓存用户当前坐标lat */
extern NSString *const userDefaultCurrentLocationLat;
/** 缓存用户当前坐标long */
extern NSString *const userDefaultCurrentLocationLon;
/** 缓存用户当前坐标Str */
extern NSString *const userDefaultCurrentLocationStr;

/** 缓存用户热点字典 */
extern NSString *const userDefaultCurrentSpot;
/** 缓存字典用户当前热点时间 */
extern NSString *const userDefaultCurrentSpotCreatTimeStr;
/** 缓存字典用户当前热点HotspotId */
extern NSString *const userDefaultCurrentSpotHotspotIdStr;
/** 缓存字典用户当前热点HotspotType */
extern NSString *const userDefaultCurrentSpotHotspotTypeStr;
/** 缓存字典用户当前热点Image */
extern NSString *const userDefaultCurrentSpotImageStr;
/** 缓存字典用户当前热点PlaceName */
extern NSString *const userDefaultCurrentSpotPlaceNameStr;
/** 缓存字典用户当前热点时间 */
extern NSString *const userDefaultCurrentSpotTitleStr;
/** 缓存字典用户当前热点lat*/
extern NSString *const userDefaultCurrentSpotLatStr;
/** 缓存字典用户当前热点lon */
extern NSString *const userDefaultCurrentSpotLonStr;

/** 缓存用户最近的一百条足迹数组 */
extern NSString *const userDefaultLatestFootPrint;
/** 缓存用户最近的一百条足迹数组中存放字典lat */
extern NSString *const userDefaultLatestFootPrintDicLat;
/** 缓存用户最近的一百条足迹数组中存放字典lon */
extern NSString *const userDefaultLatestFootPrintDicLon;
/** 缓存用户最近的一百条足迹数组中存放字典time */
extern NSString *const userDefaultLatestFootPrintDicTime;
/** 缓存用户最近的一百条足迹数组中存放字典Address */
extern NSString *const userDefaultLatestFootPrintDicAddress;



/**------------------------------------------------------------------------*/
/**------------------------------------------------------------------------*/

//  1.0 外网url
/** 登录1.0外网url */
extern NSString *const loginOneOutServiceUrl;

/**------------------------------------------------------------------------*/
/**------------------------------------------------------------------------*/

//  请求params关键字
/** 标示关键字 */
extern NSString *const requestKey;
/** 标示关键字Sign */
extern NSString *const requestKeySign;
/** 用户名 */
extern NSString *const requestKeyUserPhoneNumber;
/** 用户密码 */
extern NSString *const requestKeyUserPassword;

//  定位
/** 定位请求lat */
extern NSString *const requestKeyLocationLat;
/** 定位请求long */
extern NSString *const requestKeyLocationLong;
/** 定位请求Place */
extern NSString *const requestKeyLocationPlace;

//  完善资料
/** 性别 */
extern NSString *const requestKeyUserSex;
/** NickName */
extern NSString *const requestKeyUserNickName;
/** Brithday */
extern NSString *const requestKeyUserBrithday;
/** HeadImg */
extern NSString *const requestKeyUserHeadImg;

/**------------------------------------------------------------------------*/
/**------------------------------------------------------------------------*/

//  服务器响应关键字
/** 是否成功 */
extern NSString *const responseKeyIsSuccess;
/** 响应信息 */
extern NSString *const responseKeyMessage;
/** 响应结果（字典） */
extern NSString *const responseKeyResult;
