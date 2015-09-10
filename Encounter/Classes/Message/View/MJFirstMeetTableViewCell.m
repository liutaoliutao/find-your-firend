//
//  MJFirstMeetTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 15/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJFirstMeetTableViewCell.h"
#import "MJFirstMeetModel.h"
#import "MJConst.h"


@interface MJFirstMeetTableViewCell()

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView    *headImgV;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;
/** 性别 */
@property (weak, nonatomic) IBOutlet UIButton       *sexBtn;
/** 描述 */
@property (weak, nonatomic) IBOutlet UILabel        *discLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel        *timeLabel;
/** 初遇热点 */
@property (weak, nonatomic) IBOutlet UILabel        *hotSpotLabel;
/** 小红点 */
@property (weak, nonatomic) IBOutlet UIImageView    *redImgV;

@end


@implementation MJFirstMeetTableViewCell

/**
 *  初始化
 *
 *  @param style
 *  @param reuseIdentifier
 *
 *  @return
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJFirstMeetTableViewCell" owner:self options:nil] lastObject];
        self.redImgV.hidden = YES;
    }
    return self;
}

/**
 *  setter方法赋值
 *
 *  @param firstMeetModel
 */
- (void)setFirstMeetModel:(MJFirstMeetModel *)firstMeetModel
{
    _firstMeetModel                 = firstMeetModel;
    self.nameLabel.text             = _firstMeetModel.Nickname;
    
//    NSDateFormatter *dateformatter  = [[NSDateFormatter alloc] init];
//    dateformatter.dateFormat        = @"yyyy/MM/dd HH:mm:ss";
//    MJLog(@"%@",_firstMeetModel.Lastlogintime);
//    NSDate *dat                     = [dateformatter dateFromString:_firstMeetModel.Lastmeettime];
//    dateformatter.dateFormat        = @"yyyy-MM-dd HH:mm:ss";
//    NSString *dateStr               = [dateformatter stringFromDate:dat];
    
    
    
    self.timeLabel.text             = [NSString caculateDateToNowWithDateStr:_firstMeetModel.Lastlogintime];
//    self.timeLabel.text = dateStr;
    self.hotSpotLabel.text          = _firstMeetModel.Lastmeetplace;
    
    
   
    switch (self.inStr)
    {
        case kMJFirstMeetTableViewCellInStrFirstMeet:
        {
            if (_firstMeetModel.Motto)
            {
                self.discLabel.text         = _firstMeetModel.Motto;
            }
            
            
            if (_firstMeetModel.MeetFirstIsRead)
            {
                //        [MJNotifCenter postNotificationName:@"firstMeetRedHidden" object:nil];
                self.redImgV.hidden = YES;
            }
            else
            {
                //        [MJNotifCenter postNotificationName:@"firstMeetRedNoHidden" object:nil];
                self.redImgV.hidden = NO;
            }

            break;
        }
        case kMJFirstMeetTableViewCellInStrRepeatMeet:
        {
            
               NSInteger mySexNum = [[MJUserDefault objectForKey:userDefaultSex] integerValue];
            
            if (_firstMeetModel.Sex == 0) {
                if (mySexNum == _firstMeetModel.Sex)
                {
                    self.discLabel.text = [NSString stringWithFormat:@"闺蜜值%ld（%ld次重逢）",
                                           (long)_firstMeetModel.LuckPrice,
                                           (long)_firstMeetModel.Meetnum];
                }
                else
                {
                    self.discLabel.text = [NSString stringWithFormat:@"缘分值%ld（%ld次重逢）",
                                           (long)_firstMeetModel.LuckPrice,
                                           (long)_firstMeetModel.Meetnum];
                }
            }
            else
            {
                if (mySexNum == _firstMeetModel.Sex)
                {
                    self.discLabel.text = [NSString stringWithFormat:@"基友值%ld（%ld次重逢）",
                                           (long)_firstMeetModel.LuckPrice,
                                           (long)_firstMeetModel.Meetnum];
                }
                else
                {
                    self.discLabel.text = [NSString stringWithFormat:@"缘分值%ld（%ld次重逢）",
                                           (long)_firstMeetModel.LuckPrice,
                                           (long)_firstMeetModel.Meetnum];
                }
            }
            
            if (_firstMeetModel.MeetAgainIsRead)
            {
                //        [MJNotifCenter postNotificationName:@"firstMeetRedHidden" object:nil];
                self.redImgV.hidden = YES;
            }
            else
            {
                //        [MJNotifCenter postNotificationName:@"firstMeetRedNoHidden" object:nil];
                self.redImgV.hidden = NO;
            }

            break;
        }
        default:
            break;
    }
        
    
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:_firstMeetModel.Headimg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.headImgV.image         = [UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
    }];
    
    if (_firstMeetModel.Sex == 0)
    {
        [self.sexBtn setImage:[UIImage imageNamed:@"sex_female_ico"]
                     forState:UIControlStateNormal];
        [self.sexBtn setImage:[UIImage imageNamed:@"sex_female_ico"]
                     forState:UIControlStateHighlighted];
        [self.sexBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_firstMeetModel.Age]
                     forState:UIControlStateNormal];
        [self.sexBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_firstMeetModel.Age]
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
        [self.sexBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_firstMeetModel.Age]
                     forState:UIControlStateNormal];
        [self.sexBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_firstMeetModel.Age]
                     forState:UIControlStateHighlighted];
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"sex_male_bg"]
                               forState:UIControlStateNormal];
        [self.sexBtn setBackgroundImage:[UIImage imageNamed:@"sex_male_bg"]
                               forState:UIControlStateHighlighted];
    }

}


- (void)firstMeetSetContentWithModel:(MJFirstMeetModel *)firstMeetModel
{
}

/**
 *  初遇cell构造方法
 *
 *  @param tableView tableview
 *
 *  @return
 */
+ (instancetype)firstMeetTVCellWithTableView:(UITableView *)tableView
{
    static NSString *firstMeetCellId = @"firstMeetCellId";
    
    MJFirstMeetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstMeetCellId];
    if (!cell) {
        cell = [[MJFirstMeetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstMeetCellId];
    }
    return cell;
    
}

@end
