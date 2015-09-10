//
//  MJPhotoDetailTableViewController.m
//  Encounter
//
//  Created by 李明军 on 28/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#define bottomVHeight 50


#import "MJPhotoDetailTableViewController.h"
#import "MJPhotoDetailUserCellModel.h"
#import "MJPhotDetailTableViewCell.h"
#import "MJPhotoCommentTableViewCell.h"
#import "MJConst.h"
#import "MJBottomCommentView.h"
#import "UIView+Extension.h"
#import "MJCustomAlertView.h"
#import "MJMyMessageTableViewController.h"
#import "MJFaceKeyBoardView.h"


@interface MJPhotoDetailTableViewController ()<MJPhotDetailTableViewCellDelegate,kMJCustomAlertViewDelegate,MJPhotoCommentTableViewCellDelegate,MJBottomCommentViewDelegate,MJFaceKeyBoardViewDelegate,UITextViewDelegate,UIActionSheetDelegate>

/** 模型数组 */
@property (nonatomic,strong) NSMutableArray *photoDetailArray;
/**  */
@property (nonatomic,strong) NSMutableArray *listArray;

/** view */
@property (nonatomic,weak) MJBottomCommentView *bottomView;
/** 表情键盘 */
@property (nonatomic,strong) MJFaceKeyBoardView *facekeyBoard;
/** 输入框中文字 */
@property (nonatomic,copy) NSString *sendStr;
/** 弹窗 */
@property (nonatomic,strong) UIAlertView *alert;
/**  */
@property (nonatomic,assign) NSInteger pageNum;
/** 防止重复弹窗 */
@property (nonatomic,assign) NSInteger repeatNum;
/**  */
@property (nonatomic,strong) UIButton *rightBtn;
/** 是否位评论刷新标识 */
@property (nonatomic,assign) NSInteger commentNum;


@end

@implementation MJPhotoDetailTableViewController

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
 *  懒加载数据模型
 */
- (NSMutableArray *)photoDetailArray
{
    if (!_photoDetailArray) {
        _photoDetailArray = [NSMutableArray array];
    }
    return _photoDetailArray;
}


- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.repeatNum = 1;
    //  1.0 设置右边导航条
    [self setRightTabBarItem];
    self.sendStr = @"";
    //  2.0 设置底部评论view
    self.commentNum = 1;
    MJBottomCommentView *bottomV    = [MJBottomCommentView bottomCommentView];
    
    CGFloat bottomVW                = [UIScreen mainScreen].bounds.size.width;
    CGFloat bottomVY                = [UIScreen mainScreen].bounds.size.height - bottomVHeight;
    bottomV.frame                   = CGRectMake(0, bottomVY, bottomVW, bottomVHeight);
    bottomV.commentLabel.delegate   = self;
    [[[UIApplication sharedApplication].delegate window] addSubview:bottomV];
    self.bottomView                 = bottomV;
    self.bottomView.delegate        = self;
    [[[UIApplication sharedApplication].delegate window] addSubview:self.facekeyBoard];
    
    //  3.0 设置键盘改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldValueWillChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];

    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshed)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshed)];
    
    
}

#pragma mark - 刷新

/**
 *  头部刷新
 */
- (void)headerRefreshed
{
    self.pageNum = 1;
    [self requestPhotoDetailWithPhotoId:self.imgId WithPageNum:self.pageNum];
}

/**
 *  底部刷新
 */
- (void)footerRefreshed
{
//    (self.resultModelsArray.count != 0) && (self.resultModelsArray.count%10 == 0)
    if (((self.photoDetailArray.count - 1) % 10 == 0) && (self.photoDetailArray.count != 1)) {
        self.pageNum ++;
        [self requestPhotoDetailWithPhotoId:self.imgId WithPageNum:self.pageNum];
    }
    else
    {
//        [MMProgressHUD showAlert:@"已到最后"];
        [self.tableView footerEndRefreshing];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.bottomView setHidden:YES];
    [self.facekeyBoard removeFromSuperview];
    self.pageNum = 1;
    [systemWindow endEditing:YES];
}

#pragma mark - 设置导航条

/**
 *  设置导航item
 */
- (void)setRightTabBarItem
{
    //  1.0 自定义导航条右边按钮
    UIButton *btn                           = [[UIButton alloc]init];
    //  1.1 设置按钮显示内容
    [btn setImage:[UIImage imageNamed:@"top_report"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"top_report_s"] forState:UIControlStateSelected];
    [btn setTitle:@"举报" forState:UIControlStateNormal];
    [btn setTitleColor:systemColor forState:UIControlStateNormal];
    //  1.2 监听按钮点击事件
    [btn addTarget:self action:@selector(rightTabbarClick) forControlEvents:UIControlEventTouchUpInside];
    //  1.3 设置按钮bounds
    btn.bounds                              = CGRectMake(0, 0, 70, 20);

    UIBarButtonItem *rightItem              = [[UIBarButtonItem alloc]initWithCustomView:btn];
    if (_insign == kMJPhotoDetailTableViewControllerInStrSelf) {
        btn.hidden = YES;
    }
    else
    {
        btn.hidden = NO;
    }

    //  2.0 添加导航条item
    self.navigationItem.rightBarButtonItem  = rightItem;
    
    [self.navigationItem setTitle:@"详情"];

}


#pragma mark - 导航条点击事件

/**
 *  举报按钮事件
 */
- (void)rightTabbarClick
{
    MJLog(@"点击了举报按钮");
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否举报此照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    [sheet showInView:[[[UIApplication sharedApplication] delegate] window]];

}

#pragma mark - 代理方法
/**
 *  1.0 头像点击底部弹窗代理方法
 *
 *  @param actionSheet 弹窗
 *  @param buttonIndex 索引  0:从相册选取 1:从相机选取
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
           
            MJLog(@"点击了确定");
            [self sendAlarmMessageToServerce];
            break;
        }
        case 1:
        {
            
            MJLog(@"点击了取消");
            break;
        }
        default:
            break;
    }
}


/**
 *  发送举报信息给服务器
 */
- (void)sendAlarmMessageToServerce
{
    AFHTTPRequestOperationManager *sendManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"ReportUser"     forKey:requestKey];
    [params setObject:self.userid       forKey:@"Userid"];
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
                                     title:@"照片已举报，净化网络环境，谢谢您的支持！将该照片在系统后台列入被举报照片列表"
                                afterDelay:1.5];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         MJLog(@"举报-连接服务器失败");
         [MMProgressHUD dismissWithError:@"连接服务器失败" afterDelay:1.5];
     }];
}


#pragma mark - Table view 数据源和代理方法

/**
 *  设置cell数量
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.photoDetailArray.count;
}

/**
 *  设置cell内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (0 == indexPath.row)
    {
        MJPhotDetailTableViewCell *photoDetailCell = [MJPhotDetailTableViewCell photoDetailTableViewCellWithTableView:tableView];
        photoDetailCell.pthoDetailUserCellModel    = self.photoDetailArray[0];
        photoDetailCell.delegate                   = self;
        photoDetailCell.selectionStyle                        = UITableViewCellSelectionStyleNone;
        cell = photoDetailCell;
    }
    else
    {
        MJPhotoCommentTableViewCell *commentCell   = [MJPhotoCommentTableViewCell photoCommentTableViewCellWithTableView:tableView];
        commentCell.phtoDetailUserCellModel        = self.photoDetailArray[indexPath.row];
        commentCell.delegate                       = self;
        cell = commentCell;
    }
    return cell;
}

/**
 *  设置高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return [self.photoDetailArray[0] detailCellHeight];
    }
    else
    {
        return [self.photoDetailArray[indexPath.row] cellHeight];
    }
}

/**
 *  取消编辑状态
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    [systemWindow endEditing:YES];
    if (indexPath.row != 0)
    {
        MJPhotoDetailUserCellModel *model = self.photoDetailArray[indexPath.row];
        NSInteger userid = [[MJUserDefault objectForKey:userDefaultUserId] integerValue];
        if (model.UserId == userid)
        {
            MJCustomAlertView *custAV = [[MJCustomAlertView alloc] init];
            custAV.delegate = self;
            custAV.commentId = model.CommentId;
            custAV.frame = [UIScreen mainScreen].bounds;
            custAV.labelStr = @"是否删除";
            [[[UIApplication sharedApplication].delegate window] addSubview:custAV];
        }
        else
        {
            self.bottomView.nickStr = model.NickName;
            self.bottomView.commontId = model.CommentId;
            [self.bottomView.commentLabel becomeFirstResponder];
        }

    }
    
}


/**
 *  消除选中痕迹
 */
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



/**
 *  滚动取消编辑状态
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [systemWindow endEditing:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.facekeyBoard.y = systemSize.height;
        self.bottomView.y = self.facekeyBoard.y - self.bottomView.bounds.size.height;
        self.bottomView.nickStr = @"";
        self.bottomView.enablePlaceholder = NO;
    }];
    
}

/**
 *  监听键盘
 */
- (void)keyBoardChange:(NSNotification *) notification
{
    MJLog(@"%@",notification);
    self.facekeyBoard.y = systemSize.height;
    [UIView animateWithDuration:[[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue] animations:^{
        CGRect keyboardRect                     = [[notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]
                                                   CGRectValue];
        self.bottomView.y                       = keyboardRect.origin.y - self.bottomView.bounds.size.height;
        if ([UIScreen mainScreen].bounds.size.height <= keyboardRect.origin.y)
        {
            self.bottomView.enablePlaceholder   = NO;
        }
        else
        {
            self.bottomView.enablePlaceholder   = YES;
        }
    }];
    
}


#pragma mark -  MJPhotDetailTableViewCell代理方法
/**
 *  头像点击代理方法
 *
 *  @param photoDetailTVC cell
 *  @param headImgView    头像
 */
- (void)photoDetailTVC:(MJPhotDetailTableViewCell *)photoDetailTVC didClickHeadImgView:(UIImageView *)headImgView
{
    MJLog(@"点击了头像");
}

/**
 *  图片点击代理方法
 *
 *  @param photoDetailTVC cell
 *  @param imgMessageView 图片
 */
- (void)photoDetailTVC:(MJPhotDetailTableViewCell *)photoDetailTVC didClickImgMessageView:(UIImageView *)imgMessageView
{
    MJLog(@"点击了图片");
//    [photoDetailTVC.maskingImgView removeFromSuperview];
//    [photoDetailTVC.maskingView removeFromSuperview];
    if (self.repeatNum == 1)
    {
        MJLog(@"进来");
        self.repeatNum ++;
        self.alert  =   [[UIAlertView alloc]initWithTitle:@"保存图片"
                                                  message:@""
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
        [self.alert show];
        
    }
    
}


/**
 *  赞按钮点击代理方法
 *
 *  @param photoDetailTVC 本类
 *  @param imgMessageView 图片信息
 */
- (void)photoDetailTVC:(MJPhotDetailTableViewCell *) photoDetailTVC didClickgoodBtn:(UIButton *)goodBtn withImgId:(NSInteger)imgId
{
    AFHTTPRequestOperationManager *goodManager = [AFHTTPRequestOperationManager manager];
    
    
    NSString *signStr = [NSString stringWithFormat:@"%ld%@",(long)imgId,requestSecuKey];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"PraisePhoto" forKey:requestKey];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)imgId] forKey:@"PhotoId"];
    [params setObject:[signStr md5String] forKey:requestKeySign];
    
    MJLog(@"点赞%@\nsignstr%@",params,signStr);
    
    [goodManager POST:[SERVERADDRESS stringByAppendingString:@"V2/PhotoHandler.ashx"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        MJLog(@"赞-连接服务器成功%@",dic);
        [self headerRefreshed];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"赞-连接服务器失败%@",error);
    }];
    
}


- (void)photoCommentTVC:(MJPhotoCommentTableViewCell *)photoCommentTV didClickImgWithUserId:(NSInteger)userid
{
    MJMyMessageTableViewController *messageTVC = [[MJMyMessageTableViewController alloc] init];
    messageTVC.userId = [NSString stringWithFormat:@"%ld",(long)userid];
    [self.navigationController pushViewController:messageTVC animated:YES];
}

#pragma mark - 防止重复弹窗

/**
 *  通过弹窗代理，防止重复弹窗
 *
 *  @param alertView   弹窗
 *  @param buttonIndex 点击按钮
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //防止重复弹出提示框
    self.repeatNum = 1;
    MJLog(@"点击了%ld",(long)buttonIndex);
    if (buttonIndex == 1)
    {
        NSString *imgpath = [MJUserDefault objectForKey:@"savePhotoDetailImage"];
        UIImage *imge = [UIImage imageWithContentsOfFile:imgpath];
        MJLog(@"%@",imge);
        UIImageWriteToSavedPhotosAlbum(imge, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
//    [alertView removeFromSuperview];
//    alertView = nil;
}

#pragma mark - 图片保存之后回调
/**
 *  图片保存之后回调
 *
 *  @param image
 *  @param error
 *  @param contextInfo
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    MJLog(@"保存完毕");
    // Was there an error?
}


- (void)setImgId:(NSInteger)imgId
{
    _imgId = imgId;
    self.pageNum = 1;
    [self requestPhotoDetailWithPhotoId:_imgId WithPageNum:self.pageNum];
}


#pragma mark - 图片请求

/**
 *  请求照片详情
 *
 *  @param photoId
 */
- (void)requestPhotoDetailWithPhotoId:(NSInteger)photoId WithPageNum:(NSInteger)pageNum
{
    AFHTTPRequestOperationManager *photoDetailManager = [AFHTTPRequestOperationManager manager];
    
    NSString *signStr = [NSString stringWithFormat:@"%ld%@",(long)photoId,requestSecuKey];
    NSString *idStr   = [NSString stringWithFormat:@"%ld",(long)photoId];
    MJLog(@"请求照片详情signStr:%@\nmd5:%@\nidStr:%@",signStr,[signStr md5String],idStr);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"PhotoDetails"                                   forKey:requestKey];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)photoId]  forKey:@"Id"];
    [params setObject:[signStr md5String]                               forKey:requestKeySign];
    
//    [MMProgressHUD showWithTitle:@"正在刷新" status:@"请稍后" cancelBlock:^{
//        [[photoDetailManager operationQueue] cancelAllOperations];
//        [MMProgressHUD dismiss];
//    }];
    
    MJLog(@"params%@\nurlStr:%@",params,[SERVERADDRESS stringByAppendingString:@"V2/PhotoHandler.ashx?"]);
    [photoDetailManager GET:[SERVERADDRESS stringByAppendingString:@"V2/PhotoHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MMProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        MJLog(@"请求照片详情-连接服务器成功%@",dic);
        NSInteger retCode = [[dic objectForKey:@"retCode"] integerValue];
        if (retCode == 1) {
            NSDictionary *resultDic = [dic objectForKey:@"retData"];
            [self.photoDetailArray removeAllObjects];
            MJPhotoDetailUserCellModel *model = [MJPhotoDetailUserCellModel photoDetailUserCellModelWithDic:resultDic];
            [self.photoDetailArray addObject:model];
            [self requestPhotoDetailListWithPhotoId:photoId withPageNum:pageNum];
        }
        else
        {
//            [MMProgressHUD dismiss];
            MJLog(@"请求照片详情，请求失败%@",[dic objectForKey:@"retMsg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MMProgressHUD dismissWithError:@"网络连接失败"];
        MJLog(@"请求照片详情-连接服务器失败%@",error);
    }];
    
}

/**
 *  请求照片评论列表
 *
 *  @param photoId
 */
- (void)requestPhotoDetailListWithPhotoId:(NSInteger)photoId withPageNum:(NSInteger)pageNum
{
    AFHTTPRequestOperationManager *detailListManager = [AFHTTPRequestOperationManager manager];
    
    NSString *signStr = [NSString stringWithFormat:@"%ld%@",(long)photoId,requestSecuKey];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"CommentList"                                    forKey:requestKey];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)photoId]  forKey:@"InterCode"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)pageNum]  forKey:@"PageIndex"];
    [params setObject:@"10"                                             forKey:@"PageSize"];
    [params setObject:[signStr md5String]                               forKey:requestKeySign];
    
    MJLog(@"请求照片评论列表signStr:%@\nparams:%@",signStr,params);
//    
//    [MMProgressHUD showWithTitle:@"正在连接" status:@"请稍后" cancelBlock:^{
//        [[detailListManager operationQueue] cancelAllOperations];
//        [MMProgressHUD dismiss];
//    }];
    
    [detailListManager POST:[SERVERADDRESS stringByAppendingString:@"V2/PhotoHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
//        [MMProgressHUD dismissWithSuccess:@"刷新成功"];
        NSDictionary *dic = responseObject;
        MJLog(@"请求照片评论列表-请求服务器成功%@",dic);
        NSInteger suc = [[dic objectForKey:@"retCode"] integerValue];
        if (suc == 1) {
            NSArray *resultArray = [dic objectForKey:@"retData"];
            NSArray *modelArray = [MJPhotoDetailUserCellModel photoDetailUserCellModelsWithArray:resultArray];
            if (self.pageNum == 1)
            {
                [self.listArray removeAllObjects];
                [self requestSuccessWithArray:modelArray];
            }
            else
            {
                [self requestSuccessWithArray:modelArray];
            }
            
            
        }
        else
        {
            MJLog(@"请求评论列表-请求失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
//        [MMProgressHUD dismissWithError:@"网络连接失败"];
        MJLog(@"请求照片评论列表-请求服务器失败%@",error);
    }];
    
    
}


- (void)requestSuccessWithArray:(NSArray *)array
{
     NSMutableArray *commentArray = [NSMutableArray array];
    for (MJPhotoDetailUserCellModel *userModel in array)
    {
        if (userModel.ParentId == 0) {
            [commentArray addObject:userModel];
        }
        else
        {
            userModel.Content = [NSString stringWithFormat:@"回复 %@:%@",userModel.ParentNickName,userModel.Content];
            [commentArray addObject:userModel];
            
        }
        
    }

    for (MJPhotoDetailUserCellModel *model in commentArray)
    {
        [self.listArray addObject:model];
    }
    
//    NSMutableArray *repeatArray = [NSMutableArray array];
   
    
//        MJLog(@"%@",commentArray);

    
    for (MJPhotoDetailUserCellModel *cellModel in self.listArray)
    {
        [self.photoDetailArray addObject:cellModel];
    }
    [self.tableView reloadData];
    if (self.commentNum == 2)
    {
        if (self.listArray.count > 1) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
}

#pragma mark - 自定义弹窗代理
/**
 *  自定义弹窗代理方法，点击no
 *
 *  @param customView
 *  @param sender
 */
- (void)mjcustomAlertView:(MJCustomAlertView *)customView didClickNoBtn:(id)sender
{
    MJLog(@"no");
    [customView removeFromSuperview];
}

#pragma mark - 自定义弹窗代理方法
/**
 *  自定义弹窗代理方法，点击yes
 *
 *  @param customView
 *  @param sender
 */
- (void)mjcustomAlertView:(MJCustomAlertView *)customView didClickYesBtn:(id)sender WithCommentId:(NSInteger)commentId
{
    MJLog(@"yes");
    [customView removeFromSuperview];
    AFHTTPRequestOperationManager *deleteManager = [AFHTTPRequestOperationManager manager];
    
    
    NSInteger userid = [[MJUserDefault objectForKey:userDefaultUserId] integerValue];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"Remove"                                             forKey:requestKey];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)userid]       forKey:@"Myid"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)commentId]    forKey:@"CommentId"];
    
    [deleteManager POST:[SERVERADDRESS stringByAppendingString:@"Handler/GetData.ashx?M=V2_DeleteComments"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        MJLog(@"%@",responseObject);
        NSInteger succe = [[dic objectForKey:@"IsSuccess"] integerValue];
        if (succe == 1) {
//            [self requestPhotoDetailWithPhotoId:self.imgId];
            [self headerRefreshed];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"%@",error);
    }];

    
    
    
}


#pragma mark - 底部评论toolbar代理

/**
 *  表情代理
 *
 *  @param bottomCommentV 底部评论toolbar
 *  @param faceBtn        表情按钮
 */
- (void)bottomCommentView:(MJBottomCommentView *)bottomCommentV didClickFaceBtn:(UIButton *)faceBtn
{
    MJLog(@"点击了表情");
    [systemWindow endEditing:YES];
    self.bottomView.sendBtn.enabled = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.facekeyBoard.y = systemSize.height - 220;
        self.bottomView.y = self.facekeyBoard.y - self.bottomView.bounds.size.height;
        self.bottomView.enablePlaceholder   = NO;
//        if ([UIScreen mainScreen].bounds.size.height <= self.facekeyBoard.y)
//        {
//            self.bottomView.enablePlaceholder   = NO;
//        }
//        else
//        {
//            self.bottomView.enablePlaceholder   = YES;
//        }

    }];

}

/**
 *  发送代理
 *
 *  @param bottomCommentV 底部评论toolbar
 *  @param sendBtn        发送按钮
 */
- (void)bottomCommentView:(MJBottomCommentView *)bottomCommentV didClickSendBtn:(UIButton *)sendBtn withStr:(NSString *)str withCommentId:(NSInteger)commentId
{
     MJLog(@"点击了发送");
    self.commentNum = 2;
    [systemWindow endEditing:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.facekeyBoard.y = systemSize.height;
        self.bottomView.y = self.facekeyBoard.y - self.bottomView.bounds.size.height;
        self.bottomView.nickStr = @"";
        self.bottomView.enablePlaceholder = NO;
    }];
    self.bottomView.commentLabel.text = @"";
    
    AFHTTPRequestOperationManager *sendManager = [AFHTTPRequestOperationManager manager];
    
    NSString *signStr;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"AddComment"                                         forKey:requestKey];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.imgId]   forKey:@"InterCode"];
    [params setObject:self.sendStr                                          forKey:@"Content"];
    if (!commentId)
    {
        [params setObject:@"0"                                              forKey:@"ParentID"];
        signStr = [NSString stringWithFormat:@"%ld0%@",(long)self.imgId,requestSecuKey];
    }
    else
    {
        [params setObject:[NSString stringWithFormat:@"%ld",(long)commentId] forKey:@"ParentID"];
        signStr = [NSString stringWithFormat:@"%ld%ld%@",(long)self.imgId,(long)commentId,requestSecuKey];
    }
    [params setObject:[signStr md5String]                                   forKey:requestKeySign];
    
    
    MJLog(@"添加评论signStr:%@\n%@",signStr,params);
    
    [sendManager POST:[SERVERADDRESS stringByAppendingString:@"V2/PhotoHandler.ashx?"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        MJLog(@"添加评论-连接服务器成功%@",dic);
        [self headerRefreshed];
        
        
//        MJLog(@"添加评论-添加失败：%@",[dic objectForKey:@"retMsg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"添加评论-连接服务器失败%@",error);
    }];
    
    
}

#pragma mark - 表情键盘代理
/**
 *  表情键盘点击表情代理方法
 *
 *  @param faceBtnImgStr 表情名称
 */
- (void)faceKeyBoardDidSelectedFaceBtnWithFaceBtnStr:(NSString *)faceBtnImgStr
{
    MJLog(@"点击了表情：%@",faceBtnImgStr);
    MJLog(@"senderStr%@",self.sendStr);
    self.sendStr = [self.sendStr stringByAppendingString:faceBtnImgStr];
    self.bottomView.commentLabel.attributedText = [NSString attributedTextWithText:self.sendStr];

}

#pragma mark - 文本框值改变
/**
 *  文本输入框值改变
 */
- (void)textFieldValueWillChange
{
//    NSString *attriubuteStr = [NSString stringTextWithAttributeStr:self.bottomView.commentLabel.attributedText];
//    NSString *text = [self.bottomView.commentLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self.sendStr isEqualToString:@""]) {
        self.bottomView.sendBtn.enabled = NO;
    }
    else
    {
        self.bottomView.sendBtn.enabled = YES;
    }
    self.sendStr = [NSString stringTextWithAttributeStr:self.bottomView.commentLabel.attributedText];
    MJLog(@"输入框变更通知%@",self.bottomView.commentLabel.text);
    MJLog(@"%@",self.sendStr);
}

#pragma mark - 当文本输入框值改变时，设置是否隐藏
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    NSString *attrubuteText = [NSString stringTextWithAttributeStr:textView.attributedText];
    if (![self.sendStr isEqualToString:@""])
    {
        self.bottomView.placeHolder.hidden = YES;
    }
    else
    {
        self.bottomView.placeHolder.hidden = NO;
    }
    return YES;
}


/**
 *  文本view代理
 *
 *  @param textView
 *  @param range
 *  @param text
 *
 *  @return
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSString *attrubuteText = [NSString stringTextWithAttributeStr:textView.attributedText];
    if (![text isEqualToString:@""])
    {
    
        self.bottomView.placeHolder.hidden = YES;
    
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        self.bottomView.placeHolder.hidden = NO;
        
    }
    
    return YES;
    
}



- (void)dealloc
{
    [MJNotifCenter removeObserver:self];
}

@end
