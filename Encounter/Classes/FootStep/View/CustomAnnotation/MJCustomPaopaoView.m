//
//  MJCustomPaopaoView.m
//  Encounter
//
//  Created by mac on 15/5/31.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJCustomPaopaoView.h"
#import "MJConst.h"

@interface MJCustomPaopaoView()
/** 上标 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 下标 */
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@end

@implementation MJCustomPaopaoView


- (instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"MJCustomPaopaoView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title                  = title;
    if (!_title)            return;
    self.titleLabel.text    = _title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    _subtitle               = subtitle;
    if (!_subtitle)         return;
    self.subtitleLabel.text = _subtitle;
}


- (void)setHeadImgUrlStr:(NSString *)headImgUrlStr
{
    _headImgUrlStr          = headImgUrlStr;
    if (!_headImgUrlStr)    return;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_headImgUrlStr]];
}

//- (void)setTimeStr:(NSString *)timeStr
//{
//    _timeStr                = timeStr;
//    if (!_timeStr)          return;
//    self.timeLabel.text     = _timeStr;
//}


@end
