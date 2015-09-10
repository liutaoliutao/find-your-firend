//
//  MJPhotoLibViewController.m
//  Encounter
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJPhotoLibViewController.h"
#import "MJPhotoLibTableViewCell.h"
#import "MJPhotoLibCellModel.h"
#import "MJPhotoDetailTableViewController.h"
#import "MJConst.h"
#import "MJSendPhotoViewController.h"
#import "AppDelegate.h"

@interface MJPhotoLibViewController ()<UITableViewDataSource,UITableViewDelegate,MJPhotoLibTableViewCellDelegate,MJSendPhotoViewControllerDelegate,UIAlertViewDelegate>

/** 相册tableView */
@property (weak, nonatomic) IBOutlet UITableView *photoLibTabV;

/** 数据模型 */
@property (nonatomic,strong) NSMutableArray *photoLibCellModelArray;
/**  */
@property (nonatomic,assign) NSInteger pageNum;

/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
/** 拍照按钮 */
@property (weak, nonatomic) IBOutlet UIButton *getPhotoBtn;
/** 图片id */
@property (nonatomic,assign) NSInteger imgId;

@end

@implementation MJPhotoLibViewController

- (NSArray *)photoLibCellModelArray
{
    if (!_photoLibCellModelArray) {
        _photoLibCellModelArray = [NSMutableArray array];
        
    }
    return _photoLibCellModelArray;
}


/**
 *  初始化加载xib
 *
 *  @return 返回self
 */
- (instancetype)init
{
    if (self = [super init])
    {
//        self = [[[NSBundle mainBundle]loadNibNamed:@"MJPhotoLibViewController"
//                                             owner:self
//                                           options:nil]
//                lastObject];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.pageNum = 1;
    
    [self requestPhotoLibWithUserId:self.userId withPageNum:self.pageNum];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    NSString *userid = [MJUserDefault objectForKey:userDefaultUserId];
    if (![userid isEqualToString:self.userId])
    {
        self.getPhotoBtn.hidden = YES;
    }
    else
    {
        self.getPhotoBtn.hidden = NO;
    }

//    //  1. 添加返回按钮
//    UIButton *rightBtn = [[UIButton alloc] init];
//    //  2.1. 配置返回按钮
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"back_list"]        forState:UIControlStateNormal];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"back_list_s"]      forState:UIControlStateHighlighted];
//    rightBtn.frame                   = CGRectMake(0, 0, 30, 25);
//    //  2.2. 设置返回按钮点击事件
//    [rightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//    //  2.3. 添加返回按钮
//    UIBarButtonItem *rightItem      = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"返回"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.photoLibTabV addHeaderWithTarget:self action:@selector(headRefresh)];
    [self.photoLibTabV addFooterWithTarget:self action:@selector(footRefresh)];
    
    
    
    
    
    NSString *bgStr     = [_dic objectForKey:personInfoResultDicBackImg];
    NSString *nickName  = [_dic objectForKey:personInfoResultDicNickname];
    NSString *headImg   = [_dic objectForKey:personInfoResultDicHeadimg];
    if ([bgStr isEqualToString:@""] || !bgStr)
    {
        [self.bgImgV setImage:[UIImage imageNamed:@"user_top_bg"]];
        
    }
    else
    {
        [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:bgStr]];
    }
    self.nameLabel.text = nickName;
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:headImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         self.headImgV.image = [UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
     }];

    // Do any additional setup after loading the view from its nib.
}


#pragma mark - 刷新
/**
 *  头部刷新
 */
- (void)headRefresh
{
    self.pageNum = 1;
    [self.photoLibCellModelArray removeAllObjects];
    [self requestPhotoLibWithUserId:self.userId withPageNum:self.pageNum];
}

/**
 *  底部加载
 */
- (void)footRefresh
{
    NSArray *rightA = self.photoLibCellModelArray[1];
    if ((self.photoLibCellModelArray.count != 0) && (rightA.count%5 == 0))
    {
        self.pageNum ++;
//        NSString *userId = [MJUserDefault objectForKey:userDefaultUserId];
        [self requestPhotoLibWithUserId:self.userId withPageNum:self.pageNum];
    }
    else
    {
//        [MMProgressHUD showAlert:@"已到最后"];
      
        [self.photoLibTabV footerEndRefreshing];
    }
    
}

#pragma mark - 设置头部

/**
 *  设置头部
 *
 *  @param dic
 */
- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
}


#pragma mark - 相册列表代理及数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.photoLibCellModelArray.count == 0)return 0;
    NSArray *leftArray = self.photoLibCellModelArray[0];
    return leftArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJPhotoLibTableViewCell *cell = [MJPhotoLibTableViewCell photoLibTableViewCellWithTableView:tableView];
    
    
    
    if (self.inSign == kMJPhotoLibViewControllerSignSelf) {
        cell.inNum = 1;
    }
    else
    {
        cell.inNum = 0;
    }
    cell.delegate = self;
    NSArray *leftModelArray = self.photoLibCellModelArray[0];
    NSArray *rightModelArray = self.photoLibCellModelArray[1];

    if ((leftModelArray.count + rightModelArray.count) % 2 != 0 ) {
        if ((leftModelArray.count - 1) != indexPath.row)
        {
            cell.rightCellModel = rightModelArray[indexPath.row];
        }
        
    }
    else
    {
        cell.rightCellModel = rightModelArray[indexPath.row];
    }
 
    
    cell.leftCellModel = leftModelArray[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 218;
}


#pragma mark - 返回按钮
/**
 *  顶部返回按钮点击事件
 *
 *  @param sender 返回按钮
 */
- (IBAction)headBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - cell图片点击代理方法
/**
 *  图片点击代理方法
 *
 *  @param photoLibTVC cell
 *  @param imgView     图片view
 */
- (void)photoLibTableViewCell:(MJPhotoLibTableViewCell *)photoLibTVC tapImgView:(UIImageView *)imgView withImgId:(NSInteger)imgid
{
    MJPhotoDetailTableViewController *detailTVC = [[MJPhotoDetailTableViewController alloc]init];
    detailTVC.imgId = imgid;
    detailTVC.userid = self.userId;
    if (self.inSign == kMJPhotoLibViewControllerSignSelf) {
        detailTVC.insign = kMJPhotoDetailTableViewControllerInStrSelf;
    }
    else
    {
        detailTVC.insign = kMJPhotoDetailTableViewControllerInStrOther;
    }
    
    [self.navigationController pushViewController:detailTVC animated:YES];
}


/**
 *  点击删除代理
 *
 *  @param photoLibTVC
 *  @param btn
 *  @param model
 */
- (void)photoLibTableViewCell:(MJPhotoLibTableViewCell *)photoLibTVC clickDeleteBtn:(UIButton *)btn withModel:(MJPhotoLibCellModel *)model withId:(NSInteger)imgId
{
    
    self.imgId = imgId;
    [[[UIAlertView alloc] initWithTitle:@"是否删除照片"
                                message:@""
                               delegate:self
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:@"确认", nil]
     show];
    
    
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            
            break;
        }
        case 1:
        {
            AFHTTPRequestOperationManager *deleteManager = [AFHTTPRequestOperationManager manager];
            
            
            NSString *signStr = [NSString stringWithFormat:@"%ld%@",(long)self.imgId,requestSecuKey];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setObject:@"Remove" forKey:requestKey];
            [params setObject:[NSString stringWithFormat:@"%ld",(long)self.imgId] forKey:@"Id"];
            [params setObject:[signStr md5String] forKey:requestKeySign];
            
            MJLog(@"删除照片%@%@",signStr,[signStr md5String]);
            
            [deleteManager POST:[SERVERADDRESS stringByAppendingString:@"V2/PhotoHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dic = responseObject;
                NSString *str = [dic objectForKey:@"retMsg"];
                MJLog(@"删除-连接服务器成功%@%@",dic,str);
                //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                //        });
                [self headRefresh];
                //        [self]
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                MJLog(@"删除-连接服务器错误%@",error);
                [[deleteManager operationQueue] cancelAllOperations];
            }];

            break;
        }
        default:
            break;
    }
}



/**
 *  请求相册
 *
 *  @param userId userId
 *
 *  @return 返回数组
 */
- (void)requestPhotoLibWithUserId:(NSString *)userId withPageNum:(NSInteger )pageN
{
    
    AFHTTPRequestOperationManager *photoManager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"V2_GetUserPhoto"   forKey:requestKey];
    [params setObject:userId            forKey:@"Userid"];
    [params setObject:@"10" forKey:@"Pagesize"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)pageN] forKey:@"Pageindex"];
    
//    [MMProgressHUD showWithTitle:@"正在刷新" status:@"请稍后" cancelBlock:^{
//        [[photoManager operationQueue] cancelAllOperations];
//        [MMProgressHUD dismiss];
//    }];
    
    [photoManager GET:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.photoLibTabV headerEndRefreshing];
         [self.photoLibTabV footerEndRefreshing];
         
         NSDictionary *dic = responseObject;
         MJLog(@"返回结果\n%@",dic);
         MJLog(@"连接服务器成功");

         if ([[dic objectForKey:@"IsSuccess"] boolValue])
         {
             NSArray *resultArray = [dic objectForKey:@"Result"];
             NSArray *rearray = [MJPhotoLibCellModel photoLibCellModelsWithArray:resultArray withPageNum:self.pageNum withPreArray:self.photoLibCellModelArray];
             for (NSArray *ar in rearray)
             {
                 [self.photoLibCellModelArray addObject:ar];
                 
             }
             [self.photoLibTabV reloadData];
//             [MMProgressHUD dismissWithSuccess:@"刷新成功"];
         }else
         {
//             [MMProgressHUD dismissWithError:[dic objectForKey:@"Message"]];
             MJLog(@"请求失败%@",[dic objectForKey:@"Message"]);
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.photoLibTabV headerEndRefreshing];
         [self.photoLibTabV footerEndRefreshing];
//         [MMProgressHUD dismissWithError:@"网络连接失败" afterDelay:1.5];
         MJLog(@"连接服务器失败%@",error);
     }];
}

#pragma mark - 添加照片点击

/**
 *  添加照片点击事件
 *
 *  @param sender
 */
- (IBAction)addPhotoBtn:(UIButton *)sender
{
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appD requestCurrentHotWithBlock:^{
        
    }];
    NSDictionary *spotDic       = [MJUserDefault objectForKey:userDefaultCurrentSpot];
    NSString *str               = [spotDic objectForKey:userDefaultCurrentSpotPlaceNameStr];
    NSInteger hotid             = [[spotDic objectForKey:userDefaultCurrentSpotHotspotIdStr] integerValue];
    MJSendPhotoViewController *sendPhotoVC = [[MJSendPhotoViewController alloc] init];
    sendPhotoVC.hotPlaceStr     = str;
    sendPhotoVC.hotId           = hotid;
    sendPhotoVC.delegate        = self;
    [self.navigationController pushViewController:sendPhotoVC animated:YES];

}

/**
 *  点击了发送按钮代理
 *
 *  @param sendPhotoVC
 *  @param sendBtn
 */
- (void)sendPhotoViewC:(MJSendPhotoViewController *)sendPhotoVC didClickSendBtn:(UIButton *)sendBtn
{
    [self headRefresh];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self headRefresh];
//    });
}

@end
