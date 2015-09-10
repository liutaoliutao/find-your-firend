//
//  MJSettingTableViewController.m
//  Encounter
//
//  Created by 李明军 on 26/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJSettingTableViewController.h"
#import "MJSignView.h"
#import "MJConst.h"
#import "MJMyUserInfoTableViewController.h"
#import "AppDelegate.h"

@interface MJSettingTableViewController ()<UIAlertViewDelegate>
/** 小圆点设置 */
@property (weak, nonatomic) IBOutlet MJSignView *signView;
/** 退出按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation MJSettingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"bottom_my_s"]];
    self.signView.hidden = YES;

}

/**
 *  界面将出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"设置"];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:@"返回"];

}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) return 1;
    return 20;
}

/**
 *  选中cell处理事件
 *
 *  @param tableView tableview
 *  @param indexPath 索引
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    if (0 == indexPath.section)
    {
        switch (indexPath.row) {
            case 0:
            {
                
                MJMyUserInfoTableViewController *userInfoTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfo"];
                NSString *userId = [MJUserDefault objectForKey:userDefaultUserId];
                userInfoTVC.userid = userId;
                [self.navigationController pushViewController:userInfoTVC animated:YES];
                break;
            }
            default:
                break;
        }
    }
    else if (1 == indexPath.section)
    {
    }
}

/**
 *  消除选中痕迹
 */
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


//- (void)requestDeviceWithDic:(NSDictionary *)dic
//{
//    NSString  *paramValue           = [dic objectForKey:@"ParamValue"];
//    NSString *paramName         = [dic objectForKey:@"ParamName"];
//    NSString *paramFlag         = [dic objectForKey:@"ParamFlag"];
//    NSString *paramCreateTime   = [dic objectForKey:@"CeateTime"];
//    NSString *markStr           = [dic objectForKey:@"Remark"];
//    if ([paramName isEqualToString:@"2.0"]) {
//        self.signView.hidden = YES;
//        [MMProgressHUD dismissWithSuccess:@"已是最新版本"];
//    }
//    else
//    {
//        self.signView.hidden = NO;
//        if ([self.signView isKindOfClass:[MJSignView class]]) {
//            MJSignView *sign = self.signView;
//            sign.drawStr     = @"0";
//        }
//        [MMProgressHUD dismissWithSuccess:@"有新版本，请链接AppStore更新后再使用"];
////        [MJUserDefault removeObjectForKey:@"userNameTextLogin"];
//        //            [MJUserDefault removeObjectForKey:@"userPwdTextLogin"];
////        [MJNotifCenter removeObserver:self];
////        [SFHFKeychainUtils deleteItemForUsername:[MJUserDefault objectForKey:@"userNameTextLogin"] andServiceName:@"yibaiwuUserName" error:nil];
////        [[RCIM sharedKit] removeInactiveController];
////        [[RCIM sharedKit] disconnect];
////        AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
////        [appD stopLocationTrack];
////        UIStoryboard *loginSbd              = [UIStoryboard storyboardWithName:@"MJLogin" bundle:nil];
////        appD.window.rootViewController      = [loginSbd instantiateInitialViewController];
////        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:markStr]];
//    }
//
////    [MJUserDefault setObject:paramValue forKey:@"ServiceRemark"];
//    MJLog(@"ParamValue%@",paramValue);
//    MJLog(@"paramName%@",paramName);
//    MJLog(@"paramFlag%@",paramFlag);
//    MJLog(@"markStr%@",markStr);
//    
//}
//

#pragma mark - 控件事件处理

/**
 *  退出按钮点击事件
 */
- (IBAction)backBtnClick:(UIButton *)sender
{
    [[[UIAlertView alloc]initWithTitle:@"警告"
                               message:@"是否要退出当前账号，退出将不能接收消息"
                              delegate:self
                     cancelButtonTitle:@"取消"
                     otherButtonTitles:@"确定", nil]
     show];
}


#pragma mark - 弹窗代理

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MJLog(@"退出 - 点击弹窗%ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            MJLog(@"");
            break;
        }
        case 1:
        {
            MJLog(@"1");
            [MJUserDefault removeObjectForKey:@"userNameTextLogin"];
//            [MJUserDefault removeObjectForKey:@"userPwdTextLogin"];
            [MJNotifCenter removeObserver:self];
            [MJUserDefault removeObjectForKey:@"userGoDistance"];
            [MJUserDefault removeObjectForKey:userDefaultCurrentLocationLat];
            [MJUserDefault removeObjectForKey:userDefaultCurrentLocationLon];
            [MJUserDefault removeObjectForKey:userDefaultIsOnLocation];
            
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

            [MJUserDefault removeObjectForKey:userDefaultLatestFootPrint];
            
            
            [SFHFKeychainUtils deleteItemForUsername:[MJUserDefault objectForKey:@"userNameTextLogin"] andServiceName:@"yibaiwuUserName" error:nil];
            [[RCIM sharedKit] removeInactiveController];
            [[RCIM sharedKit] disconnect];
            AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appD stopLocationTrack];
            [appD stopNoReadThread];
            UIStoryboard *loginSbd              = [UIStoryboard storyboardWithName:@"MJLogin" bundle:nil];
            appD.window.rootViewController      = [loginSbd instantiateInitialViewController];
            break;
        }
        default:
            break;
    }
}


@end
