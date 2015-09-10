//
//  MJHotSpotViewController.m
//  Encounter
//
//  Created by 李明军 on 17/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#define bottomVHeight 50


#import "MJHotSpotViewController.h"
#import "MJConst.h"
#import "MJHotspotCellModel.h"
#import "MJTextHotTableViewCell.h"
#import "MJPhotoHotspotTableViewCell.h"
#import "MJFaceKeyBoardView.h"
#import "MJHotBottomView.h"
#import "MJSendPhotoViewController.h"
#import "MJPhotoDetailTableViewController.h"
#import "MJMyMessageTableViewController.h"
#import "MJHistoryTableViewController.h"
#import "AppDelegate.h"


@interface MJHotSpotViewController ()<UITableViewDelegate,UITableViewDataSource,MJFaceKeyBoardViewDelegate,MJHotBottomViewDelegate,MJPhotoHotspotTableViewCellDelegate,MJTextHotTableViewCellDelegate>

/**  表 */
@property (nonatomic,strong) UITableView *tableView;
/**  */
@property (nonatomic,assign) NSInteger pageNum;
/** 数据数组 */
@property (nonatomic,strong) NSMutableArray *resultArray;
/** 表情键盘 */
@property (nonatomic,strong) MJFaceKeyBoardView *facekeyBoard;
/** 底部view */
@property (nonatomic,strong) MJHotBottomView *bottomV;
/** 输入框中文字 */
@property (nonatomic,copy) NSString *sendStr;
/** indexpath */
@property (nonatomic,strong) NSIndexPath *indexpath;
/** 最大的itemid */
@property (nonatomic,assign) NSInteger mixItemid;
/** 每次结果数组 */
@property (nonatomic,strong) NSMutableArray *currentResultArray;
/** 刷新之前数组长度 */
@property (nonatomic,assign) NSInteger preArrayCount;

@end

@implementation MJHotSpotViewController

#pragma mark - 懒加载

- (NSMutableArray *)currentResultArray
{
    if (!_currentResultArray)
    {
        _currentResultArray = [NSMutableArray array];
    }
    return _currentResultArray;
}


/**
 *  底部按钮
 *
 *  @return
 */
- (MJHotBottomView *)bottomV
{
    if (!_bottomV) {
        
        _bottomV = [MJHotBottomView hotspotBottomView];
        _bottomV.delegate = self;
    }
    return _bottomV;
}

- (NSString *)sendStr
{
    if (!_sendStr) {
        _sendStr = [[NSString alloc] init];
    }
    return _sendStr;
}

/**
 *  表情键盘
 *
 *  @return
 */
- (MJFaceKeyBoardView *)facekeyBoard
{
    if (!_facekeyBoard)
    {
        CGFloat y = systemSize.height;
        _facekeyBoard = [[MJFaceKeyBoardView alloc] initWithFrame:CGRectMake(0, y, systemSize.width, 220)];
        _facekeyBoard.delegate = self;
    }
    return _facekeyBoard;
}

/**
 *  结果数据源数组
 *
 *  @return
 */
- (NSMutableArray *)resultArray
{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

/**
 *  显示主题tableview
 *
 *  @return
 */
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
    }
    return _tableView;
}


#pragma mark - 初始化发放加载控件
/**
 *  初始化发放加载控件
 *
 *  @return
 */
- (instancetype)init
{
    if (self = [super init]) {
        self.tableView.frame = self.view.bounds;
        [self.view addSubview:self.tableView];
        self.pageNum = 0;
        
//        CGFloat bottomVW                = systemSize.width;
//        CGFloat bottomVY                = systemSize.height - bottomVHeight;
//        self.bottomV.frame              = CGRectMake(0, bottomVY, bottomVW, bottomVHeight);
        //        self.facekeyBoard.hidden = YES;
        CGFloat bottomVW                = systemSize.width;
        CGFloat bottomVY                = systemSize.height - bottomVHeight;
        self.bottomV.frame = CGRectMake(0, bottomVY, bottomVW, bottomVHeight);
        [self.view addSubview:self.bottomV];
        [self.view addSubview:self.facekeyBoard];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self requestHotContentWithPageNumStr:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    
    [self.navigationItem setTitle:self.navTitle];
    [self.view endEditing:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:@"返回"];
  [MJNotifCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.view endEditing:YES];
    
    
    
    [self.tableView addHeaderWithTarget:self action:@selector(headMedRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footMedRefresh)];
    //  1. 添加返回按钮
    UIButton *rightBtn = [[UIButton alloc] init];
    //  2.1. 配置返回按钮
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"back_list"]        forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"back_list_s"]      forState:UIControlStateHighlighted];
    rightBtn.frame                   = CGRectMake(0, 0, 30, 25);
    //  2.2. 设置返回按钮点击事件
    [rightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    //  2.3. 添加返回按钮
    UIBarButtonItem *rightItem      = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    //  3.0 设置键盘改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    //  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldValueWiChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];

    
    // Do any additional setup after loading the view.
}

/**
 *  根据传入热点名称设置导航
 *
 *  @param navTitle
 */
- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    [self.navigationItem setTitle:_navTitle];
}


#pragma mark - 右导航条点击事件处理

/**
 *  右导航按钮点击事件
 *
 *  @param sender
 */
- (void)rightBarButtonItemPressed:(UIButton *)sender
{
    MJHistoryTableViewController *historyTVC = [[MJHistoryTableViewController alloc] init];
    
    [self.navigationController pushViewController:historyTVC animated:YES];
    MJLog(@"热点聊天右导航按钮");
}

#pragma mark - tableview代理和数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.resultArray.count > 0) {
        return self.resultArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.resultArray.count > 0)
    {
        MJHotspotCellModel *cellModel = self.resultArray[indexPath.row];
        
        
        if (cellModel.IntType == 1)
        {
            MJTextHotTableViewCell *textHotCell = [MJTextHotTableViewCell textHotTableViewCell:tableView];
            textHotCell.hotspotCellModel = cellModel;
            textHotCell.delegate = self;
            textHotCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return textHotCell;
        }
        else if(cellModel.IntType == 2)
        {
            MJPhotoHotspotTableViewCell *photoHotCell = [MJPhotoHotspotTableViewCell photoHotspotTVCellWithTableView:tableView];
            photoHotCell.hotspotCellModel = cellModel;
            photoHotCell.delegate       = self;
            photoHotCell.selectionStyle       = UITableViewCellSelectionStyleNone;
            return photoHotCell;
        }
        else
        {
            return nil;
        }
//        return self.resultArray.count;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexpath = indexPath;
    MJHotspotCellModel *cellModel = self.resultArray[indexPath.row];
    if (cellModel.IntType == 1)
    {
        return cellModel.textCellHeight;
    }
    else
    {
        return cellModel.photoCellHeight;
    }
    
}

/**
 *  滚动取消编辑状态
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [systemWindow endEditing:YES];
//    [self.tableView scrollToRowAtIndexPath:self.indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.facekeyBoard.y = systemSize.height;
        self.bottomV.y = self.facekeyBoard.y - bottomVHeight;
        //        self.view.y -= 220;
    }];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 从服务器获取数据
/**
 *  获取数据
 *
 *  @param pageNumStr 获取数据
 */
- (void)requestHotContentWithPageNumStr:(NSString *)pageNumStr
{
    
    NSString *hotIdStr = [NSString stringWithFormat:@"%ld",(long)self.hotId];
    NSString *signStr = [NSString stringWithFormat:@"%ld%@",(long)self.hotId,requestSecuKey];
    
    MJLog(@"请求热点内容%@\nmd5%@",signStr,[signStr md5String]);
    

    
    AFHTTPRequestOperationManager *hotContentManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"GetHotContent"      forKey:requestKey];
    [params setObject:hotIdStr         forKey:@"HotId"];
    [params setObject:@(10)                 forKey:@"PageSize"];
    [params setObject:pageNumStr            forKey:@"ItemId"];
    [params setObject:[signStr md5String]   forKey:requestKeySign];
    
//    [MMProgressHUD showWithTitle:@"正在刷新" status:@"请稍后" cancelBlock:^{
//        [[hotContentManager operationQueue] cancelAllOperations];
//        [MMProgressHUD dismiss];
//    }];
    
    
    [hotContentManager POST:[SERVERADDRESS stringByAppendingString:@"V2/HotspotHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        
        
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        MJLog(@"请求热点内容-连接服务器成功%@",dic);
        NSInteger isSucess = [[dic objectForKey:@"retCode"] integerValue];
        if (isSucess == 1)
        {
//            [MMProgressHUD dismissWithSuccess:@"刷新成功"];
            NSArray *resultArray = [dic objectForKey:@"retData"];
            NSArray *modelArray = [MJHotspotCellModel hotspotCellModelsWithArray:resultArray];
            
            [self successWithArray:modelArray];
        }
        else
        {
//            [MMProgressHUD dismiss];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
//        [MMProgressHUD dismissWithError:@"网络连接失败，请稍后再试" afterDelay:1.5];
        MJLog(@"请求热点内容-连接服务器成功%@",error);
    }];
    
    
    
}



/**
 *  成功处理
 *
 *  @param modelArray 成功加入数据数组
 */
- (void)successWithArray:(NSArray *)modelArray
{
    [self.currentResultArray removeAllObjects];
    self.preArrayCount = self.resultArray.count;
    for (MJHotspotCellModel *cellModel in modelArray)
    {
        [self.currentResultArray addObject:cellModel];
    }
    
    if (self.pageNum != 0)
    {
        for (MJHotspotCellModel *cellModel in self.resultArray)
        {
            [self.currentResultArray addObject:cellModel];
        }
    }
    
    [self.resultArray removeAllObjects];
    for (MJHotspotCellModel *cellModel in self.currentResultArray)
    {
        [self.resultArray addObject:cellModel];
    }
    
    [self.tableView reloadData];
    [self scrollToBottom];
}


#pragma mark - 表情键盘代理

/**
 *  表情键盘
 *
 *  @param faceBtnImgStr
 */
- (void)faceKeyBoardDidSelectedFaceBtnWithFaceBtnStr:(NSString *)faceBtnImgStr
{
//    self.sendStr = [MJUserDefault objectForKey:@"sendStr"];
//    NSString *str = [MJUserDefault objectForKey:@"sendStr"];
//    [MJUserDefault removeObjectForKey:@"sendStr"];
//    MJLog(@"表情键盘代理--：\n点击了图片%@",str);
    MJLog(@"senderStr%@",self.sendStr);
    self.sendStr = [self.sendStr stringByAppendingString:faceBtnImgStr];
    self.bottomV.textField.attributedText = [NSString attributedTextWithText:self.sendStr];
    
//    [MJUserDefault setObject:self.sendStr forKey:@"sendStr"];
//    [MJUserDefault synchronize];
//    [self.bottomV.textField setAttributedText:str];
}



#pragma mark - 底部输入框代理
/**
 *  发送按钮点击事件
 *
 *  @param hotBottomView MJHotBottomView
 *  @param sendBtn       发送按钮
 */
- (void)hotBottomView:(MJHotBottomView *)hotBottomView didClickSendBtnWithTButton:(UIButton *)sendBtn
{
    MJLog(@"点击了发送按钮-热点聊天");
    
    MJHotspotCellModel *hotspotCell = [[MJHotspotCellModel alloc] init];
    
    NSString *headImgUrl            = [MJUserDefault    objectForKey:userDefaultHeadImgUrlStr];
    NSInteger userId                = [[MJUserDefault   objectForKey:userDefaultUserId] integerValue];
    NSString *nameStr               = [MJUserDefault    objectForKey:userDefaultUserName];
    hotspotCell.HeadImg             = headImgUrl;
    hotspotCell.UserId              = userId;
    hotspotCell.NickName            = nameStr;
    hotspotCell.Content             = self.sendStr;
    hotspotCell.IntType             = 1;
    
    NSDateFormatter *formatter      = [[NSDateFormatter alloc] init];
    formatter.dateFormat            = MJDateFormatTwo;

    hotspotCell.Timer               = [formatter stringFromDate:[NSDate date]];
    
    [hotspotCell setPhotoFrame];
    [hotspotCell setTextFrame];
    
    [self currentTableViewReloadWithHotSpotCellModel:hotspotCell];
    [self sendDataToServerceWithHotSpotCellModel:hotspotCell];
    [self scrollToBottom];
}




/**
 *  照片按钮点击代理
 *
 *  @param hotBottomView MJHotBottomView
 *  @param photoBtn      照片按钮
 */
- (void)hotBottomView:(MJHotBottomView *)hotBottomView didClickPhotoBtnWithButton:(UIButton *)photoBtn
{
    MJLog(@"点击了照片按钮-热点聊天");
    NSString *placeStr;
    if ([MJUserDefault objectForKey:userDefaultCurrentLocationStr]) {
        placeStr = [MJUserDefault objectForKey:userDefaultCurrentLocationStr];
    }else
    {
        NSArray *array = [MJUserDefault objectForKey:userDefaultLatestFootPrint];
        NSDictionary *dic = [array lastObject];
        placeStr = [dic objectForKey:userDefaultLatestFootPrintDicAddress];
    }
    
    MJSendPhotoViewController *sendPhotoVC = [[MJSendPhotoViewController alloc] init];
    sendPhotoVC.hotPlaceStr = self.navTitle;
    sendPhotoVC.hotId    = self.hotId;
    sendPhotoVC.addressStr = placeStr;
    [self.navigationController pushViewController:sendPhotoVC animated:YES];
}

/**
 *  表情按钮代理
 *
 *  @param hotBottomView MJHotBottomView
 *  @param faceBtn       表情按钮
 */
- (void)hotBottomView:(MJHotBottomView *)hotBottomView didClickFaceBtnWithButton:(UIButton *)faceBtn
{
        MJLog(@"点击了表情按钮代理-热点聊天");
    [self.view endEditing:YES];
    [self scrollToBottom];
//    self.bottomV.textField.attributedText = [NSString attributedTextWithText:self.sendStr];
    [UIView animateWithDuration:0.5 animations:^{
        self.facekeyBoard.y = systemSize.height - 220;
        self.bottomV.y = self.facekeyBoard.y - bottomVHeight;

    }];
}


#pragma mark - 点击发送按钮处理

/**
 *  本地表格刷新数据
 */
- (void)currentTableViewReloadWithHotSpotCellModel:(MJHotspotCellModel *)hotspotCellModel
{
    if (![self.sendStr isEqualToString:@""])
    {
        [self.resultArray   addObject:hotspotCellModel];
        [self.tableView     reloadData];
        
    }
    [self.view endEditing:YES];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.facekeyBoard.y = systemSize.height;
        self.bottomV.y = self.facekeyBoard.y - bottomVHeight;
        
    }];
    
    self.sendStr = @"";
    self.bottomV.textField.attributedText = [NSString attributedTextWithText:self.sendStr];
}

/**
 *  上传数据库
 */
- (void)sendDataToServerceWithHotSpotCellModel:(MJHotspotCellModel *)hotspotCellModel
{
    
    AFHTTPRequestOperationManager *sendTextManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *signStr = [NSString stringWithFormat:@"%ld%@",(long)self.hotId,requestSecuKey];
    
    MJLog(@"发送文字给服务器:%@\nmd5:%@",signStr,[signStr md5String]);
    
    [params setObject:@"SendText"               forKey:requestKey];
    [params setObject:hotspotCellModel.Content  forKey:@"Content"];
    [params setObject:@(self.lat)               forKey:@"Lat"];
    [params setObject:@(self.lon)               forKey:@"Long"];
    [params setObject:self.navTitle             forKey:@"Place"];
    [params setObject:@(self.hotId)                forKey:@"HotId"];
    [params setObject:[signStr md5String]       forKey:requestKeySign];
    
    
    [sendTextManager POST:[SERVERADDRESS stringByAppendingString:@"V2/HotspotHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dic = responseObject;
    
        MJLog(@"发送文字给服务器-连接服务器成功%@%@",dic,[dic objectForKey:@"retMsg"]);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        MJLog(@"发送文字给服务器-连接服务器成功%@",error);
    }];
    
}

#pragma mark - 键盘通知
/**
 *  监听键盘
 */
- (void)keyBoardChange:(NSNotification *) notification
{
    [self scrollToBottom];
//    [self.tableView scrollToRowAtIndexPath:self.indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.facekeyBoard.y = systemSize.height;
//    self.bottomV.y = systemSize.height - bottomVHeight;
//    self.view.÷y = 0;
    MJLog(@"%@",notification);
    [UIView animateWithDuration:[[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue] animations:^{
        CGRect keyboardRect           = [[notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        self.bottomV.y                = keyboardRect.origin.y - bottomVHeight;
//        self.view.y                   = keyboardRect.origin.y - systemSize.height;
//        if ([UIScreen mainScreen].bounds.size.height <= keyboardRect.origin.y)
//        {
//            self.bottomV.enablePlaceholder   = NO;
//        }
//        else
//        {
//            self.bottomV.enablePlaceholder   = YES;
//        }
    }];
    
}

#pragma mark - 输入框变更通知

/**
 *  输入框变更通知
 */
- (void)textFieldValueWiChange
{
    NSString *text = [self.bottomV.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([text isEqualToString:@""])
    {
        self.bottomV.sendBtn.enabled = NO;
    }
    else
    {
        self.bottomV.sendBtn.enabled = YES;
    }
    self.sendStr = [NSString stringTextWithAttributeStr:self.bottomV.textField.attributedText];
    MJLog(@"输入框变更通知%@",self.bottomV.textField.attributedText);
    MJLog(@"%@",self.sendStr);
//    [MJUserDefault setObject:self.sendStr forKey:@"sendStr"];
//    [MJUserDefault synchronize];
//    [self.sendStr stringByAppendingString:[NSString attributedTextWithText:[self.bottomV.textField attributedText]]];
}


/**
 *  滚动
 */
- (void)scrollToBottom
{
    if (self.resultArray.count <= 1)return;
    NSIndexPath *index;
    if (self.pageNum != 0)
    {
        index = [NSIndexPath indexPathForRow:(self.resultArray.count - self.preArrayCount) + 1 inSection:0];
        MJLog(@"%lu",(unsigned long)self.currentResultArray.count);
        MJLog(@"%lu",(unsigned long)self.resultArray.count);
        
    }
    else
    {
        index = [NSIndexPath indexPathForRow:self.resultArray.count-1 inSection:0];
    }
    
    
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


/**
 *  头部刷新
 */
- (void)headMedRefresh
{
    MJHotspotCellModel *model = [self.resultArray firstObject];
    self.pageNum = model.ItemId;

    [self requestHotContentWithPageNumStr:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
}

/**
 *  底部加载
 */
- (void)footMedRefresh
{
    self.pageNum = 0;
    [self requestHotContentWithPageNumStr:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
}


#pragma mark - 图片点击代理方法

/**
 *  图片点击代理方法
 *
 *  @param photoTVC
 *  @param imgId
 */
- (void)photoHotspotTVC:(MJPhotoHotspotTableViewCell *)photoTVC didClickPhotoWithImgId:(NSString *)imgId WithUserId:(NSString *)userid
{
    MJLog(@"点击了图片");
    MJPhotoDetailTableViewController *photoDetailTVC = [[MJPhotoDetailTableViewController alloc]init];
//    MJCurrentMessageCellModel *model =  self.currentMessageModelArray[indexPath.row];
    photoDetailTVC.imgId = [imgId integerValue];
    NSString *userd = [MJUserDefault objectForKey:userDefaultUserId];
    if ([userd isEqualToString:userid])
    {
        photoDetailTVC.insign = kMJPhotoDetailTableViewControllerInStrSelf;
    }
    else
    {
        photoDetailTVC.insign = kMJPhotoDetailTableViewControllerInStrOther;
    }
    
    [self.navigationController pushViewController:photoDetailTVC animated:YES];
}


/**
 *  头像点击代理方法
 *
 *  @param photoTVC
 *  @param imgId
 */
- (void)photoHotspotTVC:(MJPhotoHotspotTableViewCell *)photoTVC didClickHeadWithUserId:(NSString *)imgId
{
    MJMyMessageTableViewController *myMessageTVC = [[MJMyMessageTableViewController alloc] init];
    myMessageTVC.userId = imgId;
    [self.navigationController pushViewController:myMessageTVC animated:YES];
}

/**
 *  头像点击代理方法
 *
 *  @param textHotTVC cell
 *  @param userId     userId
 */
- (void)textHotTableViewCell:(MJTextHotTableViewCell *)textHotTVC didClickHeadWithUserId:(NSString *)userId
{
    MJMyMessageTableViewController *myMessageTVC = [[MJMyMessageTableViewController alloc] init];
    myMessageTVC.userId = userId;
    [self.navigationController pushViewController:myMessageTVC animated:YES];
}







- (void)dealloc
{
    [MJNotifCenter removeObserver:self];
//    [MJNotifCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

@end
