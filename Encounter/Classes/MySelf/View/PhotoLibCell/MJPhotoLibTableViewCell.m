//
//  MJPhotoLibTableViewCell.m
//  Encounter
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJPhotoLibTableViewCell.h"
#import "MJConst.h"
#import "MJPhotoLibCellModel.h"
#import "UIImageView+WebCache.h"

@interface MJPhotoLibTableViewCell()

/** tag枚举 */
typedef enum
{
    kMJPhotoLibTableViewCellLeftPhotoImgView = 600,
    kMJPhotoLibTableViewCellRightPhotoImgView
}kMJPhotoLibTableViewCell;



#pragma mark - 左边部分控件
/** 左边时间 */
@property (weak, nonatomic) IBOutlet UILabel        *leftTimeLabel;
/** 左边照片 */
@property (weak, nonatomic) IBOutlet UIImageView    *leftPhotoImgView;
/** 左边描述 */
@property (weak, nonatomic) IBOutlet UILabel        *leftDiscLabel;
/** 左边热点 */
@property (weak, nonatomic) IBOutlet UILabel        *leftHotLabel;
@property (weak, nonatomic) IBOutlet UIButton       *leftDeleteBtn;

@property (weak, nonatomic) IBOutlet UIImageView *leftDeleteIck;



#pragma mark - 右边部分控件
/** 右边事件 */
@property (weak, nonatomic) IBOutlet UILabel        *rightTimeLabel;
/** 右边照片 */
@property (weak, nonatomic) IBOutlet UIImageView    *rightPhotoImgView;
/** 右边描述 */
@property (weak, nonatomic) IBOutlet UILabel        *rightDiscLabel;
/** 右边热点 */
@property (weak, nonatomic) IBOutlet UILabel        *rightHotLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *rightPointImgV;
@property (weak, nonatomic) IBOutlet UIImageView    *rightIcon;
@property (weak, nonatomic) IBOutlet UIButton       *rightDeleteBtn;

@property (weak, nonatomic) IBOutlet UIImageView    *rightDeleteIcon;


@end



@implementation MJPhotoLibTableViewCell

/**
 *  初始化加载xib
 *
 *  @param style           风格
 *  @param reuseIdentifier 可重用标示
 *
 *  @return self
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJPhotoLibTableViewCell"
                                              owner:self
                                            options:nil]
                lastObject];
        [self addTagToPhotoImgView];
        [self addGestureToPhoto];
    }
    return self;
}

/**
 *  为照片控件绑定tag
 */
- (void)addTagToPhotoImgView
{
    self.leftPhotoImgView.tag                       = kMJPhotoLibTableViewCellLeftPhotoImgView;
    self.rightPhotoImgView.tag                      = kMJPhotoLibTableViewCellRightPhotoImgView;
}

/**
 *  给照片添加点击手势
 */
- (void)addGestureToPhoto
{
    //  1.0 给左边照片添加点击手势
    UITapGestureRecognizer *leftTapGesture          = [[UITapGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(leftPhotoTapGesture)];
    self.leftPhotoImgView.userInteractionEnabled    = YES;
    [self.leftPhotoImgView addGestureRecognizer:leftTapGesture];
    
    
    //  2.0 给右边照片添加点击手势
    UITapGestureRecognizer *rightTapGesture         = [[UITapGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(rightPhotoTapGesture)];
    self.rightPhotoImgView.userInteractionEnabled   = YES;
    [self.rightPhotoImgView addGestureRecognizer:rightTapGesture];
}

/**
 *  左边照片点击事件处理方法
 */
- (void)leftPhotoTapGesture
{

    if ([self.delegate respondsToSelector:@selector(photoLibTableViewCell:tapImgView:withImgId:)])
    {
        [self.delegate photoLibTableViewCell:self
                                  tapImgView:self.leftPhotoImgView
                                   withImgId:self.leftCellModel.leftId];
    }
    MJLog(@"点击了左边photo");
}

/**
 *  右照片点击事件处理方法
 */
- (void)rightPhotoTapGesture
{

    if ([self.delegate respondsToSelector:@selector(photoLibTableViewCell:tapImgView:withImgId:)])
    {
        [self.delegate photoLibTableViewCell:self
                                  tapImgView:self.rightPhotoImgView
                                   withImgId:self.rightCellModel.rightId];
    }
    MJLog(@"点击了右边photo");
}


#pragma mark - 模型setter方法赋值
/**
 *  左边赋值
 *
 *  @param leftCellModel 左数据模型
 */
- (void)setLeftCellModel:(MJPhotoLibCellModel *)leftCellModel
{
    _leftCellModel              = leftCellModel;
    MJLog(@"%@",_leftCellModel.leftTimeStr);
    self.leftTimeLabel.text     = _leftCellModel.leftTimeStr;
//    [self.leftPhotoImgView sd_setImageWithURL:[NSURL URLWithString:_leftCellModel.leftImgUrlStr]];
    
    [self.leftPhotoImgView sd_setImageWithURL:[NSURL URLWithString:_leftCellModel.leftImgUrlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.leftPhotoImgView scaleImageForSelf:image];
    }];
    
    self.leftDiscLabel.text     = _leftCellModel.leftDiscStr;
    self.leftHotLabel.text      = _leftCellModel.leftHotStr;
    
    if (!self.rightCellModel.rightImgUrlStr)
    {
        self.rightTimeLabel.hidden      = YES;
        self.rightPhotoImgView.hidden   = YES;
        self.rightDiscLabel.hidden      = YES;
        self.rightHotLabel.hidden       = YES;
        self.rightDeleteBtn.hidden      = YES;
        self.rightDeleteIcon.hidden     = YES;
    }
    
}

/**
 *  右边赋值
 *
 *  @param rightCellModel 右数据模型
 */
- (void)setRightCellModel:(MJPhotoLibCellModel *)rightCellModel
{
    _rightCellModel                 = rightCellModel;
    self.rightPointImgV.hidden      = NO;
    self.rightIcon.hidden           = NO;
//    self.rightTimeLabel.hidden      = NO;
//    self.rightPhotoImgView.hidden   = NO;
//    self.rightDiscLabel.hidden      = NO;
//    self.rightHotLabel.hidden       = NO;
//    self.rightDeleteBtn.hidden      = NO;
//    self.rightDeleteIcon.hidden     = NO;
    MJLog(@"%@",_rightCellModel.rightTimeStr);
        self.rightTimeLabel.text    = _rightCellModel.rightTimeStr;
//        [self.rightPhotoImgView sd_setImageWithURL:[NSURL URLWithString:_rightCellModel.rightImgUrlStr]];
    
    [self.rightPhotoImgView sd_setImageWithURL:[NSURL URLWithString:_rightCellModel.rightImgUrlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.rightPhotoImgView scaleImageForSelf:image];
    }];
    
        self.rightDiscLabel.text    = _rightCellModel.rightDiscStr;
        self.rightHotLabel.text     = _rightCellModel.rightHotStr;
 
    

    
}

- (void)setInNum:(NSInteger)inNum
{
    _inNum = inNum;
    if (inNum == 0) {
        self.rightDeleteBtn.hidden = YES;
        self.leftDeleteBtn.hidden  = YES;
        self.rightDeleteIcon.hidden = YES;
        self.leftDeleteIck.hidden = YES;
    }
    else
    {
        self.rightDeleteBtn.hidden = NO;
        self.leftDeleteBtn.hidden  = NO;
        self.rightDeleteIcon.hidden = NO;
        self.leftDeleteIck.hidden = NO;
    }
}

#pragma mark - 自定义cell类方法
/**
 *  自定义cell类方法
 */
+ (instancetype)photoLibTableViewCellWithTableView:(UITableView *) tableView
{
    static NSString *photoLibCellId = @"photoLibCellId";
    MJPhotoLibTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:photoLibCellId];
    if (!cell) {
        cell                        = [[MJPhotoLibTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                    reuseIdentifier:photoLibCellId];
    }
    return cell;
}

- (IBAction)leftDeleteBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(photoLibTableViewCell:clickDeleteBtn:withModel:withId:)]) {
        [self.delegate photoLibTableViewCell:self clickDeleteBtn:sender withModel:self.leftCellModel withId:self.leftCellModel.leftId];
    }
}


- (IBAction)rightDeleteBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(photoLibTableViewCell:clickDeleteBtn:withModel:withId:)]) {
        [self.delegate photoLibTableViewCell:self clickDeleteBtn:sender withModel:self.rightCellModel withId:self.leftCellModel.leftId];
    }
}


@end
