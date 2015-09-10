//
//  MJMyselfHeadTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 29/6/15.
//  Copyright (c) 2015年 AiTa. All rights reserved.
//

#import "MJMyselfHeadTableViewCell.h"
#import "MJConst.h"


@interface MJMyselfHeadTableViewCell()

/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
/** 头像图片 */
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
/** 昵称label */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 新消息view */
@property (weak, nonatomic) IBOutlet UIView *currentMessageV;
/** 新消息label */
@property (weak, nonatomic) IBOutlet UILabel *currentMessageLabel;
/** 新消息按钮 */
@property (weak, nonatomic) IBOutlet UIButton *currentMessageBtn;

@end


@implementation MJMyselfHeadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJMyselfHeadTableViewCell" owner:self options:nil] firstObject];
        UITapGestureRecognizer *bgTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgImgTagClick)];
        self.bgImgV.userInteractionEnabled = YES;
//        self.currentMessageLabel.textColor = systemColor;
        [self.bgImgV addGestureRecognizer:bgTapGes];
        
    }
    return self;
}


- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    NSString *headImgUrl = [_dic objectForKey:personInfoResultDicHeadimg];
    NSString *nameStr    = [_dic objectForKey:personInfoResultDicNickname];
    NSInteger currentMessageCount = [[_dic objectForKey:@"personInfoResultDicnotReadCount"] integerValue];
    NSString *bgImgStr   = [_dic objectForKey:personInfoResultDicBackImg];
    
    if (headImgUrl)
    {
       
        [self.headImgV sd_setImageWithURL:[NSURL URLWithString:headImgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.headImgV.image = [UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
        }];
    }
    else
    {
        [self.headImgV setImage:[UIImage circleImageWithImage:[UIImage imageNamed:@"user_head"]
                                                  borderColor:[UIColor clearColor]
                                                  borderWidth:1]];
    }
    
    self.nameLabel.text = nameStr;
    if (currentMessageCount > 0)
    {
        self.currentMessageV.hidden = NO;
        self.currentMessageLabel.hidden = NO;
        self.currentMessageBtn.hidden  = NO;
        self.currentMessageLabel.text = [NSString stringWithFormat:@"有%ld条新消息",(long)currentMessageCount];
    }
    else
    {
        self.currentMessageV.hidden = YES;
        self.currentMessageLabel.hidden = YES;
        self.currentMessageBtn.hidden  = YES;
    }
    
    if (bgImgStr)
    {
        [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:bgImgStr]];
//        [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:bgImgStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            self.bgImgV.image = [UIImage clipImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
//        }];
    }
    else
    {
        self.bgImgV.image = [UIImage imageNamed:@"user_top_bg"];
    }
}

/**
 *  新消息按钮点击事件
 *
 *  @param sender
 */
- (IBAction)currentMessageBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(myselfHeadTVC:didClickCurrentMessageBtn:)]) {
        [self.delegate myselfHeadTVC:self didClickCurrentMessageBtn:self.currentMessageBtn];
    }
}

/**
 *  点击切换背景图片
 */
- (void)bgImgTagClick
{
    if ([self.delegate respondsToSelector:@selector(myselfHeadTVC:didClickBgImgV:)]) {
        [self.delegate myselfHeadTVC:self didClickBgImgV:self.bgImgV];
    }
}

- (void)setBgImg:(UIImage *)bgImg
{
    _bgImg = bgImg;
    [self.bgImgV setImage:bgImg];
}

/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)myselfHeadTVCWithTableView:(UITableView *)tableView
{
    static NSString *myselfHeadCellId = @"myselfHeadCellId";
    
    MJMyselfHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myselfHeadCellId];
    
    if (!cell) {
        cell = [[MJMyselfHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:myselfHeadCellId];
    }

    return cell;
}



@end
