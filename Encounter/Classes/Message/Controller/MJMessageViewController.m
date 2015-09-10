//
//  MJMessageViewController.m
//  Encounter
//
//  Created by 李明军 on 25/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJMessageViewController.h"
//#import "MJCustomViewController.h"


@interface MJMessageViewController()<RCIMUserInfoFetcherDelegagte>

#pragma mark - 头部控件
/** 消息分段控件 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *messageSegumentController;
/** 会话提示红点 */
@property (weak, nonatomic) IBOutlet UIImageView *firstPointImgView;
/** 消息提示红点 */
@property (weak, nonatomic) IBOutlet UIImageView *senconPointImgView;
/** 初遇提示红点 */
@property (weak, nonatomic) IBOutlet UIImageView *thirdPointImgView;
/** 重逢提示红点 */
@property (weak, nonatomic) IBOutlet UIImageView *forthPointImgView;
/** 自定义会话列表 */
@property (weak, nonatomic) IBOutlet UITableView *chatListTV;

#pragma mark - 无数据时显示控件
/** 无数据时显示控件 */
@property (strong, nonatomic) IBOutlet UIView *nodataView;

@end

@implementation MJMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  隐藏导航条
//    [self.navigationController setNavigationBarHidden:YES];
//    self.messageSegumentController.selectedSegmentIndex = 0;
    //  设置tabbar选中图片
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"bottom_im_s"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self chatList];
}

- (void)viewWillDisappear:(BOOL)animated
{
}

#pragma mark - 分段控件
/**
 *  分段控件值
 *
 *  @param sender 分段控件
 */
- (IBAction)messageSegment:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            MJLog(@"sender%ld",(long)sender.selectedSegmentIndex);
            [self chatList];
            break;
        }
        case 1:
        {
            MJLog(@"sender%ld",(long)sender.selectedSegmentIndex);
            break;
        }
        case 2:
        {
            MJLog(@"sender%ld",(long)sender.selectedSegmentIndex);
            break;
        }

        case 3:
        {
            MJLog(@"sender%ld",(long)sender.selectedSegmentIndex);
            break;
        }
        default:
            break;
    }
}

#pragma mrk -  加载会话控制器
/**
 *  会话控制器
 */
- (void)chatList
{
    MJLog(@"点击会话");
    
    MJLog(@"点击会话");
    if ([MJUserDefault objectForKey:rongYunToKen]) {
        [self connectRongYun];
    }else{
        [self getToken];
    }

//    MJCustomViewController *cu = [[MJCustomViewController alloc] init];
//    [self.navigationController pushViewController:cu animated:YES];
    
    
}

//获取融云连接Token
- (void)getToken{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"GetToken" forKey:@"M"];
    [params setObject:[MJUserDefault objectForKey:userDefaultUserId]  forKey:@"userId"];
    [params setObject:[MJUserDefault objectForKey:userDefaultUserName] forKey:@"userName"];
    [params setObject:[MJUserDefault objectForKey:userDefaultHeadImgUrlStr] forKey:@"headImageUrl"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[SERVERADDRESS stringByAppendingString:@"Handler/ChatHandler.ashx"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=responseObject;
        NSString *statuCode =[NSString stringWithFormat:@"%@",[dic objectForKey:@"IsSuccess"]];
        MJLog(@"responseObject%@",dic);
        if ([statuCode isEqualToString:@"1"]) {
            NSDictionary *resultDic=[dic objectForKey:@"Result"];
            [MJUserDefault removeObjectForKey:rongYunToKen];
            [MJUserDefault setObject:[resultDic objectForKey:@"token"] forKey:rongYunToKen];
            [MJUserDefault synchronize];
            [self connectRongYun];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"错误%@",error);
    }];
}

- (void)connectRongYun
{
//    [RCIMClient con]
    [[RCIM sharedKit] connectWithToken:[MJUserDefault objectForKey:rongYunToKen] success:^(NSString *userId) {
        MJLog(@"连接成功");
//        MJCustomViewController *cu = [[MJCustomViewController alloc] init];
//        [self.navigationController pushViewController:cu animated:YES];
    } error:^(RCConnectErrorCode status) {
        MJLog(@"连接失败");
    }];
    
}

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
                //从后台服务器获取用户信息
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                [params setObject:@"GetUserInfo" forKey:@"M"];
                [params setObject:userId forKey:@"Userid"];
                [manager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dic = responseObject;
                    NSString *statuCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"IsSuccess"]];
                    if ([statuCode isEqualToString:@"1"]) {
                        RCUserInfo *user  = nil;
                        NSDictionary *personInfor;
                        if ([[dic objectForKey:@"Result"] count]>0) {
                            
                            personInfor=[dic objectForKey:@"Result"][0];
                            user.name=[personInfor objectForKey:@"Nickname"];
                            user.portraitUri=[personInfor objectForKey:@"Headimg"];
                        }else{
                            
                            personInfor=[dic objectForKey:@"Result"];
                        }
                        completion(user);
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        }error:nil];
    }

}

///**
// *  回调成功。
// *
// *  @param userId 当前登录的用户 Id，既换取登录 Token 时，App 服务器传递给融云服务器的用户 Id。
// */
//- (void)responseConnectSuccess:(NSString*)userId
//{
//    MJLog(@"请求成功%@",userId);
//    MJLog(@"连接融云成功%@",userId);
//    [MJUserDefault removeObjectForKey:@"rongyunID"];
//    [MJUserDefault setObject:userId forKey:@"rongyunID"];
//    [MJUserDefault synchronize];
//
//    
//    
//    
//}
//
///**
// *  回调出错。
// *
// *  @param errorCode 连接错误代码。
// */
//- (void)responseConnectError:(RCConnectErrorCode)errorCode
//{
//    MJLog(@"连接融云失败%ld",(long)errorCode);
//    
//}
//


@end
