//
//  MJPhotoCommentTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 28/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJPhotoCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoDetailUserCellModel.h"
#import "UIImage+CZ.h"
#import "MJConst.h"

@interface MJPhotoCommentTableViewCell()

/** 头像 */
@property (nonatomic,weak) UIImageView      *headImgView;
/** 昵称 */
@property (nonatomic,weak) UILabel          *nameLabel;
/** 时间 */
@property (nonatomic,weak) UILabel          *timeLabel;
/** 评论 */
@property (nonatomic,weak) UILabel          *commentLabel;


@end


@implementation MJPhotoCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addControl];
    }
    return self;
}


#pragma mark - 加载控件

/**
 *  加载控件
 */
- (void)addControl
{
    UIImageView *headImgView    = [[UIImageView alloc]init];
    UILabel * nameLabel         = [[UILabel alloc]init];
    UILabel *timeLabel          = [[UILabel alloc]init];
    UILabel *commentLabel       = [[UILabel alloc]init];
    
    
    commentLabel.numberOfLines  = 0;
    commentLabel.lineBreakMode  = NSLineBreakByWordWrapping;
    commentLabel.font           = [UIFont systemFontOfSize:14];
    commentLabel.textColor      = [UIColor darkGrayColor];
    
    timeLabel.font              = [UIFont systemFontOfSize:10];
    timeLabel.textColor         = [UIColor grayColor];
    timeLabel.textAlignment     = NSTextAlignmentRight;
    
    
    [self.contentView addSubview:headImgView];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:commentLabel];
    
    self.headImgView            = headImgView;
    self.nameLabel              = nameLabel;
    self.timeLabel              = timeLabel;
    self.commentLabel           = commentLabel;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImg)];
    self.headImgView.userInteractionEnabled = YES;
    [self.headImgView addGestureRecognizer:tapGesture];
    
}

- (void)clickHeadImg
{
    if ([self.delegate respondsToSelector:@selector(photoCommentTVC:didClickImgWithUserId:)]) {
        [self.delegate photoCommentTVC:self didClickImgWithUserId:self.phtoDetailUserCellModel.UserId];
    }
}

/**
 *  setter方法设置值
 *
 *  @param phtoDetailUserCellModel 模型数据
 */
- (void)setPhtoDetailUserCellModel:(MJPhotoDetailUserCellModel *)phtoDetailUserCellModel
{
    _phtoDetailUserCellModel            = phtoDetailUserCellModel;
    
    //  1.0 设置frame
    self.headImgView.frame              = _phtoDetailUserCellModel.headImgFrame;
    self.nameLabel.frame                = _phtoDetailUserCellModel.nameFrame;
    self.timeLabel.frame                = _phtoDetailUserCellModel.timeFrame;
    self.commentLabel.frame             = _phtoDetailUserCellModel.commentFrame;
    
    
    
    //  2.0 赋值
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_phtoDetailUserCellModel.HeadImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage *headImg                = [UIImage circleImageWithImage:image borderColor:nil borderWidth:0];
        self.headImgView.image          = headImg;
    }];
    
    self.nameLabel.text                 = _phtoDetailUserCellModel.NickName;
    self.timeLabel.text                 = _phtoDetailUserCellModel.Timer;
//    self.commentLabel.text              = _phtoDetailUserCellModel.Content;
    [self.commentLabel setAttributedText:[NSString attributedTextWithText:_phtoDetailUserCellModel.Content]];
    
    
}


/**
 *  可重用tableViewCell
 *
 *  @param tableView tableView
 *
 *  @return cell
 */
+ (instancetype)photoCommentTableViewCellWithTableView:(UITableView *) tableView
{
    static NSString *commentCellId      = @"commentCellId";
    MJPhotoCommentTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:commentCellId];
    if (!cell) {
        cell                            = [[MJPhotoCommentTableViewCell alloc]
                                           initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:commentCellId];
    }
    return cell;
}


@end
