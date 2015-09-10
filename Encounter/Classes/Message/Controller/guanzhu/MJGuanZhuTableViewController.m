//
//  MJGuanZhuTableViewController.m
//  Encounter
//
//  Created by 李明军 on 12/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJGuanZhuTableViewController.h"
#import "MJCustomNavView.h"
#import "MJConst.h"
#import "MJGuanZhuPersonModel.h"
#import "MJFirstMeetModel.h"
#import "MJGuanzhuTableViewCell.h"
#import "MJFirstMeetTableViewCell.h"
#import "RCDChatViewController.h"
#import "MJMyMessageTableViewController.h"
#import "MJNoDataView.h"



@interface MJGuanZhuTableViewController ()<MJCustomNavViewDelegate,MJGuanzhuTableViewCellDelegate>

/** 导航 */
@property (nonatomic,strong) MJCustomNavView    *customNav;
/** 模型数组 */
@property (nonatomic,strong) NSMutableArray     *resultModelsArray;
/** 没有数据image */
@property (nonatomic,strong) UIView             *nadataView;
/** 刷新页数 */
@property (nonatomic,assign) NSInteger          pageNum;
/** nodata */
@property (nonatomic,strong) UIView             *uiview;

@end

@implementation MJGuanZhuTableViewController

- (MJCustomNavView *)customNav
{
    if (!_customNav) {
        _customNav = [[MJCustomNavView alloc]init];
        _customNav.delegate = self;
        _customNav.selectedIndex = self.selectedIndex;
    }
    return _customNav;
}

- (NSMutableArray *)resultModelsArray
{
    if (!_resultModelsArray) {
        _resultModelsArray = [NSMutableArray array];
    }
    return _resultModelsArray;
}

//- (UIView *)nadataView
//{
//    if (!_nadataView)
//    {
//        _nadataView = [[MJNoDataView alloc] init];
//    }
//    return _nadataView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    if (self.resultModelsArray.count < 1)
//    {
//       
//        [self.view addSubview:self.nadataView];
//    }
    if (self.resultModelsArray.count == 0)
    {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_data"]];
        img.frame = CGRectMake((systemSize.width - 150) * 0.5, (systemSize.height - 150) * 0.5 - 100, 150, 150);
        UIView *vie = [[UIView alloc]init];
        UILabel *labe = [[UILabel alloc] initWithFrame:CGRectMake(10, img.frame.origin.y + 120, systemSize.width - 20, 80)];
        labe.textColor = [UIColor darkGrayColor];
        labe.lineBreakMode = NSLineBreakByWordWrapping;
        labe.numberOfLines = 0;
        labe.textAlignment = NSTextAlignmentCenter;
        labe.text = @"您的关注列表还没有朋友，去热点发现一些好友吧。";
        [vie addSubview:labe];
        [vie addSubview:img];
        
        vie.frame = CGRectMake(0, 65, systemSize.width, systemSize.height - 125);
        vie.backgroundColor = [UIColor whiteColor];
        self.uiview = vie;
        [[[UIApplication sharedApplication].delegate window] addSubview:self.uiview];
        self.uiview.hidden = YES;
    }
}




- (void)viewWillAppear:(BOOL)animated
{
   
    self.pageNum = 1;
//    self.uiview.hidden = NO;
   [self requestGuanZhuListWithIndex:self.pageNum];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    
    
    
    [self.navigationController.navigationBar addSubview:self.customNav];
    [self.tabBarController.tabBar setHidden:NO];
}



- (void)viewDidAppear:(BOOL)animated
{
    if ([[MJUserDefault objectForKey:@"thirdSignView"] integerValue] == 1)
    {
        self.customNav.thirdSignView.hidden = NO;
    }
    
    if ([[MJUserDefault objectForKey:@"forthSignView"] integerValue] == 1)
    {
        self.customNav.forthSignView.hidden = NO;
    }
    if ([[MJUserDefault objectForKey:@"firstSignView"] integerValue] == 1) {
        self.customNav.firstSignView.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.uiview.hidden = YES;
//    [self.uiview removeFromSuperview];
    [self.customNav removeFromSuperview];
//    self.nadataView.hidden = YES;
    MJLog(@"%@",self.nadataView);
//    if (self.nadataView)
//    {
//        [self.nadataView removeFromSuperview];
//    }
}

- (void)viewDidDisappear:(BOOL)animated
{
//    if (self.nadataView)
//    {
//        [self.nadataView removeFromSuperview];
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section == 0) {
        return self.resultModelsArray.count;
    }
    else
    {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.customNav.selectedIndex == 1)
        {
            MJGuanzhuTableViewCell *cell = [MJGuanzhuTableViewCell guanzhuTableViewCellWithTableView:tableView];
            cell.guanzhuModel = self.resultModelsArray[indexPath.row];
            cell.delegate = self;
            //    [self.tableView reloadData];
            return cell;
        }
        else if (self.customNav.selectedIndex == 2)
        {
            MJFirstMeetTableViewCell *cell = [MJFirstMeetTableViewCell firstMeetTVCellWithTableView:tableView];
            MJFirstMeetModel *firstMeetModel = self.resultModelsArray[indexPath.row];
            cell.inStr = kMJFirstMeetTableViewCellInStrFirstMeet;
            cell.firstMeetModel = firstMeetModel;
            
            //  隐藏小红点
            
            NSInteger contNoHidden = 0;
            for (MJFirstMeetModel *fir in self.resultModelsArray)
            {
                if (fir.MeetFirstIsRead == 1)
                {
                    
                }
                else
                {
                    contNoHidden ++;
                }
            }
            
            //  隐藏小红点
            if (contNoHidden <= 0)
            {
                self.customNav.thirdSignView.hidden = YES;
                [MJUserDefault setObject:@"2" forKey:@"thirdSignView"];
                [MJUserDefault synchronize];
                
            }
            else
            {
                self.customNav.thirdSignView.hidden = NO;
                [MJUserDefault setObject:@"1" forKey:@"thirdSignView"];
                [MJUserDefault synchronize];
            }
            
            return cell;
        }
        else if (self.customNav.selectedIndex == 3)
        {
            MJFirstMeetTableViewCell *cell = [MJFirstMeetTableViewCell firstMeetTVCellWithTableView:tableView];
            MJFirstMeetModel *firstMeetModel = self.resultModelsArray[indexPath.row];
            cell.inStr = kMJFirstMeetTableViewCellInStrRepeatMeet;
            cell.firstMeetModel = firstMeetModel;
            
            
            NSInteger contNoHidden = 0;
            for (MJFirstMeetModel *fir in self.resultModelsArray)
            {
                if (fir.MeetAgainIsRead == 1)
                {
                    
                }
                else
                {
                    contNoHidden ++;
                }
            }
            
            //  隐藏小红点
            if (contNoHidden <= 0)
            {
                self.customNav.forthSignView.hidden = YES;
                [MJUserDefault setObject:@"2" forKey:@"forthSignView"];
                [MJUserDefault synchronize];
                
            }
            else
            {
                self.customNav.forthSignView.hidden = NO;
                [MJUserDefault setObject:@"1" forKey:@"forthSignView"];
                [MJUserDefault synchronize];
            }
            
            return cell;
        }

    }
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.customNav.selectedIndex == 1)
    {
        RCDChatViewController *_conversationVC  = [[RCDChatViewController alloc]init];
        _conversationVC.conversationType        = ConversationType_PRIVATE;
        MJGuanZhuPersonModel *guanzhuModel      = self.resultModelsArray[indexPath.row];
        _conversationVC.targetId                = [NSString stringWithFormat:@"%ld",(long)guanzhuModel.Userid];
        _conversationVC.targetName              = guanzhuModel.Nickname;
        _conversationVC.name                    = guanzhuModel.Nickname;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    else if (self.customNav.selectedIndex == 2)
    {
        MJMyMessageTableViewController *userInfoTVC = [[MJMyMessageTableViewController alloc] init];
        MJFirstMeetModel *firstMeetModel            = self.resultModelsArray[indexPath.row];
        userInfoTVC.userId = [NSString stringWithFormat:@"%ld",(long)firstMeetModel.Userid];
        userInfoTVC.inIdStr = kMJMyMessageTableViewControllerInIdStrFirstMeet;
        userInfoTVC.redSpotIsHidden = firstMeetModel.MeetFirstIsRead;
        [self.navigationController pushViewController:userInfoTVC animated:YES];
    }
    else if (self.customNav.selectedIndex == 3)
    {
        MJMyMessageTableViewController *userInfoTVC = [[MJMyMessageTableViewController alloc] init];
        MJFirstMeetModel *firstMeetModel            = self.resultModelsArray[indexPath.row];
        userInfoTVC.userId = [NSString stringWithFormat:@"%ld",(long)firstMeetModel.Userid];
        userInfoTVC.inIdStr = kMJMyMessageTableViewControllerInIdStrRepeatMeet;
        userInfoTVC.redSpotIsHidden = firstMeetModel.MeetAgainIsRead;
        
        
        [self.navigationController pushViewController:userInfoTVC animated:YES];
    }
    
    
    //    _conversationVC.title = model.conversationTitle;
    //    _conversationVC.conversation = model;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }
    return 1;
    
}

#pragma mark - 请求关注列表

/**
 *  头部刷新
 */
- (void)headRefresh
{
    self.pageNum = 1;
    [self requestGuanZhuListWithIndex:self.pageNum];
}

/**
 *  底部加载
 */
- (void)footRefresh
{
    if ((self.resultModelsArray.count != 0) && (self.resultModelsArray.count%10 == 0))
    {
        self.pageNum ++;
        [self requestGuanZhuListWithIndex:self.pageNum];
    }
    else
    {
//        [MMProgressHUD showAlert:@"已到最后"];
        [self.tableView footerEndRefreshing];
    }
    
}

#pragma mark - 关注列表请求
/**
 *  关注列表请求
 *
 *  @param index
 */
- (void)requestGuanZhuListWithIndex:(NSInteger)index
{
    AFHTTPRequestOperationManager *guanzhuManager = [AFHTTPRequestOperationManager manager];
    

    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (self.customNav.selectedIndex == 1)
    {
        [params setObject:@"GetMyFocusFriends"      forKey:requestKey];
        [params setObject:@(10)                     forKey:@"Pagesize"];
        [params setObject:@(1)                  forKey:@"Pageindex"];
    }
    else if (self.customNav.selectedIndex == 2)
    {
        [params setObject:@"GetMyFriends"           forKey:requestKey];
        [params setObject:@(1)                      forKey:@"Relationship"];
        [params setObject:@(10)                     forKey:@"Pagesize"];
        [params setObject:@(index)                  forKey:@"Pageindex"];
    }
    else if(self.customNav.selectedIndex == 3)
    {
        [params setObject:@"GetMyFriends"           forKey:requestKey];
        [params setObject:@(2)                      forKey:@"Relationship"];
        [params setObject:@(10)                     forKey:@"Pagesize"];
        [params setObject:@(index)                  forKey:@"Pageindex"];
    }
   
//    [MMProgressHUD showWithTitle:@"正在连接。。" status:@"请稍后..." cancelBlock:^{
//        [[guanzhuManager operationQueue] cancelAllOperations];
//        [MMProgressHUD dismiss];
//        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
//    }];
    
    //http://m.yibaiwu.com/V2/GetFocusFriends.ashx
    [guanzhuManager POST:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        NSDictionary *dic = responseObject;
        MJLog(@"关注列表-连接服务器成功%@",dic);
        
        BOOL isSuccess = [[dic objectForKey:@"IsSuccess"] boolValue];
        if (isSuccess)
        {
//            [MMProgressHUD dismiss];
            if (self.customNav.selectedIndex == 1)
            {
                [self guanzhuResultWithDic:dic];
            }
            else if(self.customNav.selectedIndex == 2)
            {
                [self firstMeetAndRepeatResultWithDic:dic];
            }
            else if(self.customNav.selectedIndex == 3)
            {
                [self firstMeetAndRepeatResultWithDic:dic];
            }
            
        }
        else
        {
//            [MMProgressHUD dismiss];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            NSString *message = [dic objectForKey:@"Message"];
            MJLog(@"关注列表-请求失败%@",message);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
//        [MMProgressHUD dismissWithError:@"网络连接错误，请稍后再试" afterDelay:1.5];
        MJLog(@"关注列表-连接服务器失败");
    }];
}

/**
 *  关注请求
 *
 *  @param dic
 */
- (void)guanzhuResultWithDic:(NSDictionary *)dic
{
    NSArray *resultArray = [dic objectForKey:@"Result"];
    if (resultArray.count == 0) {
        self.uiview.hidden = NO;
    }
    else
    {
        self.uiview.hidden = YES;
    }
    NSArray *resultModelArray = [MJGuanZhuPersonModel guanzhuPersonModelsWithArray:resultArray];
    MJLog(@"关注列表-模型数组%@",resultModelArray);
    if (self.pageNum == 1)
    {
//        [MMProgressHUD dismissWithSuccess:@"刷新成功" title:@"已是最新" afterDelay:1.5];
//        [MMProgressHUD dismiss];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.resultModelsArray removeAllObjects];
        [self resultArrayWithArray:resultModelArray];
        [self.tableView reloadData];
    }
    else
    {
//        [MMProgressHUD dismiss];
        [self resultArrayWithArray:resultModelArray];
        [self.tableView reloadData];
        
    }
}


/**
 *  关注请求结果
 *
 *  @param array
 */
- (void)resultArrayWithArray:(NSArray *)array
{
    for (MJGuanZhuPersonModel *guanzhuModel in array)
    {
        [self.resultModelsArray addObject:guanzhuModel];
    }
}

/**
 *  初遇和重逢返回结果一样
 *
 *  @param dic
 */
- (void)firstMeetAndRepeatResultWithDic:(NSDictionary *)dic
{
    NSArray *array = [dic objectForKey:@"Result"];
    NSArray *firstMeetModelArray = [MJFirstMeetModel firstMeetModelsWithArray:array];
    if (array.count == 0) {
        self.uiview.hidden = NO;
    }
    else
    {
        self.uiview.hidden = YES;
    }

    MJLog(@"初遇列表-模型数组%@",firstMeetModelArray);
    if (self.pageNum == 1)
    {
//        [MMProgressHUD dismissWithSuccess:@"刷新成功" title:@"已是最新" afterDelay:1.5];
       
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.resultModelsArray removeAllObjects];
        [self firstMeetAndRepeatResultWithArray:firstMeetModelArray];
        [self.tableView reloadData];
    }
    else
    {
//        [MMProgressHUD dismiss];
        [self firstMeetAndRepeatResultWithArray:firstMeetModelArray];
        [self.tableView reloadData];
        
    }

}

/**
 *  初遇结果
 *
 *  @param array
 */
- (void)firstMeetAndRepeatResultWithArray:(NSArray *)array
{
    for (MJFirstMeetModel *firstMeetModel in array)
    {
        MJLog(@"Lastlogintime%@,Lastmeettime%@,Create_time%@",firstMeetModel.Lastlogintime,firstMeetModel.Lastmeettime,firstMeetModel.Create_time);
        [self.resultModelsArray addObject:firstMeetModel];
    }
    
}


#pragma mark - 关注cell头像点击代理
/**
 *  关注cell头像点击代理
 *
 *  @param gianzhuCell
 *  @param headImgV
 */
- (void)guanzhuTableViewCell:(MJGuanzhuTableViewCell *)gianzhuCell didSelectedHeadimg:(UIImageView *)headImgV
{
    MJLog(@"点击了关注头像");
    MJMyMessageTableViewController *userInfoTVC = [[MJMyMessageTableViewController alloc] init];
    userInfoTVC.userId = [NSString stringWithFormat:@"%ld",(long)gianzhuCell.guanzhuModel.Userid];
    userInfoTVC.inIdStr = kMJMyMessageTableViewControllerInIdStrGuanzhu;
    [self.navigationController pushViewController:userInfoTVC animated:YES];
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
    self.uiview.hidden = YES;
    switch (segmentControlSelected)
    {
        case 0:
        {
            MJLog(@"sender%ld",(long)segmentControlSelected);
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:
        {
            MJLog(@"sender%ld",(long)segmentControlSelected);
            self.pageNum = 1;
            self.selectedIndex = 1;
            [self requestGuanZhuListWithIndex:self.pageNum];
            break;
        }
        case 2:
        {
            MJLog(@"sender%ld",(long)segmentControlSelected);
            self.pageNum = 1;
            self.selectedIndex = 2;
            [self requestGuanZhuListWithIndex:self.pageNum];
            break;
        }
            
        case 3:
        {
            MJLog(@"sender%ld",(long)segmentControlSelected);
            self.pageNum = 1;
            self.selectedIndex = 3;
            [self requestGuanZhuListWithIndex:self.pageNum];
            break;
        }
        default:
            break;
    }
    
    
}



@end
