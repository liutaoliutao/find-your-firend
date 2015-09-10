//
//  MJPhotoHotspotTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 18/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJPhotoHotspotTableViewCell.h"
#import "MJHotspotCellModel.h"
#import "MJConst.h"

@interface MJPhotoHotspotTableViewCell()

/** 头像 */
@property (strong, nonatomic)   UIImageView     *headImgV;
/** 照片 */
@property (strong, nonatomic)   UIImageView     *photoImgV;
/** 描述 */
@property (nonatomic,strong)    UILabel         *discLabel;
/** 时间 */
@property (nonatomic,strong)    UILabel         *timeLabel;


@end


@implementation MJPhotoHotspotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView *headImgView    = [[UIImageView alloc] init];
        UIImageView *photoImgView   = [[UIImageView alloc] init];
        UILabel     *discLabel      = [[UILabel alloc] init];
        UILabel     *timeLabel      = [[UILabel alloc] init];
        
        self.headImgV               = headImgView;
        self.photoImgV              = photoImgView;
        self.discLabel              = discLabel;
        self.timeLabel              = timeLabel;
        
        self.discLabel.numberOfLines = 0;
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.discLabel setFont:[UIFont systemFontOfSize:14]];
        [self.timeLabel setFont:[UIFont systemFontOfSize:12]];
        
        [self.discLabel setTextColor:[UIColor darkGrayColor]];
        [self.timeLabel setTextColor:[UIColor lightGrayColor]];
        
        
        [self.contentView addSubview:self.headImgV];
        [self.contentView addSubview:self.photoImgV];
        [self.contentView addSubview:self.discLabel];
        [self.contentView addSubview:self.timeLabel];
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImgClick)];
        UITapGestureRecognizer *headTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapClick)];
        
        self.photoImgV.userInteractionEnabled = YES;
        [self.photoImgV addGestureRecognizer:tapGest];
        
        self.headImgV.userInteractionEnabled = YES;
        [self.headImgV addGestureRecognizer:headTapGes];
        
        
        
    }
    return self;
}


- (void)setHotspotCellModel:(MJHotspotCellModel *)hotspotCellModel
{
    _hotspotCellModel = hotspotCellModel;
    
    
    self.headImgV.frame     = _hotspotCellModel.photoHeadImgFrame;
    self.timeLabel.frame    = _hotspotCellModel.photoTimeFrame;
    self.photoImgV.frame    = _hotspotCellModel.photoImgFrame;
    self.discLabel.frame    = _hotspotCellModel.photoDiscFrame;
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:_hotspotCellModel.HeadImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.headImgV.image = [UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
    }];
    
    [self.photoImgV sd_setImageWithURL:[NSURL URLWithString:_hotspotCellModel.PhotoUrl]];
    
    
    if (_hotspotCellModel.Content)
    {
        self.discLabel.text = _hotspotCellModel.Content;
    }
    else
    {
        self.discLabel.text = @"分享了一张照片";
    }
    
//    self.timeLabel.text = [NSString caculateDateToNowWithDateStr:_hotspotCellModel.Timer];
    
    self.timeLabel.text     = _hotspotCellModel.FormatTimer;
    
}


/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)photoHotspotTVCellWithTableView:(UITableView *)tableView
{
    static NSString *photoHotspotCellId = @"photoHotspotCellId";
    MJPhotoHotspotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photoHotspotCellId];
    
    if (!cell)
    {
        cell = [[MJPhotoHotspotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoHotspotCellId];
    }
    return cell;
}


- (void)headImgClick
{
    if ([self.delegate respondsToSelector:@selector(photoHotspotTVC:didClickPhotoWithImgId:WithUserId:)]) {
        [self.delegate photoHotspotTVC:self didClickPhotoWithImgId:self.hotspotCellModel.PhotoId WithUserId:[NSString stringWithFormat:@"%ld",(long)self.hotspotCellModel.UserId]];
    }
}

- (void)headTapClick
{
    if ([self.delegate respondsToSelector:@selector(photoHotspotTVC:didClickHeadWithUserId:)]) {
        [self.delegate photoHotspotTVC:self didClickHeadWithUserId:[NSString stringWithFormat:@"%ld",(long)self.hotspotCellModel.UserId]];
    }
}

@end
