//
//  MJMyConViewController.m
//  Encounter
//
//  Created by 李明军 on 5/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//




#import "MJMyConViewController.h"
//#import "KxMenu.h"
//#import "RCDAddressBookViewController.h"
//#import "RCDSearchFriendViewController.h"
//#import "RCDSelectPersonViewController.h"
//#import "RCDRCIMDataSource.h"
#import "RCDChatViewController.h"
//#import "UIColor+RCColor.h"
#import "RCDChatListCell.h"
//#import "RCDAddFriendTableViewController.h"
#import "RCDHttpTool.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDUserInfo.h"
#import <RongIMKit/RCConversationModel.h>
#import "MJConst.h"
#import "AppDelegate.h"
#import "MJCustomNavView.h"
#import "MJHotSpotViewController.h"
#import "MJGuanZhuTableViewController.h"


@interface MJMyConViewController ()<RCIMUserInfoFetcherDelegagte,MJCustomNavViewDelegate,UIAlertViewDelegate>

//@property (nonatomic,strong) NSMutableArray *myDataSource;
@property (nonatomic,strong) RCConversationModel *tempModel;
/** 导航条 */
@property (nonatomic,strong) MJCustomNavView *customNav;
/** 删除num */
@property (nonatomic,strong) NSIndexPath *deleteNum;

- (void) updateBadgeValueForTabBarItem;

@end

@implementation MJMyConViewController

#pragma mark - 懒加载自定义数据模型

/**
 *  会话模型懒加载
 *
 *  @return 会话模型
 */
- (RCConversationModel *)tempModel
{
    if (!_tempModel) {
        _tempModel = [[RCConversationModel alloc]init];
    }
    return _tempModel;
}

#pragma mark - 融云自定义必须实现storyboard初始化

/**
 *  此处使用storyboard初始化，代码初始化当前类时*****必须要设置会话类型和聚合类型*****
 *
 *  @param aDecoder aDecoder description
 *
 *  @return return value description
 */
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super initWithCoder:aDecoder];
    if (self) {
        
/**===========================================融云必设=======================================*/
        //  1. 设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_PUBLICSERVICE),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_SYSTEM)]];
        
        //  2. 聚合会话类型
        [self setCollectionConversationType:@[@(ConversationType_GROUP),
                                              @(ConversationType_DISCUSSION)]];
        [self setConversationAvatarStyle:RCUserAvatarCycle];
        // _myDataSource = [NSMutableArray new];
        
        // [self setConversationAvatarStyle:RCUserAvatarCycle];
/**===========================================融云结束=======================================*/
        
        //  3. 设置导航条选中图片，storyboard设置不生效，原因不明
//        self.tabBarItem.image = [[UIImage imageNamed:@"icon_chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"bottom_im_s"]];
    }
    return self;
}

#pragma mark - view加载时数据设置
/**
 *  view加载时显示
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout                         = UIRectEdgeNone;
    
    //设置tableView样式
    self.conversationListTableView.separatorColor       = [UIColor grayColor];
    self.conversationListTableView.tableFooterView      = [UIView new];
    //  1. 融云设置用户信息代理
    [[RCIM sharedKit] setUserInfoFetcherWithDelegate:self];
    
    [MJNotifCenter addObserver:self
                      selector:@selector(noreadCountNotification:)
                          name:notificationGetNoreadCount
                        object:nil];
    
}

#pragma mark - 新消息通知

/**
 *  新消息通知
 *
 *  @param notification
 */
- (void)noreadCountNotification:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSInteger notreadCount = [[dic objectForKey:notificationNoreadCountKey] integerValue];
    if (notreadCount > 0)
    {
        AppDelegate *appd               = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tabbarConTr = (UITabBarController *)[[appd window] rootViewController];
        UITabBarItem *item              = [[[tabbarConTr tabBar] items] objectAtIndex:2];
        [item setBadgeValue:[[NSString alloc]initWithFormat:@"%d",notreadCount]];
    }
}


/**
 *  view将要出现时数据设置
 *
 *  @param animated
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestCurrentHot];
    
    
    [self.tabBarController.tabBar setHidden:NO];
    /*---------------------------------------------------------------------------*/
    
    //  2.
    self.customNav                          = [[MJCustomNavView alloc]init];
    self.customNav.delegate                 = self;
    [self.navigationController.navigationBar addSubview:self.customNav];
    [self.navigationItem setTitle:@""];
    
//    //自定义rightBarButtonItem
//    UIButton *rightBtn                                  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
//    [rightBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightButton                        = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    [rightBtn setTintColor:[UIColor whiteColor]];
//    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    //  更新角标红点数字
    [self updateBadgeValueForTabBarItem];
    
}

/**
 *  view出现时
 *
 *  @param animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    NSInteger third = [[MJUserDefault objectForKey:@"thirdSignView"] integerValue];
    //  根据缓存，设置分段控件红点是否显示
    if ( third == 1)
    {
        self.customNav.thirdSignView.hidden = NO;
    }
    
    if ([[MJUserDefault objectForKey:@"forthSignView"] integerValue] == 1)
    {
        self.customNav.forthSignView.hidden = NO;
    }

}

/**
 *  view将要消失时
 *
 *  @param animated
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customNav removeFromSuperview];
    [self.navigationItem setTitle:@"返回"];
   
}

#pragma mark - 请求足迹
/**
 *  请求热点
 */
- (void)requestCurrentHot
{
    AppDelegate *deleD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [deleD requestCurrentHotWithBlock:^{
        NSDictionary *spotDic                   = [MJUserDefault objectForKey:userDefaultCurrentSpot];
        self.tempModel.conversationModelType    = ConversationModelType_UserCustom;
        self.tempModel.isTop                    = YES;
        self.tempModel.extend                   = spotDic;
        [self refreshConversationTableViewIfNeeded];
    }];
}


#pragma mark - 融云更新消息角标
/**
 *  融云。。。。。新消息数量
 */
- (void)updateBadgeValueForTabBarItem
{
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedClient]getUnreadCount:self.displayConversationTypeArray];
        if (count>0) {
            AppDelegate *appd               = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UITabBarController *tabbarConTr = (UITabBarController *)[[appd window] rootViewController];
            UITabBarItem *item              = [[[tabbarConTr tabBar] items] objectAtIndex:0];
            [item setBadgeValue:[[NSString alloc]initWithFormat:@"%d",count]];
//            __weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
            //  当搜到新消息数量时，发出通知
            __weakSelf.customNav.firstSignView.hidden = NO;
            if ([[MJUserDefault objectForKey:@"musicCount"] integerValue] != count) {
                MJSystemSound *so = [[MJSystemSound alloc] initSystemSoundWithName:@"sms-received1" SoundType:@"caf"];
                [so play];
            }
            [MJUserDefault setObject:@"1" forKey:@"firstSignView"];
            [MJUserDefault setObject:@(count) forKey:@"musicCount"];
            [MJUserDefault synchronize];

        }else
        {
            __weakSelf.tabBarItem.badgeValue = nil;
            [MJUserDefault setObject:@"0" forKey:@"firstSignView"];
            [MJUserDefault synchronize];
            AppDelegate *appd               = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UITabBarController *tabbarConTr = (UITabBarController *)[[appd window] rootViewController];
            UITabBarItem *item              = [[[tabbarConTr tabBar] items] objectAtIndex:0];
            [item setBadgeValue:nil];

            __weakSelf.customNav.firstSignView.hidden = YES;
        }
        
    });
}


#pragma mark - 自定义界面，融云需要重写的方法

#pragma mark 1. 点击进入会话界面
/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    self.customNav.hidden = YES;
//    if (indexPath.row == 0) {
//        MJLog(@"自定义");
//    }
//    else
//    {
        if (conversationModelType == ConversationModelType_Normal)
        {
            RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
            _conversationVC.conversationType = model.conversationType;
            _conversationVC.targetId = model.targetId;
            _conversationVC.targetName = model.conversationTitle;
            _conversationVC.name = model.conversationTitle;
           
            _conversationVC.conversation = model;
            MJLog(@"%@",model.conversationTitle);
            [self.navigationController pushViewController:_conversationVC animated:YES];
        }
    
        //聚合会话类型，此处自定设置。
        if (conversationModelType == ConversationModelType_Collection) {
        
//            RCDChatListViewController *temp = [[RCDChatListViewController alloc] init];
//            NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
//            [temp setDisplayConversationTypes:array];
//            [temp setCollectionConversationType:nil];
//            temp.isEnteredToCollectionViewController = YES;
//            [self.navigationController pushViewController:temp animated:YES];
        }
    
        //自定义会话类型
        if (conversationModelType == ConversationModelType_UserCustom)
        {
            MJHotSpotViewController *hotSpotViewC = [[MJHotSpotViewController alloc]init];
            NSDictionary *dic       = model.extend;
            NSString *str           = [dic objectForKey:userDefaultCurrentSpotPlaceNameStr];
            double  lat             = [[dic objectForKey:userDefaultCurrentSpotLatStr] doubleValue];
            double  lon             = [[dic objectForKey:userDefaultCurrentSpotLonStr] doubleValue];
//            NSString *hotid          = [dic objectForKey:userDefaultCurrentSpotHotspotIdStr];
            NSInteger hotid          = [[dic objectForKey:userDefaultCurrentSpotHotspotIdStr] integerValue];
            MJLog(@"hotid%d",(int)hotid);
            
            hotSpotViewC.hotId      = hotid;
            hotSpotViewC.lat        = lat;
            hotSpotViewC.lon        = lon;
            hotSpotViewC.navTitle   = str;
            
            [self.navigationController pushViewController:hotSpotViewC animated:YES];
        }
//    }
}

#pragma mark 2. 插入自定义会话model
/**
 *  插入自定义会话model
 *
 *  @param dataSource 数据源
 *
 *  @return 数据源
 */
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    [dataSource insertObject:self.tempModel atIndex:0];
    return dataSource;
}

#pragma mark 3. 左滑删除-本来是准备弹框，但是貌似不起作用
/**
 *  左滑删除-本来是准备弹框，但是貌似不起作用
 *
 *  @param tableView    融云会话tableview
 *  @param editingStyle 编辑峰哥
 *  @param indexPath    row
 */
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJLog(@"%d",indexPath.row);
    //RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    //[_myDataSource removeObject:model];
    if (indexPath.row != 0)
    {
        self.deleteNum = indexPath;
        [[[UIAlertView alloc] initWithTitle:@"警告" message:@"是否删除该条会话记录" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil] show];
    }
}

#pragma mark 4. 设置删除中文显示
/**
 *  设置删除中文显示
 *
 *  @param tableView 融云会话tableview
 *  @param indexPath row
 *
 *  @return 删除显示文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


////高度
//-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 67.0f;
//}

#pragma mark 5. 自定义cell
/**
 *  自定义cell
 *
 *  @param tableView 融云会话tableview
 *  @param indexPath row
 *
 *  @return 自定义cell
 */
-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
//    if ([model.senderUserId isEqualToString:@""]) {
//        [cell.lblName setTextColor:[UIColor redColor]];
//    }
    
    if (indexPath.row == 0) {
        NSDictionary *dic       = model.extend;
        //  取出所插入自定义模型[dic objectForKey:@"userDefaultCurrentSpotContentStr"]
        cell.lblName.text       = [dic objectForKey:userDefaultCurrentSpotPlaceNameStr];
        cell.lblDetail.attributedText     = [NSString attributedTextWithText:[dic objectForKey:@"userDefaultCurrentSpotContentStr"]];
        
        //  格式化日期
        NSString *str           = [dic objectForKey:userDefaultCurrentSpotCreatTimeStr];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat       = MJDateFormatTwo;
        NSString *dateStr       = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSString *dds           = [dateStr substringToIndex:19];
        NSDate *dat             =   [format dateFromString:dds];
        format.dateFormat       = MJDateFormat;
        NSString *ddd = [format stringFromDate:dat];
        cell.timeLabel.text     = ddd;
        MJLog(@"%@",dat);
        MJLog(@"lblName%@",cell.lblName.text);
        MJLog(@"lblDetail%@",cell.lblDetail.text);
        MJLog(@"userName%@",cell.userName);
        //  设置头像
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:userDefaultCurrentSpotImageStr]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.ivAva setImage:[UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1]];
            [cell.ivAva setBackgroundColor:[UIColor whiteColor]];
        }];
        MJLog(@"ivAva%@",[dic objectForKey:userDefaultCurrentSpotImageStr]);
    }
    else
    {
    __block NSString *userName    = nil;
    __block NSString *portraitUri = nil;
    
    
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
        NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]objectForKey:_contactNotificationMsg.sourceUserId];
        if (_cache_userinfo) {
            userName = _cache_userinfo[@"username"];
            portraitUri = _cache_userinfo[@"portraitUri"];
        }
        
    }else{
        RCDUserInfo *user = (RCDUserInfo *)model.extend;
        userName    = user.userName;
        portraitUri = user.portraitUri;
    }
    
    
    
    cell.lblDetail.text =[NSString stringWithFormat:@"来自%@的好友请求",userName];
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
    }
    
    
    
    return cell;
}

//*********************插入自定义Cell*********************//


#pragma mark - 收到消息监听
/**
 *  融云收到消息监听
 *
 *  @param notification 消息
 */
-(void)didReceiveMessageNotification:(NSNotification *)notification
{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        RCContactNotificationMessage *contactNotificationMsg = (RCContactNotificationMessage *)message.content;
        
        //该接口需要替换为从消息体获取好友请求的用户信息
        [RCDHTTPTOOL getUserInfoByUserID:contactNotificationMsg.sourceUserId
                              completion:^(RCUserInfo *user) {
                                  RCDUserInfo *rcduserinfo_         = [RCDUserInfo new];
                                  rcduserinfo_.userName             = user.name;
                                  rcduserinfo_.userId               = user.userId;
                                  rcduserinfo_.portraitUri          = user.portraitUri;
                                  
                                  
                                  
                                  RCConversationModel *customModel  = [RCConversationModel new];
                                  customModel.conversationModelType = ConversationModelType_UserCustom;
                                  customModel.extend                = rcduserinfo_;
                                  customModel.senderUserId          = message.senderUserId;
                                  customModel.lastestMessage        = contactNotificationMsg;
                                  //[_myDataSource insertObject:customModel atIndex:0];
                                  
                                  //local cache for userInfo
                                  NSDictionary *userinfoDic = @{@"username": rcduserinfo_.userName,
                                                                @"portraitUri":rcduserinfo_.portraitUri
                                                                };
                                  MJLog(@"%@",userinfoDic);
                                  [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:contactNotificationMsg.sourceUserId];
                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      //调用父类刷新未读消息数
                                      [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
                                      //[super didReceiveMessageNotification:notification];
                                      [blockSelf_ resetConversationListBackgroundViewIfNeeded];
                                      [blockSelf_ updateBadgeValueForTabBarItem];
                                  });
                              }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [blockSelf_ updateBadgeValueForTabBarItem];
        });
    }
}

/**
 *  融云信息获取代理，可以设置头像和昵称
 *
 *  @param userId
 *  @param completion 
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    RCUserInfo *currentUser=[RCIMClient sharedClient].currentUserInfo;
    if ([userId isEqualToString:currentUser.userId]) {
        completion(currentUser);
    }else{
        [[RCIMClient sharedClient] getUserInfo:userId completion:^(RCUserInfo *cacheuser){
            if (cacheuser) {
                completion(cacheuser);
            }else{
                //  从后台服务器获取用户信息
                AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
                NSMutableDictionary *params             = [[NSMutableDictionary alloc]init];
                [params setObject:@"GetUserInfo" forKey:@"M"];
                [params setObject:userId forKey:@"Userid"];
                [manager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dic                   = responseObject;
                    NSString *statuCode                 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"IsSuccess"]];
                    if ([statuCode isEqualToString:@"1"])
                    {
                        RCUserInfo *user                = nil;
                        NSDictionary *personInfor;
                        if ([[dic objectForKey:@"Result"] count]>0)
                        {
                            //  将获取的头像和昵称加入融云数据
                            personInfor                 = [dic objectForKey:@"Result"][0];
                            user.name                   = [personInfor objectForKey:@"Nickname"];
                            user.portraitUri            = [personInfor objectForKey:@"Headimg"];
                        }else{
                            
                            personInfor                 = [dic objectForKey:@"Result"];
                        }
                        completion(user);
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        }error:nil];
    }
    

}

#pragma mark - 自定义导航title代理方法
/**
 *  自定义导航titleview代理方法
 *
 *  @param customView     自定义的view
 *  @param segmentControl 分段控件
 */
- (void)customNavView:(MJCustomNavView *)customView segmentControlSelected:(NSInteger)segmentControlSelected
{
    MJGuanZhuTableViewController *guanzhuTVC = [[MJGuanZhuTableViewController alloc]init];
    guanzhuTVC.selectedIndex = segmentControlSelected;
    [self.navigationController pushViewController:guanzhuTVC animated:YES];
}


#pragma mark - 弹窗代理
/**
 *  删除弹窗代理-不起作用
 *
 *  @param alertView
 *  @param buttonIndex 
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            break;
        }
        case 1:
        {
            [self.conversationListDataSource removeObjectAtIndex:self.deleteNum.row];
            
            [self.conversationListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.deleteNum] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

- (void)dealloc
{
    [MJNotifCenter removeObserver:self];
}

@end
