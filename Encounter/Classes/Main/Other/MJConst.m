#import "MJConst.h"

//  网络延迟
NSString *const errorMessage                                = @"网络连接失败";

//  设置全局日期格式
NSString *const MJDateFormat                                = @"yyyy-MM-dd";
//  设置全局日期格式
NSString *const MJDateFormatTwo                             = @"yyyy-MM-dd HH:mm:ss";
//  设置全局日期格式
NSString *const MJDateFormatThree                           = @"HH:mm:ss";

// MJLogin.storyboard跳转segue的identifier
/** 1.1 从手机验证页跳转到新用户注册密码页                    */
NSString *const MJSegueToRigesterIdentifier                 = @"segueToRigester";
/** 1.2 手机验证页跳转到密码重设页                           */
NSString *const MJSegueToResetPwdIdentifier                 = @"segueToResetPwd";
/** 1.3 新用户注册密码页跳转到新用户注册资料详情页              */
NSString *const MJSegueToUserInfoSetIdentifier              = @"segueToUserInfoSet";

//  MJUserInfoTableViewController控制器中用户相册及相机权限显示消息
/** 2.1 用户尚未做出了选择这个应用程序的问候 */
NSString *const MJPhotoLibNotDetermined                     = @"你还未授权打开相册，请授权";
/** 2.2 此应用程序没有被授权访问的照片数据。可能是家长控制权限    */
NSString *const MJPhotoLibRestricted                        = @"你未授权此应用访问照片数据";
/** 2.3 用户已经明确否认了这一照片数据的应用程序访问             */
NSString *const MJPhotoLibStatusDenied                      = @"你已经明确禁止了访问相册，请在手机设置中授权";

/** 3.1 用户尚未做出了选择这个应用程序的问候                    */
NSString *const MJCameraNotDetermined                       = @"你还未授权打开相机，请授权,若关闭授权，将无法使用相册功能，请谨慎选择";
/** 3.2 此应用程序没有被授权访问的相机。可能是家长控制权限        */
NSString *const MJCameraRestricted                          = @"你未授权此应用访问相机";
/** 3.3 用户已经明确否认了这一相机的应用程序访问                */
NSString *const MJCameraStatusDenied                        = @"你已经明确禁止了访问相机，请在手机设置中授权";

/** 4.0 用户初遇热点                                        */
NSString *const MJMyRecentMeetHotSpot                       = @"最近初遇热点：";


//  用户偏好设置key值

/** 缓存电话号码 */
NSString *const userDefaultPhoneNum                         = @"userDefaultPhoneNum";

/** 情感状态                                                */
NSString *const userDefaultLoveSelectedStr                  = @"userDefaultLoveSelectedStr";
/** 生日                                                    */
NSString *const userDefaultbirthdaySelectedStr              = @"userDefaultbirthdaySelectedStr";
/** 融云token                                               */
NSString *const userDefaultDeviceToken                      = @"userDefaultDeviceToken";

/** 登录模块头像url缓存 */
NSString *const userDefaultHeadImgUrlStr                    = @"userDefaultHeadImgUrlStr";
/** 性别 */
NSString *const userDefaultSex                              = @"userDefaultSex";
/** userId */
NSString *const userDefaultUserId                           = @"userDefaultUserId";
/** userName */
NSString *const userDefaultUserName                         = @"userDefaultUserName";
/** userPwd */
NSString *const userDefaultUserPwd                          = @"userDefaultUserPwd";
/** 定位开关是否开启 */
NSString *const userDefaultIsOnLocation                     = @"userDefaultIsOnLocation";
/** 程序启动时，定位状态 */
NSString *const userDefaultAppStartIsOnLocation             = @"userDefaultAppStartIsOnLocation";
/** 程序是否登录 */
NSString *const userDefaultAppStartIsLogin                  = @"userDefaultAppStartIsLogin";

/** 缓存用户当前坐标lat */
NSString *const userDefaultCurrentLocationLat               = @"userDefaultCurrentLocationLat";
/** 缓存用户当前坐标long */
NSString *const userDefaultCurrentLocationLon               = @"userDefaultCurrentLocationLon";
/** 缓存用户当前坐标Str */
NSString *const userDefaultCurrentLocationStr               = @"userDefaultCurrentLocationStrxxx";

/** 缓存用户热点字典 */
NSString *const userDefaultCurrentSpot                      = @"userDefaultCurrentSpot";
/** 缓存字典用户当前热点时间 */
NSString *const userDefaultCurrentSpotCreatTimeStr          = @"userDefaultCurrentSpotCreatTimeStr";
/** 缓存字典用户当前热点HotspotId */
NSString *const userDefaultCurrentSpotHotspotIdStr          = @"userDefaultCurrentSpotHotspotIdStr";
/** 缓存字典用户当前热点HotspotType */
NSString *const userDefaultCurrentSpotHotspotTypeStr        = @"userDefaultCurrentSpotHotspotTypeStr";
/** 缓存字典用户当前热点Image */
NSString *const userDefaultCurrentSpotImageStr              = @"userDefaultCurrentSpotImageStr";
/** 缓存字典用户当前热点PlaceName */
NSString *const userDefaultCurrentSpotPlaceNameStr          = @"userDefaultCurrentSpotPlaceNameStr";
/** 缓存字典用户当前热点时间 */
NSString *const userDefaultCurrentSpotTitleStr              = @"userDefaultCurrentSpotTitleStr";
/** 缓存字典用户当前热点lat*/
NSString *const userDefaultCurrentSpotLatStr                = @"userDefaultCurrentSpotLatStr";
/** 缓存字典用户当前热点lon */
NSString *const userDefaultCurrentSpotLonStr                = @"userDefaultCurrentSpotLonStr";


/** 缓存用户最近的一百条足迹数组 */
NSString *const userDefaultLatestFootPrint                  = @"userDefaultLatestFootPrint";
/** 缓存用户最近的一百条足迹数组中存放字典lat */
NSString *const userDefaultLatestFootPrintDicLat            = @"userDefaultLatestFootPrintDicLat";
/** 缓存用户最近的一百条足迹数组中存放字典lon */
NSString *const userDefaultLatestFootPrintDicLon            = @"userDefaultLatestFootPrintDicLon";
/** 缓存用户最近的一百条足迹数组中存放字典time */
NSString *const userDefaultLatestFootPrintDicTime           = @"userDefaultLatestFootPrintDicTime";
/** 缓存用户最近的一百条足迹数组中存放字典Address */
NSString *const userDefaultLatestFootPrintDicAddress        = @"userDefaultLatestFootPrintDicAddress";


//  1.0 外网url
/** 外网url */
NSString *const loginOneOutServiceUrl                       = @"http://m.yibaiwu.com/Handler/ManagerUser.ashx";

//  请求key
/** 标示关键字 */
NSString *const requestKey                                  = @"M";
/** 标示关键字Sign */
NSString *const requestKeySign                              = @"Sign";
/** 用户名 */
NSString *const requestKeyUserPhoneNumber                   = @"phoneNumber";
/** 用户密码 */
NSString *const requestKeyUserPassword                      = @"userPassword";

//  定位
/** 定位请求lat */
NSString *const requestKeyLocationLat                       = @"Lat";
/** 定位请求long */
NSString *const requestKeyLocationLong                      = @"Long";
/** 定位请求Place */
NSString *const requestKeyLocationPlace                     = @"Place";


//  完善资料
/** 性别 */
NSString *const requestKeyUserSex                           = @"Sex";
/** NickName */
NSString *const requestKeyUserNickName                      = @"NickName";
/** Brithday */
NSString *const requestKeyUserBrithday                      = @"Brithday";
/** HeadImg */
NSString *const requestKeyUserHeadImg                       = @"HeadImg";

//  服务器响应key
/** 是否成功 */
NSString *const responseKeyIsSuccess                        = @"IsSuccess";
/** 响应信息 */
NSString *const responseKeyMessage                          = @"Message";
/** 响应结果（字典） */
NSString *const responseKeyResult                           = @"Result";
