//
//  MJHistoryTableViewController.m
//  Encounter
//
//  Created by 李明军 on 17/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJHistoryTableViewController.h"
#import "MJConst.h"
#import "MJHistoryHotSpotModel.h"
#import "MJHistoryHotTableViewCell.h"

@interface MJHistoryTableViewController ()


/** 结果数组 */
@property (nonatomic,strong) NSMutableArray *resultArray;
/** 请求页面 */
@property (nonatomic,assign) NSInteger pageNum;

@end

@implementation MJHistoryTableViewController

/**
 *  懒加载
 *
 *  @return
 */
- (NSMutableArray *)resultArray
{
    if (!_resultArray)
    {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}


- (instancetype)init
{
    if (self = [super init])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.pageNum = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self requestHistoryHotWithPageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationItem setTitle:@"初遇热点"];
}


- (void)viewWillDisappear:(BOOL)animated
{

}

#pragma mark - 上下拉
/**
 *  下拉刷新
 */
- (void)headRefresh
{
    self.pageNum = 1;
    [self requestHistoryHotWithPageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
}

/**
 *  上啦加载更多
 */
- (void)footRefresh
{
    //    self.pageNum ++;
    //    [self requestHotListWithPageIndex:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    if ((self.resultArray.count != 0) && (self.resultArray.count%10 == 0))
    {
        self.pageNum ++;
        [self requestHistoryHotWithPageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    }
    else
    {
        [MMProgressHUD showAlert:@"已到最后"];
        [self.tableView footerEndRefreshing];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return self.resultArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJHistoryHotTableViewCell *cell = [MJHistoryHotTableViewCell historyHotTVCWithTableView:tableView];
    if (indexPath.section == 0)
    {
        NSDictionary *spotDic       = [MJUserDefault objectForKey:userDefaultCurrentSpot];
        
        MJHistoryHotSpotModel *historyModel = [[MJHistoryHotSpotModel alloc] init];
        historyModel.Image = [spotDic objectForKey:userDefaultCurrentSpotImageStr];
        historyModel.PlaceName = [spotDic objectForKey:userDefaultCurrentSpotPlaceNameStr];
        historyModel.NickName = [spotDic objectForKey:userDefaultCurrentSpotTitleStr];
        historyModel.CreateTime = [spotDic objectForKey:userDefaultCurrentSpotCreatTimeStr];
        
        cell.inStr = kMJHistoryHotTableViewCellInStrCurrent;
        cell.historyModel = historyModel;
    }
    else
    {
        cell.inStr = kMJHistoryHotTableViewCellInStrHistory;
        cell.userInteractionEnabled = NO;
        cell.historyModel = self.resultArray[indexPath.row];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"";
    }
    else
    {
        return @"历史热点";
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求历史热点

- (void)requestHistoryHotWithPageNum:(NSString *)pageNumStr
{
    AFHTTPRequestOperationManager *historyManager = [AFHTTPRequestOperationManager manager];
    
    NSString *signStr = [NSString stringWithFormat:@"%@10%@",pageNumStr,requestSecuKey];
    
    MJLog(@"signStr:%@\nmd5:%@",signStr,[signStr md5String]);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"GetHotspotHis"      forKey:requestKey];
    [params setObject:pageNumStr            forKey:@"PageIndex"];
    [params setObject:@"10"                 forKey:@"PageSize"];
    [params setObject:@"0"                  forKey:@"HotId"];
    [params setObject:[signStr md5String]   forKey:requestKeySign];
    
//    [MMProgressHUD showWithTitle:@"正在刷新...." status:@"请稍后" cancelBlock:^{
//        [[historyManager operationQueue] cancelAllOperations];
//        [MMProgressHUD dismiss];
//    }];
    
    
    [historyManager POST:[SERVERADDRESS stringByAppendingString:@"V2/HotspotHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
    
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        NSDictionary *dic = responseObject;
        MJLog(@"请求历史热点-连接服务器成功%@",dic);
        NSString *isSucess = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
        if ([isSucess isEqualToString:@"1"])
        {
//            [MMProgressHUD dismiss];
            MJLog(@"请求历史热点成功");
            NSArray *array = [dic objectForKey:@"retData"];
            if (self.pageNum == 1)
            {
                [self.resultArray removeAllObjects];
                [self requestHistoryWithArray:array];
                [self.tableView reloadData];
            }
            else
            {
                [self requestHistoryWithArray:array];
                [self.tableView reloadData];
            }
        }
        else
        {
//            [MMProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
//        [MMProgressHUD dismissWithError:@"网络连接失败，请稍后再试" afterDelay:1.5];
        MJLog(@"请求历史热点-连接服务器失败%@",error);
    }];
    
}


- (void)requestHistoryWithArray:(NSArray *)array
{
    NSArray *historyModelArray              = [MJHistoryHotSpotModel historyHotspotModelsWithArray:array];
    NSDictionary *spotDic                   = [MJUserDefault objectForKey:userDefaultCurrentSpot];
    
    MJHistoryHotSpotModel *cchistoryModel   = [[MJHistoryHotSpotModel alloc] init];
    cchistoryModel.Image                    = [spotDic objectForKey:userDefaultCurrentSpotImageStr];
    cchistoryModel.PlaceName                = [spotDic objectForKey:userDefaultCurrentSpotPlaceNameStr];
    cchistoryModel.NickName                 = [spotDic objectForKey:userDefaultCurrentSpotTitleStr];
    cchistoryModel.CreateTime               = [spotDic objectForKey:userDefaultCurrentSpotCreatTimeStr];
    cchistoryModel.HotspotId                = [[spotDic objectForKey:userDefaultCurrentSpotHotspotIdStr]
                                               integerValue];
    for (MJHistoryHotSpotModel *historyModel in historyModelArray)
    {
        if (![cchistoryModel.PlaceName isEqualToString:historyModel.PlaceName])
        {
            MJLog(@"cchistoryModel.PlaceName:%@=historyModel.PlaceName%@",cchistoryModel.PlaceName,historyModel.PlaceName);
            [self.resultArray addObject:historyModel];
        }
    }
    
}

@end
