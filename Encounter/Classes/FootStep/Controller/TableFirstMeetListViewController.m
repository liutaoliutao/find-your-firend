//
//  TableFirstMeetListViewController.m
//  Encounter
//
//  Created by 李明军 on 30/6/15.
//  Copyright (c) 2015年 AiTa. All rights reserved.
//

#import "TableFirstMeetListViewController.h"
#import "MJConst.h"
#import "MJHotSpotListModel.h"
#import "MJCurrentHotTableViewCell.h"
#import "MJHotSpotViewController.h"

@interface TableFirstMeetListViewController ()

/** 刷新页标 */
@property (nonatomic,assign) NSInteger pageNum;
/** 结果数组 */
@property (nonatomic,strong) NSMutableArray *resultArray;

@end

@implementation TableFirstMeetListViewController

- (NSMutableArray *)resultArray
{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headlistRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footlistRefresh)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.pageNum = 1;
    [self requestHotListWithPageIndex:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationItem setTitle:@"初遇热点"];
}


#pragma mark - 下拉上啦刷

/**
 *  下拉刷新
 */
- (void)headlistRefresh
{
    self.pageNum = 1;
    [self requestHotListWithPageIndex:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
}

/**
 *  上啦加载更多
 */
- (void)footlistRefresh
{
    //    self.pageNum ++;
    //    [self requestHotListWithPageIndex:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    if ((self.resultArray.count != 0) || (self.resultArray.count%10 == 0))
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


- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.resultArray.count > 0)
    {
        return self.resultArray.count + 1;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJCurrentHotTableViewCell *cell = [MJCurrentHotTableViewCell currentHotTableViewCellWithTableView:tableView];
    
    if (indexPath.row == 0)
    {
        MJHotSpotListModel *hotSpotListModel = [[MJHotSpotListModel alloc] init];
        
        NSDictionary *spotDic       = [MJUserDefault objectForKey:userDefaultCurrentSpot];
        
        hotSpotListModel.Image = [spotDic objectForKey:userDefaultCurrentSpotImageStr];
        hotSpotListModel.PlaceName = [spotDic objectForKey:userDefaultCurrentSpotPlaceNameStr];
        cell.hotListModel = hotSpotListModel;
        
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.resultArray.count > 0) {
            cell.hotListModel = self.resultArray[indexPath.row - 1];
        }
        
    }
    // Return the number of rows in the section.
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MJHotSpotViewController *hotSpotViewC = [[MJHotSpotViewController alloc]init];
        NSDictionary *spotDic       = [MJUserDefault objectForKey:userDefaultCurrentSpot];
        NSString *str           = [spotDic objectForKey:userDefaultCurrentSpotPlaceNameStr];
        double  lat             = [[spotDic objectForKey:userDefaultCurrentSpotLatStr] doubleValue];
        double  lon             = [[spotDic objectForKey:userDefaultCurrentSpotLonStr] doubleValue];
        //            NSString *hotid          = [dic objectForKey:userDefaultCurrentSpotHotspotIdStr];
        NSInteger hotid          = [[spotDic objectForKey:userDefaultCurrentSpotHotspotIdStr] integerValue];
        MJLog(@"hotid%d",(int)hotid);
        
        hotSpotViewC.hotId      = hotid;
        hotSpotViewC.lat        = lat;
        hotSpotViewC.lon        = lon;
        hotSpotViewC.navTitle   = str;
        
        [self.navigationController pushViewController:hotSpotViewC animated:YES];
    }
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
        [self.tableView footerEndRefreshing];
        
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
        [self.tableView footerEndRefreshing];
//        [MMProgressHUD dismissWithError:@"网络连接失败，请稍后再试。。。" afterDelay:1.5];
        MJLog(@"获取初遇热点排行榜-连接服务器成功%@",error);
    }];
}

- (void)requestSuccessWithArray:(NSArray *)array
{
    NSArray *resultArray = [MJHotSpotListModel hotspotModelsWithArray:array];
    
    NSDictionary *spotDic       = [MJUserDefault objectForKey:userDefaultCurrentSpot];
    
    NSString *placeStr = [spotDic objectForKey:userDefaultCurrentSpotPlaceNameStr];

    
    for (MJHotSpotListModel *hotspotListModel in resultArray)
    {
        if (![placeStr isEqualToString:hotspotListModel.PlaceName]) {
            [self.resultArray addObject:hotspotListModel];
        }
        
    }
    // 系统是按照从小 -> 大的顺序排列对象
    [self.resultArray sortUsingComparator:^NSComparisonResult(MJHotSpotListModel *part1, MJHotSpotListModel *part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.distance > part2.distance) {
            // part1>part2
            // part1放后面, part2放前面
            return NSOrderedDescending;
        }
        // part1<part2
        // part1放前面, part2放后面
        return NSOrderedAscending;
    }];

    
    [self.tableView reloadData];
}

@end
