//
//  MJGuanzhuTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 15/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJGuanzhuTableViewCell.h"
#import "MJGuanZhuPersonModel.h"
#import "MJConst.h"


@interface MJGuanzhuTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *discLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@end


@implementation MJGuanzhuTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJGuanzhuTableViewCell" owner:self options:nil] firstObject];
        
        UITapGestureRecognizer *headTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImgTapRegesture)];
        [self.headImgV addGestureRecognizer:headTapGesture];
        self.headImgV.userInteractionEnabled = YES;
    }
    return self;
}

/**
 *  头像点击事件
 */
- (void)headImgTapRegesture
{
    if ([self.delegate respondsToSelector:@selector(guanzhuTableViewCell:didSelectedHeadimg:)])
    {
        [self.delegate guanzhuTableViewCell:self didSelectedHeadimg:self.headImgV];
    }
}


/**
 *  setter方法赋值
 *
 *  @param guanzhuModel 
 */
- (void)setGuanzhuModel:(MJGuanZhuPersonModel *)guanzhuModel
{
    _guanzhuModel = guanzhuModel;
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:_guanzhuModel.Headimg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.headImgV setImage:[UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1]];
    }];
    
    self.nameLabel.text = _guanzhuModel.Nickname;
    self.timeLabel.text = [NSString caculateDateToNowWithDateStr:_guanzhuModel.Lastlogintime];
 
    if (_guanzhuModel.Sex == 0)
    {
        [self.sexBtn setImage:[UIImage imageNamed:@"sex_female_ico"]
                     forState:UIControlStateNormal];
        [self.sexBtn setImage:[UIImage imageNamed:@"sex_female_ico"]
                     forState:UIControlStateHighlighted];
        [self.sexBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_guanzhuModel.Age]
                     forState:UIControlStateNormal];
        [self.sexBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_guanzhuModel.Age]
                     forState:UIControlStateHighlighted];
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"sex_female_bg"]
                               forState:UIControlStateNormal];
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"sex_female_bg"]
                               forState:UIControlStateHighlighted];
        
    }
    else
    {
        [self.sexBtn setImage:[UIImage imageNamed:@"sex_male_ico"]
                     forState:UIControlStateNormal];
        [self.sexBtn setImage:[UIImage imageNamed:@"sex_male_ico"]
                     forState:UIControlStateHighlighted];
        [self.sexBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_guanzhuModel.Age]
                     forState:UIControlStateNormal];
        [self.sexBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_guanzhuModel.Age]
                     forState:UIControlStateHighlighted];
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"sex_male_bg"]
                               forState:UIControlStateNormal];
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"sex_male_bg"]
                               forState:UIControlStateHighlighted];
    }
    
    
    if (_guanzhuModel.Motto)
    {
        self.discLabel.text = _guanzhuModel.Motto;
    }
}


/**
 *  tableView构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)guanzhuTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *guanzhuCellId = @"guanzhuCellId";
    
    MJGuanzhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:guanzhuCellId];
    
    if (!cell) {
        cell = [[MJGuanzhuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:guanzhuCellId];
    }
    return cell;
}


@end
