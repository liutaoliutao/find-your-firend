//
//  MJTextHotTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 17/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJTextHotTableViewCell.h"
#import "MJHotspotCellModel.h"
#import "MJConst.h"

@interface MJTextHotTableViewCell()

/** 头像 */
@property (nonatomic,strong) UIImageView *headImgV;
/** 时间label */
@property (nonatomic,strong) UILabel *timeLabel;
/** 内容label */
@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation MJTextHotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView *headImgV       = [[UIImageView alloc] init];
        UILabel     *timeLabel      = [[UILabel alloc] init];
        UILabel     *contentLabel   = [[UILabel alloc]init];
        
        
        self.headImgV               = headImgV;
        self.timeLabel              = timeLabel;
        self.contentLabel           = contentLabel;
        
        self.timeLabel.numberOfLines        = 0;
        self.contentLabel.numberOfLines     = 0;
        
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self.timeLabel setTextColor:[UIColor lightGrayColor]];
        
        [self.contentView addSubview:self.headImgV];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        
        UITapGestureRecognizer *headTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textHeadImgClick)];
        self.headImgV.userInteractionEnabled = YES;
        [self.headImgV addGestureRecognizer:headTapG];
    }
    return self;
}

- (void)setHotspotCellModel:(MJHotspotCellModel *)hotspotCellModel
{
    _hotspotCellModel           = hotspotCellModel;
    
    self.headImgV.frame         = _hotspotCellModel.textheadImgFrame;
    self.timeLabel.frame        = _hotspotCellModel.textTimeFrame;
    self.contentLabel.frame     = _hotspotCellModel.textContentFrame;
    
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:_hotspotCellModel.HeadImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.headImgV.image = [UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
    }];
    
//    self.timeLabel.text         = [NSString caculateDateToNowWithDateStr:_hotspotCellModel.Timer];
    self.timeLabel.text         = _hotspotCellModel.FormatTimer;
    
    NSAttributedString *attributeStr = [NSString attributedTextWithText:_hotspotCellModel.Content];
    
    [self.contentLabel setAttributedText:attributeStr];
//    self.contentLabel.text      = attributeStr;
}


/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)textHotTableViewCell:(UITableView *)tableView
{
    static NSString *textHotTVCellId = @"textHotTVCellId";
    MJTextHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textHotTVCellId];
    
    if (!cell) {
        cell = [[MJTextHotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textHotTVCellId];
    }
    return cell;
}

- (void)textHeadImgClick
{
    if ([self.delegate respondsToSelector:@selector(textHotTableViewCell:didClickHeadWithUserId:)]) {
        [self.delegate textHotTableViewCell:self didClickHeadWithUserId:[NSString stringWithFormat:@"%ld",(long)self.hotspotCellModel.UserId]];
    }
}



@end
