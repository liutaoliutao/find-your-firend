//
//  MJMyMessageTableViewController.m
//  Encounter
//
//  Created by 李明军 on 8/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJMyMessageTableViewController.h"
#import "MJConst.h"
#import "MJPersonCellModel.h"
#import "MJHeadTableViewCell.h"
#import "MJPersonPhotoTableViewCell.h"
#import "MJPersonLastTableViewCell.h"
#import "RCDChatViewController.h"
#import "MJBlackListCoverView.h"
#import "MJPhotoLibViewController.h"
#import "UIView+Extension.h"

@interface MJMyMessageTableViewController ()<MJHeadTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate,MJBlackListCoverViewDelegate,UIAlertViewDelegate,MJPersonPhotoTableViewCellDelegate>

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray     *dataSourceArray;
/** 相册数组 */
@property (nonatomic,strong) NSArray            *photoArray;

/** 底部view */
@property (nonatomic,strong) UIView             *bottomView;

/** tableView */
@property (nonatomic,strong) UITableView        *tableV;
/** 是否关注 */
@property (nonatomic,assign) BOOL               isFocus;
/** 是否在初遇重逢列表 */
@property (nonatomic,assign) BOOL               IsMeet;
/** 是否在初遇重逢列表 */
@property (nonatomic,assign) NSInteger          FocusStatus;
/** 昵称 */
@property (nonatomic,copy) NSString             *nickNameStr;
/** 是否关注按钮 */
@property (nonatomic,strong) UIButton           *guanzhuBtn;
/** 发消息按钮 */
@property (nonatomic,strong) UIButton           *messageBtn;
/** 消息文本框 */
@property (nonatomic,strong) UILabel           *discLabel;
/** 拉黑举报覆盖view */
@property (nonatomic,weak) UIView               *blackCoverView;
/** nodataArray */
@property (nonatomic,strong) NSMutableArray     *nodataArray;
/** 是否位点击关注标志 */
@property (nonatomic,assign) NSInteger guanzhuSign;


@end

@implementation MJMyMessageTableViewController


- (NSMutableArray *)nodataArray
{
    if (!_nodataArray) {
        _nodataArray = [NSMutableArray array];
        NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
        [headDic setObject:@""                                              forKey:personInfoResultDicHeadimg];
        [headDic setObject:@""                                              forKey:personInfoResultDicSex];
        [headDic setObject:@"网络君太慢"                                      forKey:personInfoResultDicNickname];
        [headDic setObject:@"网络太差，请刷新数据"                              forKey:personInfoResultDicMotto];
        [_nodataArray addObject:headDic];

    }
    return _nodataArray;
}

/**
 *  底部按钮懒加载
 *
 *  @return 底部按钮
 */
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, systemSize.height - 80, systemSize.width, 80)];

        //  1. 加载关注按钮
        CGFloat margin = 30;
        CGFloat width   = systemSize.width - 60;
        UIButton *guanzhuBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, width, margin)];
        [guanzhuBtn setTitle:@"关注"                                            forState:UIControlStateNormal];
        [guanzhuBtn setTitle:@"取消关注"                                         forState:UIControlStateSelected];
        [guanzhuBtn setTitleColor:systemColor                                   forState:UIControlStateNormal];
        [guanzhuBtn setTitleColor:[UIColor whiteColor]                          forState:UIControlStateSelected];
        
        [guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"fas_btn"]          forState:UIControlStateNormal];
        [guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"focus_btn"]        forState:UIControlStateSelected];
        
        [guanzhuBtn addTarget:self action:@selector(guanzhuClick:) forControlEvents:UIControlEventTouchUpInside];
        guanzhuBtn.selected = YES;
        
        [_bottomView addSubview:guanzhuBtn];
        self.guanzhuBtn = guanzhuBtn;
        
        //  2. 加载发消息按钮
        UIButton *messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 40, width, margin)];
        [messageBtn setTitle:@"发消息"                                           forState:UIControlStateNormal];
        [messageBtn setTitle:@"发消息"                                           forState:UIControlStateSelected];
        [messageBtn setTitleColor:systemColor                                   forState:UIControlStateNormal];
        [messageBtn setTitleColor:[UIColor whiteColor]                          forState:UIControlStateSelected];
        
        [messageBtn setBackgroundImage:[UIImage imageNamed:@"fas_btn"]          forState:UIControlStateNormal];
        [messageBtn setBackgroundImage:[UIImage imageNamed:@"focus_btn"]        forState:UIControlStateSelected];
        
        [messageBtn addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
        messageBtn.selected = NO;

        [_bottomView addSubview:messageBtn];
        self.messageBtn = messageBtn;
        self.messageBtn.hidden = YES;
        
        UILabel *discLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, width, margin)];
        discLabel.textAlignment = NSTextAlignmentCenter;
        [discLabel setFont:[UIFont systemFontOfSize:10]];
        [discLabel setTextColor:[UIColor darkGrayColor]];
        [_bottomView addSubview:discLabel];
        _bottomView.backgroundColor = [UIColor whiteColor];
        self.discLabel = discLabel;
        self.discLabel.hidden = YES;
    }
    return _bottomView;
}

//- (UITableView *)tableV
//{
//    if (!_tableV) {
//        _tableV = [[UITableView alloc]init];
//        _tableV.delegate = self;
//    }
//    return _tableV;
//}

/**
 *  数据源数组
 */
- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        UITableView *tabl = [[UITableView alloc]init];
        tabl.delegate = self;
        tabl.dataSource = self;
        tabl.frame = CGRectMake(0,-20, systemSize.width, systemSize.height + 20);

        [self.view addSubview:tabl];
        self.tableV = tabl;
//        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//        {
//            CGRect rect = self.tableView.frame;
//            rect.origin.y -= 20;
//            self.tableView.frame = rect;
//        }
//        [self.tableV addHeaderWithTarget:self action:@selector(headerRefreshedTo)];
        [self.view addSubview:self.bottomView];
        self.guanzhuSign = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated
{
   
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)setUserId:(NSString *)userId
{
    _userId = userId;
    self.guanzhuSign = 1;
    NSString *userd = [MJUserDefault objectForKey:userDefaultUserId];
    if ([_userId isEqualToString:userd])
    {
        self.bottomView.hidden = YES;
        self.guanzhuBtn.hidden = YES;
        self.messageBtn.hidden = YES;
    }
    else
    {
        self.bottomView.hidden = NO;
        self.guanzhuBtn.hidden = NO;
        self.messageBtn.hidden = NO;
    }

    [self.dataSourceArray removeAllObjects];
    [self requestMessageWithUserId:self.userId];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableV reloadData];
    
}

- (void)setIsFocus:(BOOL)isFocus
{
    _isFocus = isFocus;
    if (self.isFocus)
    {
        
        self.guanzhuBtn.selected = YES;
//        [UIView animateWithDuration:0.4 animations:^{
            self.guanzhuBtn.y  = 0;
//        }];
        
//        MJLog(@"IsMeet==%@",self.IsMeet);
        
        if (self.IsMeet)
        {
            self.discLabel.hidden  = YES;
            self.messageBtn.hidden = NO;
            [self sendRCIMMessage];
        }
        else
        {
            MJLog(@"FocusStatus==%ld",(long)self.FocusStatus);
            if (self.FocusStatus == 1)
            {
                self.discLabel.hidden = YES;
                self.messageBtn.hidden  = NO;
                [self sendRCIMMessage];
            }
            else
            {
                self.messageBtn.hidden = YES;
                self.discLabel.hidden = NO;
                self.discLabel.text  = [NSString stringWithFormat:@"你已关注%@，相互关注后进行聊天",self.nickNameStr];
            }
            
        }

    }
    else
    {
        if (self.IsMeet)
        {
            self.guanzhuBtn.selected = NO;
            self.guanzhuBtn.y = 0;
            self.discLabel.hidden = YES;
            self.messageBtn.hidden = NO;
        }
        else
        {
            self.guanzhuBtn.selected = NO;
            self.messageBtn.hidden = YES;
            if (self.FocusStatus == 1)
            {
                self.discLabel.hidden = NO;
                self.discLabel.text = [NSString stringWithFormat:@"%@已关注你，相互关注后进行聊天",self.nickNameStr];
                self.guanzhuBtn.y = 0;
            }
            else
            {
                self.discLabel.hidden  = YES;
                //            [UIView animateWithDuration:0.4 animations:^{
                self.guanzhuBtn.y = 40;
                //            }];
            }

        }
        
        
    }
    
    
}

- (void)sendRCIMMessage
{
    if (self.guanzhuSign == 1)return;
//    [MJUserDefault setObject:headImgUrlStr                  forKey:userDefaultHeadImgUrlStr];
//    [MJUserDefault setObject:sexStr                         forKey:userDefaultSex];
//    [MJUserDefault setObject:userIdStr                      forKey:userDefaultUserId];
//    [MJUserDefault setObject:userNameStr                    forKey:userDefaultUserName];
    NSString *headImgUrl = [MJUserDefault objectForKey:userDefaultHeadImgUrlStr];
    NSString *userId     = [MJUserDefault objectForKey:userDefaultUserId];
    NSString *nameStr    = [MJUserDefault objectForKey:userDefaultUserName];
    MJLog(@"nameStr%@userId%@headImgUrl%@",nameStr,userId,headImgUrl);

    NSString *str = @"我关注了你";
    

    RCTextMessage *textMessage = [RCTextMessage messageWithContent:@"我已关注了你"];

    [[RCIMClient sharedClient] sendMessage:ConversationType_PRIVATE targetId:self.userId content:textMessage pushContent:str success:^(long messageId) {
        MJLog(@"关注发送融云消息成功%@,%@",userId,nameStr);
    } error:^(RCErrorCode nErrorCode, long messageId) {
        MJLog(@"关注发送融云消息失败%ld",(long)nErrorCode);
    }];
}

//- (void)headerRefreshedTo
//{
//    [self.dataSourceArray removeAllObjects];
//    [self requestMessageWithUserId:self.userId];
////    self.photoArray = [self requestPhotoLibWithUserId:self.userId];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInIdStr:(kMJMyMessageTableViewControllerInIdStr)inIdStr
{
    _inIdStr = inIdStr;
    switch (_inIdStr) {
        case kMJMyMessageTableViewControllerInIdStrRongYun:
        {
            MJLog(@"从融云聊天界面进入资料详情页");
            break;
        }
        case kMJMyMessageTableViewControllerInIdStrFirstMeet:
        {
            MJLog(@"从初遇列表进入资料详情页");
            if (!self.redSpotIsHidden)
            {
                [self requestToHiddenRedSpotWithTypeStr:@"1"];
            }
            
            break;
        }
        case kMJMyMessageTableViewControllerInIdStrGuanzhu:
        {
            MJLog(@"从关注界面进入资料详情页");
            break;
        }
        case kMJMyMessageTableViewControllerInIdStrRepeatMeet:
        {
            MJLog(@"从重逢界面进入资料详情页");
            if (!self.redSpotIsHidden)
            {
                [self requestToHiddenRedSpotWithTypeStr:@"2"];
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  请求红点是否隐藏
 *
 *  @param typeStr 1:初遇  2:重逢
 */
- (void)requestToHiddenRedSpotWithTypeStr:(NSString *)typeStr
{
    AFHTTPRequestOperationManager *hiddenSpotManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"UpdateMeetNewUserStatus"    forKey:requestKey];
    [params setObject:self.userId                   forKey:@"Friendid"];
    [params setObject:typeStr                       forKey:@"MeetType"];
    
    [hiddenSpotManager POST:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dic = responseObject;
        
        MJLog(@"请求初遇用户状态-连接服务器成功%@%@",dic,[dic objectForKey:@"Message"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"请求初遇用户状态-连接服务器失败%@",error);
        
    }];
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
//        [self.tableV headerEndRefreshing];
        NSDictionary *dic                   = responseObject;
        MJLog(@"responseObject%@",dic);
        NSString *statuCode                 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"IsSuccess"]];
        if ([statuCode isEqualToString:@"1"]) {
            NSDictionary *personInfor;
            if ([[dic objectForKey:@"Result"] count]>0) {
                NSDictionary *resultDic                    = [dic objectForKey:@"Result"][0];
                NSMutableDictionary *headDic            = [NSMutableDictionary dictionary];
                MJLog(@"%@",resultDic);
                
                NSString *headStr                       = [resultDic objectForKey:@"Headimg"];
                NSString *sexStr                        = [resultDic objectForKey:@"Sex"];
                NSString *nickNameStr                   = [resultDic objectForKey:@"Nickname"];
                self.nickNameStr                        = nickNameStr;
                NSString *mottoStr                      = [resultDic objectForKey:@"Motto"];
                
                self.FocusStatus                        = [[resultDic objectForKey:@"FocusStatus"] integerValue];
                
                self.IsMeet                             = [[resultDic objectForKey:@"IsMeet"] boolValue];
                
                self.isFocus                            = [[resultDic objectForKey:@"IsFocus"] boolValue];
                

                self.photoArray = [self requestPhotoLibWithUserId:self.userId];
                [headDic setObject:headStr                                  forKey:personInfoResultDicHeadimg];
                [headDic setObject:sexStr                                   forKey:personInfoResultDicSex];
                [headDic setObject:nickNameStr                              forKey:personInfoResultDicNickname];
                [headDic setObject:mottoStr                                 forKey:personInfoResultDicMotto];
                [self.dataSourceArray addObject:headDic];
                [self addModelToArrayWithName:@"情感状态："      content:[resultDic  objectForKey:@"Personinfo"]];
                [self addModelToArrayWithName:@"生日："         content:[resultDic   objectForKey:@"Brithday"]];
                [self addModelToArrayWithName:@"职业："         content:[resultDic   objectForKey:@"Vocation"]];
                [self addModelToArrayWithName:@"常出没地："      content:[resultDic   objectForKey:@"Haunt"]];
                [self addModelToArrayWithName:@"兴趣爱好："      content:[resultDic   objectForKey:@"Favorite"]];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self.tableV reloadData];
                });
                
            }else{
                
                personInfor                 = [dic objectForKey:@"Result"];
            }
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
//        [self.tableV headerEndRefreshing];
    }];

}

/**
 *  请求相册
 *
 *  @param userId userId
 *
 *  @return 返回数组
 */
- (NSArray *)requestPhotoLibWithUserId:(NSString *)userId
{
    NSMutableArray *urlArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *photoManager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"GetUserPhoto"   forKey:requestKey];
    [params setObject:userId            forKey:@"Userid"];
    
    [photoManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
//        [self.tableV headerEndRefreshing];
        
        NSDictionary *dic = responseObject;
        MJLog(@"返回结果\n%@",dic);
        MJLog(@"连接服务器成功");

        if ([[dic objectForKey:@"IsSuccess"] boolValue])
        {
            NSArray *resultArray = [dic objectForKey:@"Result"];
            if (resultArray > 0)
            {
                for (NSDictionary *urlDic in resultArray)
                {
                    NSString *urlStr = [urlDic objectForKey:@"contents"];
                    [urlArray addObject:urlStr];
                }
            }else
            {
                MJLog(@"相册为空");
            }

        }else
        {
            MJLog(@"请求失败%@",[dic objectForKey:@"Message"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
//        [self.tableV headerEndRefreshing];
        MJLog(@"连接服务器失败%@",error);
    }];
    return urlArray;
}


/**
 *  根据是否有值将模型加入数组
 *
 *  @param titleStr 标题
 *  @param content  内容
 */
- (void)addModelToArrayWithName:(NSString *)titleStr content:(NSString *)content
{
    if (![content isEqualToString:@""]) {
        MJPersonCellModel *personModel = [MJPersonCellModel personCellModel];
        personModel.title               = titleStr;
        personModel.content             = content;
        [self.dataSourceArray addObject:personModel];
        MJLog(@"%lu",(unsigned long)self.dataSourceArray.count);
    }else
    {
        return;
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSourceArray.count > 0) {
        if (self.photoArray.count > 0)
        {
            return self.dataSourceArray.count + 1;
        }
        else
        {
            
            MJLog(@"%lu",(unsigned long)self.dataSourceArray.count);
            return self.dataSourceArray.count;
        }
    }
    else
    {
        return self.nodataArray.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.dataSourceArray.count == 0) {
//        return nil;
//    }
    if (self.dataSourceArray.count > 0) {
        if (indexPath.row == 0)
        {
            MJHeadTableViewCell *headCell = [MJHeadTableViewCell headTableViewCellWithTableView:tableView];
            headCell.delegate = self;
            NSDictionary *dic = self.dataSourceArray[0];
            headCell.dic = dic;
            
            return headCell;
        }
        else
        {
            if (self.photoArray.count > 0)
            {
                if (indexPath.row == 1)
                {
                    NSDictionary *dic = self.dataSourceArray[0];
                    MJPersonPhotoTableViewCell *personCell  = [MJPersonPhotoTableViewCell photoTableViewCellWithTableView:tableView];
                    personCell.photoUrlStrArray             = self.photoArray;
                    personCell.userid                       = self.userId;
                    
                    personCell.dic                          = dic;
                    personCell.delegate                     = self;
                    return personCell;
                }
                else
                {
                    MJPersonLastTableViewCell *lastedCell   = [MJPersonLastTableViewCell latestTableViewCellWithTableView:tableView];
                    MJPersonCellModel *model = self.dataSourceArray[indexPath.row - 1];
                    lastedCell.personCellModel = model;
                    return lastedCell;
                }
            }
            else
            {
                MJPersonLastTableViewCell *lastedCell   = [MJPersonLastTableViewCell latestTableViewCellWithTableView:tableView];
                if (self.dataSourceArray.count > indexPath.row) {
                    MJPersonCellModel *model = self.dataSourceArray[indexPath.row];
                    lastedCell.personCellModel = model;
                }
                
                
                return lastedCell;
            }
        }

    }
    else
    {
        MJHeadTableViewCell *headCell = [MJHeadTableViewCell headTableViewCellWithTableView:tableView];
        headCell.delegate = self;
        NSDictionary *dic = self.nodataArray[0];
        headCell.dic = dic;
        
        return headCell;

    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 250;
    }
    else
    {
        if (self.photoArray.count > 0)
        {
            if (indexPath.row == 1)
            {
                return 80;
            }
            else
            {
                return 40;
            }
        }
        else
        {
            return 40;
        }
    }
}

#pragma mark - 按钮点击事件
/**
 *  关注按钮
 *
 *  @param sender
 */
- (void)guanzhuClick:(UIButton *)sender
{
    MJLog(@"点击了关注");
    self.guanzhuSign = 2;
    if (sender.selected)
    {
//        [UIView animateWithDuration:1.0 animations:^{
//            sender.y = 60;
//        }];
        self.isFocus = NO;
        [self sendFocusToServiceWithStr:@"0" requestSuccessMessage:@"取消关注成功"];
    }
    else
    {
//        [UIView animateWithDuration:1.0 animations:^{
//            sender.y = 0;
//        }];
        self.isFocus = YES;
        [self sendFocusToServiceWithStr:@"1" requestSuccessMessage:@"关注成功"];
    }
    
    
//    sender.selected = !sender.selected;
}

- (void)sendFocusToServiceWithStr:(NSString *)focusStr requestSuccessMessage:(NSString *)message
{
    AFHTTPRequestOperationManager *focusManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"EditFocusUser"    forKey:requestKey];
    [params setObject:self.userId           forKey:@"Friendsid"];
    [params setObject:focusStr              forKey:@"Operation"];
    
//    [MMProgressHUD showWithTitle:@"正在连接服务器。。。" status:@"请稍后。。。" cancelBlock:^{
//        [[focusManager operationQueue] cancelAllOperations];
//        [MMProgressHUD dismiss];
//        
//    }];
    
    [focusManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MMProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        NSString *message = [dic objectForKey:@"Message"];
        MJLog(@"关注按钮连接%@",message);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MMProgressHUD dismissWithError:@"网络连接失败" afterDelay:1.5];
    }];
    
}

/**
 *  发消息按钮
 *
 *  @param sender
 */
- (void)messageClick:(UIButton *)sender
{
    MJLog(@"点击了发消息");
    
/**============================第一种方案=================================================*/
    
    
    
/**=============================第二种方案===================================================*/
    if (self.inIdStr == kMJMyMessageTableViewControllerInIdStrRongYun)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        _conversationVC.targetId = self.userId;
        NSDictionary *dic = self.dataSourceArray[0];
        _conversationVC.targetName = [dic objectForKey:personInfoResultDicNickname];
        _conversationVC.name        =  [dic objectForKey:personInfoResultDicNickname];
        //    _conversationVC.title = model.conversationTitle;
        //    _conversationVC.conversation = model;
        
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    

}

/**
 *  点击返回按钮代理
 *
 *  @param headTableViewCell
 *  @param btn
 */
- (void)headTableViewCell:(MJHeadTableViewCell *)headTableViewCell didClickReturnBtn:(UIButton *)btn
{
    MJLog(@"点击了返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  点击更多按钮代理
 *
 *  @param headTableViewCell
 *  @param btn
 */
- (void)headTableViewCell:(MJHeadTableViewCell *)headTableViewCell didClickMoreBtn:(UIButton *)btn
{
    MJLog(@"点击了拉黑举报弹出按钮");
    MJBlackListCoverView *blackCV   = [MJBlackListCoverView blackListCoverView];
    blackCV.frame                   = CGRectMake(0, 0, systemSize.width, systemSize.height);
    blackCV.delegate                = self;
    [self.view addSubview:blackCV];
    self.blackCoverView             = blackCV;
    
}

#pragma mark - 拉黑覆盖view代理方法

/**
 *  点击取消按钮代理
 *
 *  @param blackListCV 黑名单覆盖物
 *  @param sender      取消按钮
 */
- (void)blackListCoverView:(MJBlackListCoverView *)blackListCV didClickCancelButton:(UIButton *)sender
{
    MJLog(@"点击了取消按钮");
    [blackListCV removeFromSuperview];
}


/**
 *  点击举报按钮代理
 *
 *  @param blackListCV 黑名单覆盖物
 *  @param sender      举报按钮
 */
- (void)blackListCoverView:(MJBlackListCoverView *)blackListCV didClickAlarmButton:(UIButton *)sender
{
    MJLog(@"点击了举报按钮");
    
    NSDictionary *dic = self.dataSourceArray[0];
    [[[UIAlertView alloc] initWithTitle:@""
                                message:[NSString stringWithFormat:@"是否举报%@",[dic objectForKey:personInfoResultDicNickname]]
                               delegate:self
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:@"确定", nil]
     show];

}

/**
 *  发送举报信息给服务器
 */
- (void)sendAlarmMessageToServerce
{
    AFHTTPRequestOperationManager *sendManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"ReportUser"     forKey:requestKey];
    [params setObject:self.userId       forKey:@"Userid"];
    [params setObject:@"暂时为空ios"     forKey:@"Reason"];
    
    [MMProgressHUD showWithTitle:@"正在举报。。" status:@"请稍后。。。" cancelBlock:^{
        [[sendManager operationQueue] cancelAllOperations];
        [MMProgressHUD dismiss];
    }];
    
    [sendManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dic = responseObject;
        MJLog(@"举报-请求服务器成功%@",dic);
        [MMProgressHUD dismissWithSuccess:@"举报成功"
                                    title:@"用户已举报，净化网络环境，谢谢您的支持！将该用户z在系统后台列入被举报人列表"
                               afterDelay:1.5];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        MJLog(@"举报-连接服务器失败");
        [MMProgressHUD dismissWithError:@"连接服务器失败" afterDelay:1.5];
    }];
}



/**
 *  点击拉黑按钮代理
 *
 *  @param blackListCV 黑名单覆盖物
 *  @param sender      拉黑按钮
 */
- (void)blackListCoverView:(MJBlackListCoverView *)blackListCV didClickAddBlackButton:(UIButton *)sender
{
    MJLog(@"点击了拉黑按钮");
    
}

///**
// *  拉黑信息发送给服务器
// */
//- (void)addBlackToServerce
//{
//    AFHTTPRequestOperationManager *sendBlackManager = [AFHTTPRequestOperationManager manager];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:@"EditMyBlacklist"    forKey:requestKey];
//    [params setObject:self.userId           forKey:@"Friendsid"];
//    [params setObject:@"1"                  forKey:@"Operation"];
//    
//    [MMProgressHUD showWithTitle:@"正在拉黑" status:@"请稍后。。。" cancelBlock:^{
//        [[sendBlackManager operationQueue] cancelAllOperations];
//        [MMProgressHUD dismiss];
//    }];
//    
//    [sendBlackManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = responseObject;
//        MJLog(@"拉黑-连接服务器成功%@",dic);
//        [MMProgressHUD dismissWithSuccess:@"拉黑成功" title:@"已加入后台黑名单" afterDelay:1.5];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        MJLog(@"拉黑-连接服务器失败");
//        [MMProgressHUD dismissWithError:@"连接服务器失败" afterDelay:1.5];
//    }];
//    
//}

#pragma mark - 弹窗代理
/**
 *  弹窗点击代理
 *
 *  @param alertView
 *  @param buttonIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MJLog(@"是否举报弹窗%ld",(long)buttonIndex);
    switch (buttonIndex)
    {
        case 0:
        {
            break;
        }
        case 1:
        {
            [self.blackCoverView removeFromSuperview];
            [self sendAlarmMessageToServerce];
//            [self addBlackToServerce];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 相册代理
/**
 *  点击相册cell代理
 *
 *  @param personPhotoTVC
 *  @param btn
 */
- (void)personPhotoTVC:(MJPersonPhotoTableViewCell *)personPhotoTVC didClickBtn:(UIButton *)btn withUserId:(NSString *)userid withDic:(NSDictionary *)dic
{
    MJLog(@"点击了相册");
    MJPhotoLibViewController *photoLibVC = [[MJPhotoLibViewController alloc]init];
    photoLibVC.dic = dic;
    NSString *userd = [MJUserDefault objectForKey:userDefaultUserId];
    if ([self.userId isEqualToString:userd])
    {
        photoLibVC.inSign = kMJPhotoLibViewControllerSignSelf;
    }
    else
    {
        photoLibVC.inSign = kMJPhotoLibViewControllerSignOther;
    }
    photoLibVC.userId = userid;
    [self.navigationController pushViewController:photoLibVC animated:YES];
}


- (void)dealloc
{
    [self.bottomView removeFromSuperview];
}

@end
