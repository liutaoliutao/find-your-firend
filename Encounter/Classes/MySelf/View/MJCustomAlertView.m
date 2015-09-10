//
//  MJCustomAlertView.m
//  Encounter
//
//  Created by 李明军 on 24/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJCustomAlertView.h"


@interface MJCustomAlertView()


@property (weak, nonatomic) IBOutlet UILabel *discLabel;


@end


@implementation MJCustomAlertView

- (instancetype)init
{
    if (self = [super init])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJCustomAlertView" owner:self options:nil] firstObject];
    }
    return self;
}

- (void)setLabelStr:(NSString *)labelStr
{
    _labelStr = labelStr;
    self.discLabel.text = _labelStr;
}

#pragma mark - 按钮点击事件
- (IBAction)yesBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(mjcustomAlertView:didClickYesBtn:WithCommentId:)]) {
        [self.delegate mjcustomAlertView:self didClickYesBtn:sender WithCommentId:self.commentId];
    }
}

- (IBAction)noBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(mjcustomAlertView:didClickNoBtn:)]) {
        [self.delegate mjcustomAlertView:self didClickNoBtn:sender];
    }
}

@end
