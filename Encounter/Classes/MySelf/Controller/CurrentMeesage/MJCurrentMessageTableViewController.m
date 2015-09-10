//
//  MJCurrentMessageTableViewController.m
//  Encounter
//
//  Created by 李明军 on 27/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJCurrentMessageTableViewController.h"
#import "MJCurrentMessageCellModel.h"
#import "MJCurrentMessageTableViewCell.h"
#import "MJPhotoDetailTableViewController.h"
#import "MJConst.h"

@interface MJCurrentMessageTableViewController ()


/** 数据模型 */
@property (nonatomic,strong) NSMutableArray *currentMessageModelArray;

@end

@implementation MJCurrentMessageTableViewController

/**
 *  数据模型懒加载
 *
 *  @return 返回数据模型
 */
- (NSArray *)currentMessageModelArray
{
    if (!_currentMessageModelArray) {
        _currentMessageModelArray = [NSMutableArray array];
    }
    return _currentMessageModelArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setUserid:(NSString *)userid
{
    _userid = userid;
    [self requestMessageListWithUserId:_userid];
}

/**
 *  界面出现设置导航标题
 *
 *  @param animated 动画
 */
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"新消息"];
    [self.tabBarController.tabBar setHidden:YES];
}

/**
 *  界面消失时通过导航条设置下个界面返回按钮
 *
 *  @param animated 动画
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:@"返回"];
}


#pragma mark - Table view data source

/**
 *  tableview列
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentMessageModelArray.count;
}


/**
 *  tableviewcell具体内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJCurrentMessageTableViewCell *cell = [MJCurrentMessageTableViewCell currentMessageTableViewCellWithTableView:tableView];
    cell.currentModel                   = self.currentMessageModelArray[indexPath.row];
    
    return cell;
}

/**
 *  每个cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.currentMessageModelArray[indexPath.row] cellHeight];
}


/**
 *  选中cell时跳往下一个界面
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJPhotoDetailTableViewController *photoDetailTVC = [[MJPhotoDetailTableViewController alloc]init];
    MJCurrentMessageCellModel *model =  self.currentMessageModelArray[indexPath.row];
    photoDetailTVC.imgId = model.photoid;
    [self.navigationController pushViewController:photoDetailTVC animated:YES];
#warning .......选中状态未处理
}

#pragma mark - 请求新消息列表
/**
 *  请求新消息列表
 *
 *  @param userid
 */
- (void)requestMessageListWithUserId:(NSString *)userid
{
    AFHTTPRequestOperationManager *messageListManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"NotReadComments"    forKey:requestKey];
    [params setObject:userid                forKey:@"Myid"];
    
    [messageListManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        MJLog(@"请求新消息列表-连接服务器成功%@",dic);
        if ([[dic objectForKey:@"IsSuccess"] integerValue] == 1)
        {
            NSArray *resultArray = [dic objectForKey:@"Result"];
            NSArray *modelArray = [MJCurrentMessageCellModel currentMessageCellModelsWithArray:resultArray];
            for (MJCurrentMessageCellModel *model in modelArray)
            {
                [self.currentMessageModelArray addObject:model];
            }
            if (self.currentMessageModelArray.count > 0) {
                [self.tableView reloadData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"请求新消息列表-连接服务器失败%@",error);
    }];
    
    
}

@end
