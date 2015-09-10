//
//  MJLuckListTableViewController.m
//  Encounter
//
//  Created by 李明军 on 16/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJLuckListTableViewController.h"
#import "MJConst.h"
#import "MJHotSpotListModel.h"
#import "MJHotspotTableViewCell.h"

@interface MJLuckListTableViewController ()

/** 刷新页标 */
@property (nonatomic,assign) NSInteger pageNum;
/** 结果数组 */
@property (nonatomic,strong) NSMutableArray *resultArray;

@end

@implementation MJLuckListTableViewController

- (NSMutableArray *)resultArray
{
    if (!_resultArray) {
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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh)];
//    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.pageNum = 1;
    [self requestHotListWithPageIndex:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationItem setTitle:@"初遇热点排行榜"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}



#pragma mark - 下拉上啦刷

/**
 *  下拉刷新
 */
- (void)headRefresh
{
    self.pageNum = 1;
    [self requestHotListWithPageIndex:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
}

/**
 *  上啦加载更多
 */
- (void)footRefresh
{
//    self.pageNum ++;
    [self requestHotListWithPageIndex:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    if ((self.resultArray.count != 0) && (self.resultArray.count%10 == 0))
    {
        self.pageNum ++;
        [self requestHotListWithPageIndex:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    }
    else
    {
        [MMProgressHUD showAlert:@"已到最后"];
        [self.tableView footerEndRefreshing];
    }

}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJHotspotTableViewCell *cell = [MJHotspotTableViewCell hotspotTabCellWithTableView:tableView];
    cell.hotspotListModel = self.resultArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - 请求初遇热点排行榜
/**
 *  请求初遇热点排行榜
 *
 *  @param pageNum
 */
- (void)requestHotListWithPageIndex:(NSString *)pageNum
{
    NSArray *footArray = [MJUserDefault objectForKey:userDefaultLatestFootPrint];
    NSDictionary *dic = [footArray lastObject];
    
    NSString *latStr = [dic objectForKey:userDefaultLatestFootPrintDicLat];
    NSString *lonStr = [dic objectForKey:userDefaultLatestFootPrintDicLon];
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@%d%@",latStr,lonStr,pageNum,10,requestSecuKey];
    
    MJLog(@"请求初遇排行榜signStr%@\n%@",signStr,[signStr md5String]);
    
    AFHTTPRequestOperationManager *hotListManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"GetHotspotRanking"             forKey:requestKey];
    [params setObject:latStr                    forKey:@"Lat"];
    [params setObject:lonStr                    forKey:@"Long"];
    [params setObject:pageNum                   forKey:@"PageIndex"];
    [params setObject:@(10)                     forKey:@"PageSize"];
    [params setObject:[signStr md5String]       forKey:requestKeySign];
    
//    [MMProgressHUD showWithTitle:@"正在获取..." status:@"请稍后..." cancelBlock:^{
//        [[hotListManager operationQueue] cancelAllOperations];
//        [MMProgressHUD dismiss];
//    }];
    
    
    [hotListManager POST:[SERVERADDRESS stringByAppendingString:@"V2/HotspotHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
        
        NSDictionary *dic = responseObject;
        NSString *message = [dic objectForKey:@"retMsg"];
        MJLog(@"获取初遇热点排行榜-连接服务器成功%@%@",dic,message);
        NSString *isSuccess = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
        if ([isSuccess isEqualToString:@"1"])
        {
            NSArray *resultArray = [dic objectForKey:@"retData"];
            if (self.pageNum == 1)
            {
//                [MMProgressHUD dismiss];
                
                [self.resultArray removeAllObjects];
                [self requestSuccessWithArray:resultArray];
            }
            else
            {
//                [MMProgressHUD dismiss];
                [self requestSuccessWithArray:resultArray];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
//        [MMProgressHUD dismissWithError:@"网络连接失败，请稍后再试。。。" afterDelay:1.5];
//        MJLog(@"获取初遇热点排行榜-连接服务器成功%@",error);
    }];
}

- (void)requestSuccessWithArray:(NSArray *)array
{
    NSArray *resultArray = [MJHotSpotListModel hotspotModelsWithArray:array];
    
    for (MJHotSpotListModel *hotspotListModel in resultArray)
    {
        [self.resultArray addObject:hotspotListModel];
    }
    [self.tableView reloadData];
}


@end
