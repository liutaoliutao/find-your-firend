
//
//  MJPhotDetailTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 28/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJPhotDetailTableViewCell.h"
#import "UIImage+CZ.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoDetailUserCellModel.h"
#import "MJConst.h"

@interface MJPhotDetailTableViewCell()
/** 用户头像            */
@property (weak, nonatomic) IBOutlet UIImageView    *headImgView;
/** 热点信息            */
@property (weak, nonatomic) IBOutlet UILabel        *hotMessageLabel;
/** 时间label          */
@property (weak, nonatomic) IBOutlet UILabel        *timeLabel;
/** 一句话label         */
@property (weak, nonatomic) IBOutlet UILabel        *discLabel;
/** 图片消息图片         */
@property (weak, nonatomic) IBOutlet UIImageView    *imgMessageImgView;
/** 评论数量label       */
@property (weak, nonatomic) IBOutlet UILabel        *commentNumLabel;
/** 评论按钮            */
@property (weak, nonatomic) IBOutlet UIButton       *commentBtn;
/** 赞数量label         */
@property (weak, nonatomic) IBOutlet UILabel        *goodLabel;
/** 点赞按钮            */
@property (weak, nonatomic) IBOutlet UIButton       *goodBtn;



/** 蒙版view */
//@property (nonatomic,weak) UIView *maskingView;
///** 蒙版图片 */
//@property (nonatomic,weak) UIImageView *maskingImgView;
//
@property(nonatomic, unsafe_unretained)CGFloat currentScale;
@end


@implementation MJPhotDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJPhotDetailTableViewCell" owner:self options:nil] firstObject];
        [self addGestureToControl];
    }
    return self;
}

#pragma mark - 图片和头像手势
/**
 *  为图片和头像添加点击手势
 */
- (void)addGestureToControl
{
    //  1.0 头像添加点击事件
    UITapGestureRecognizer *headImgTapGesture       = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                             action:@selector(headImgViewClick)];
    self.headImgView.userInteractionEnabled         = YES;
    [self.headImgView addGestureRecognizer:headImgTapGesture];
    
    //  2.0 图片添加点击事件
    UITapGestureRecognizer *imgMessageTapGesture    = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                             action:@selector(imgMessageClick)];
    self.imgMessageImgView.userInteractionEnabled   = YES;
    [self.imgMessageImgView addGestureRecognizer:imgMessageTapGesture];
}

/**
 *  头像点击事件
 */
- (void)headImgViewClick
{
    if ([self.delegate respondsToSelector:@selector(photoDetailTVC:didClickHeadImgView:)])
    {
        [self.delegate photoDetailTVC:self didClickHeadImgView:self.headImgView];
    }
}

/**
 *  图片点击事件
 */
- (void)imgMessageClick
{
    [systemWindow endEditing:YES];
    [self addMaskingControl];
}

- (void)addMaskingControl
{
    //  1.0 添加蒙版
    UIView *maskingView             = [[UIView alloc]init];
    maskingView.frame               = [UIScreen mainScreen].bounds;
    maskingView.backgroundColor     = [UIColor blackColor];
    maskingView.alpha               = 0.6;
    [systemWindow addSubview:maskingView];
    self.maskingView                = maskingView;
    
    //  2.0 设置蒙版图
    UIImageView *maskingImgV        = [[UIImageView alloc]init];
    maskingImgV.image               = self.imgMessageImgView.image;
    CGRect rect                     = self.imgMessageImgView.bounds;
    
    //  3.0 设置蒙版图动画效果
    CGFloat maskingX                = (systemSize.width - rect.size.width) * 0.5;
    CGFloat maskingY                = (systemSize.height - rect.size.height) * 0.5;
    maskingImgV.frame               = CGRectMake(maskingX, maskingY, rect.size.width, rect.size.height);
    maskingImgV.contentMode         = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTapGesture)];
    [maskingImgV addGestureRecognizer:maskTap];
    [systemWindow addSubview:maskingImgV];
    self.maskingImgView             = maskingImgV;
    
    
//    [UIView animateWithDuration:3 animations:^{
//        CGFloat maskingH            = systemSize.width - rect.size.width + rect.size.height;
        if (self.imgMessageImgView.image.size.height > self.imgMessageImgView.image.size.width)
        {
            maskingImgV.bounds           = CGRectMake(0, 0,  systemSize.width, systemSize.height);
        }
        else
        {
            maskingImgV.bounds           = CGRectMake(0, (systemSize.width - rect.size.height) * 0.5,systemSize.width , rect.size.height);
        }
        
        
//    }];

    
    //  4.0 添加点击手势
    UITapGestureRecognizer *maskingVTapGesture      = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                        action:@selector(maskingVClik)];
    [maskingView addGestureRecognizer:maskingVTapGesture];
    
    UILongPressGestureRecognizer *longPressGesture  = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(maskingImgVLongPress)];
    maskingImgV.userInteractionEnabled              = YES;
    [maskingImgV addGestureRecognizer:longPressGesture];
    
    
    //  5.0 添加缩放手势
    UIPinchGestureRecognizer *pinchGesture          = [[UIPinchGestureRecognizer alloc]initWithTarget:self
                                                                                               action:@selector(maskingImgPinch:)] ;
    [maskingImgV addGestureRecognizer:pinchGesture];
    
    
    
}

/**
 *  蒙版view点击事件
 */
- (void)maskingVClik
{
    MJLog(@"点击了蒙版view");
    [self.maskingView removeFromSuperview];
    [self.maskingImgView removeFromSuperview];
}

/**
 *  图像点击
 */
- (void)maskingImgVLongPress
{
    MJLog(@"点击了图片");
//    UIActionSheet *saveImgActionSheet = [[UIActionSheet alloc]initWithTitle:@"保存图片"
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"取消"
//                                                     destructiveButtonTitle:nil
//                                                          otherButtonTitles:@"确定",nil];
//    [saveImgActionSheet showInView:systemWindow];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [[[UIAlertView alloc]initWithTitle:@"保存图片"
//                                   message:@"是否保存图片"
//                                  delegate:self
//                         cancelButtonTitle:@"取消"
//                         otherButtonTitles:@"确定", nil]
//         show];
//    });
    
    
    if ([self.delegate respondsToSelector:@selector(photoDetailTVC:didClickImgMessageView:)])
    {
        [self.delegate photoDetailTVC:self didClickImgMessageView:self.imgMessageImgView];
    }

}

/**
 *  缩放手势
 */
- (void)maskingImgPinch:(UIPinchGestureRecognizer *)pinchGesture
{
    if (pinchGesture.state == UIGestureRecognizerStateEnded) {
        self.currentScale = pinchGesture.scale;
    }else if(pinchGesture.state == UIGestureRecognizerStateBegan && self.currentScale != 0.0f){
        pinchGesture.scale = self.currentScale;
    }
    if (pinchGesture.scale !=NAN && pinchGesture.scale != 0.0) {
        pinchGesture.view.transform = CGAffineTransformMakeScale(pinchGesture.scale, pinchGesture.scale);
    }
}

- (void)maskTapGesture
{
    [self.maskingView removeFromSuperview];
    [self.maskingImgView removeFromSuperview];
}


#pragma mark - setter方法设置内容
/**
 *  模型setter方法设置内容
 *
 *  @param pthoDetailUserCellModel 模型数据
 */
- (void)setPthoDetailUserCellModel:(MJPhotoDetailUserCellModel *)pthoDetailUserCellModel
{
    _pthoDetailUserCellModel            = pthoDetailUserCellModel;
    
    //  1.0 设置头像图片
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_pthoDetailUserCellModel.HeadImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage *headImg                = [UIImage circleImageWithImage:image borderColor:nil borderWidth:0];
        self.headImgView.image          = headImg;
    }];
    
    //  2.0 设置内容
    self.hotMessageLabel.text           = [NSString stringWithFormat:@"%@:%@",_pthoDetailUserCellModel.NickName,_pthoDetailUserCellModel.Place];
    MJLog(@"%@",self.hotMessageLabel.text);
    self.timeLabel.text                 = _pthoDetailUserCellModel.Timer;
    self.discLabel.text                 = _pthoDetailUserCellModel.Describe;
    
    
    [self.imgMessageImgView sd_setImageWithURL:[NSURL URLWithString:_pthoDetailUserCellModel.PhotoImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSString *imagePaht = [UIImage saveImgInDocumentWithImg:image WithName:@"savePhotoDetailImage"];
        [MJUserDefault setObject:imagePaht forKey:@"savePhotoDetailImage"];
    }];
    self.commentNumLabel.text           = [NSString stringWithFormat:@"%ld",(long)_pthoDetailUserCellModel.CommentCount];
    self.goodLabel.text                 = [NSString stringWithFormat:@"%ld",(long)_pthoDetailUserCellModel.SupportCount];
    if (_pthoDetailUserCellModel.IsPraise)
    {
        self.goodBtn.selected = NO;
        self.goodBtn.enabled  = NO;
    }
    else
    {
        self.goodBtn.selected = YES;
        self.goodBtn.enabled  =  YES;
    }
}


#pragma mark - 按钮点击

/**
 *  按钮点击事件
 *
 *  @param sender 点击的按钮
 */
- (IBAction)buttonClick:(UIButton *)sender
{
    
    self.goodBtn.selected       = NO;
    if ([self.delegate respondsToSelector:@selector(photoDetailTVC:didClickgoodBtn:withImgId:)]) {
        [self.delegate photoDetailTVC:self didClickgoodBtn:sender withImgId:self.pthoDetailUserCellModel.PhotoId];
    }
}


/**
 *  可重用tableViewCell
 *
 *  @param tableView tableView
 *
 *  @return cell
 */
+ (instancetype)photoDetailTableViewCellWithTableView:(UITableView *) tableView
{
    static NSString *detailCellId       = @"detailCellId";
    MJPhotDetailTableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:detailCellId];
    if (!cell) {
        cell                            = [[MJPhotDetailTableViewCell alloc]
                                           initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:detailCellId];
    }
    return cell;
}


#pragma mark - 底部弹窗代理
///**
// *  底部弹窗代理
// *
// *  @param actionSheet 底部弹窗
// *  @param buttonIndex 按钮索引
// */
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex)
//    {
//        case 0:
//        {
//            [actionSheet removeFromSuperview];
//            MJLog(@"从相册选举");
//            break;
//        }
//        default:
//            break;
//    }
//}


@end
