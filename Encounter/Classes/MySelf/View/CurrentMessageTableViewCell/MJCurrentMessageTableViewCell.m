//
//  MJCurrentMessageTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 27/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJCurrentMessageTableViewCell.h"
#import "MJCurrentMessageCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+CZ.h"
#import "MJConst.h"

@interface MJCurrentMessageTableViewCell()

/** 头像imgView           */
@property (nonatomic,weak) UIImageView  *headImgV;
/** 热点图片imgView        */
@property (nonatomic,weak) UIImageView  *hotImgV;
/** 标题label             */
@property (nonatomic,weak) UILabel      *titleLabel;
/** 事件label             */
@property (nonatomic,weak) UILabel      *timeLabel;
/** 评论label             */
@property (nonatomic,weak) UILabel      *commentLabel;
/** 足迹描述label          */
@property (nonatomic,weak) UILabel      *footDisclabel;

@end



@implementation MJCurrentMessageTableViewCell

/**
 *  初始化加载自定义控件
 *
 *  @param style           style
 *  @param reuseIdentifier 可重用标识
 *
 *  @return 返回self
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addCustomControl];
    }
    return self;
}


#pragma mark - 加载自定义控件
/**
 *  加载自定义控件
 */
- (void)addCustomControl
{
    //  1.0 初始化控件对象
    UIImageView *headImgV               = [[UIImageView alloc]init];
    UIImageView *hotImgV                = [[UIImageView alloc]init];
    UILabel *titleLabel                 = [[UILabel alloc]init];
    UILabel *timeLabel                  = [[UILabel alloc]init];
    UILabel *commentLabel               = [[UILabel alloc]init];
    UILabel *footDiscLabel              = [[UILabel alloc]init];
    
    
    commentLabel.numberOfLines          = 2;
    commentLabel.lineBreakMode          = NSLineBreakByWordWrapping;
    commentLabel.font                   = [UIFont systemFontOfSize:14];
    commentLabel.textColor              = [UIColor grayColor];
    
    commentLabel.font                   = [UIFont systemFontOfSize:12];
    titleLabel.font                     = [UIFont systemFontOfSize:14];
    timeLabel.font                      = [UIFont systemFontOfSize:10];
    footDiscLabel.font                  = [UIFont systemFontOfSize:12];
    
    //  2.0 将控件添加到内容view上
    [self.contentView addSubview:headImgV];
    [self.contentView addSubview:hotImgV];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:commentLabel];
    [self.contentView addSubview:footDiscLabel];
    
    //  3.0 将对象添加到全局
    self.headImgV                       = headImgV;
    self.hotImgV                        = hotImgV;
    self.titleLabel                     = titleLabel;
    self.timeLabel                      = timeLabel;
    self.commentLabel                   = commentLabel;
    self.footDisclabel                  = footDiscLabel;
}

/**
 *  setter方法设置frame和值
 *
 *  @param currentModel 传入模型
 */
- (void)setCurrentModel:(MJCurrentMessageCellModel *)currentModel
{
    _currentModel = currentModel;
    self.headImgV.frame                 = _currentModel.headImgFrame;
    self.hotImgV.frame                  = _currentModel.hotImgFrame;
    self.titleLabel.frame               = _currentModel.titleLabelFrame;
    self.timeLabel.frame                = _currentModel.timeLabelFrame;
    self.commentLabel.frame             = _currentModel.commentLabelFrame;
    self.footDisclabel.frame            = _currentModel.footDiscLabelFrame;
    
    
    
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:_currentModel.headimg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.headImgV.image             = [UIImage circleImageWithImage:image borderColor:nil borderWidth:0];
    }];
    [self.hotImgV sd_setImageWithURL:[NSURL URLWithString:_currentModel.photourl]];
    self.titleLabel.text                = _currentModel.nickname;
    self.timeLabel.text                 = _currentModel.timer;
//    self.commentLabel.text              = _currentModel.content;
    [self.commentLabel setAttributedText:[NSString attributedTextWithText:_currentModel.content]];
    self.footDisclabel.text = _currentModel.photodescribe;
    
}


/**
 *  加载cell类方法
 *
 *  @return 返回cell
 */
+ (instancetype)currentMessageTableViewCellWithTableView:(UITableView *) tableView
{
    static NSString *currentCellId             = @"cellID";
    MJCurrentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:currentCellId];
    if (!cell) {
        cell                            = [[MJCurrentMessageTableViewCell alloc]
                                           initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:currentCellId];
    }
    return cell;
}


@end
