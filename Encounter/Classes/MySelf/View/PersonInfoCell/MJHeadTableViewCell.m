//
//  MJHeadTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 9/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJHeadTableViewCell.h"
#import "MJConst.h"

@interface MJHeadTableViewCell()

typedef enum
{
    kMJHeadTableViewCellTagReturn,
    kMJHeadTableViewCellTagMore
}kMJHeadTableViewCellTag;

/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
/** 更多按钮 */
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;



@end


@implementation MJHeadTableViewCell

/**
 *  初始化加载xib
 *
 *  @param style           风格
 *  @param reuseIdentifier
 *
 *  @return
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJHeadTableViewCell"
                                              owner:self
                                            options:nil]
                lastObject];
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_top_bg"]];
        
        [self setTagToBtn];
    }
    return self;
}

/**
 *  设置tag
 */
- (void)setTagToBtn
{
    self.returnBtn.tag  = kMJHeadTableViewCellTagReturn;
    self.moreBtn.tag    = kMJHeadTableViewCellTagMore;
}


/**
 *  返回按钮点击
 *
 *  @param sender
 */
- (IBAction)btnClick:(UIButton *)sender
{
    switch (sender.tag)
    {
        case kMJHeadTableViewCellTagReturn:
        {
            if ([self.delegate respondsToSelector:@selector(headTableViewCell:didClickReturnBtn:)])
            {
                [self.delegate headTableViewCell:self didClickReturnBtn:sender];
            }
            
            MJLog(@"点击了返回");
            break;
        }
        case kMJHeadTableViewCellTagMore:
        {
            if ([self.delegate respondsToSelector:@selector(headTableViewCell:didClickMoreBtn:)])
            {
                [self.delegate headTableViewCell:self didClickMoreBtn:sender];
            }
            MJLog(@"点击了更多");
            break;
        }
        default:
            break;
    }
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    NSString *headImgUrl = [dic objectForKey:personInfoResultDicHeadimg];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headImgUrl]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         self.headImgView.image = [UIImage circleImageWithImage:image
                                                        borderColor:[UIColor clearColor]
                                                        borderWidth:1];
     }];
    self.nameLabel.text         = [dic  objectForKey:personInfoResultDicNickname];
    [self setImageToSexBithSexStr:[dic     objectForKey:personInfoResultDicSex]];
    self.discLabel.text         = [dic  objectForKey:personInfoResultDicMotto];
}

/**
 *  更具性别做出加载
 *
 *  @param cell
 *  @param sexStr
 */
- (void)setImageToSexBithSexStr:(NSString *)sexStr
{
    NSInteger num = [sexStr integerValue];
    if (num == 1)
    {
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"sex_nan_bg"]  forState:UIControlStateNormal];
        [self.sexBtn setImage:[UIImage imageNamed:@"sex_male_ico"]          forState:UIControlStateNormal];
    }
    else
    {
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"sex_nv_bg"]  forState:UIControlStateNormal];
        [self.sexBtn setImage:[UIImage imageNamed:@"sex_female_ico"]       forState:UIControlStateNormal];
        
    }
}




/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)headTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *personHeadCellId   = @"personHeadCellId";
    MJHeadTableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:personHeadCellId];
    if (!cell)
    {
        cell = [[MJHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:personHeadCellId];
    }
    return cell;
    
}


@end
