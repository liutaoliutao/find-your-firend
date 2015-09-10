//
//  MJPersonLastTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 9/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJPersonLastTableViewCell.h"
#import "MJPersonCellModel.h"
#import "MJConst.h"

@interface MJPersonLastTableViewCell()

/** title */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 内容 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end


@implementation MJPersonLastTableViewCell

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJPersonLastTableViewCell"
                                              owner:self
                                            options:nil]
                lastObject];
    }
    return self;
}


/**
 *  setter方法赋值
 *
 *  @param personCellModel 
 */
- (void)setPersonCellModel:(MJPersonCellModel *)personCellModel
{
    _personCellModel            = personCellModel;
    if (![_personCellModel.title isEqualToString:@"个人资料"]) {
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentLabel setFont:[UIFont systemFontOfSize:14]];
    }
    else
    {
        [self.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentLabel setFont:[UIFont systemFontOfSize:17]];
    }
    self.titleLabel.text        = _personCellModel.title;
    self.contentLabel.text      = _personCellModel.content;
}


/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)latestTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *latestPhotoHeadCellId      = @"latestPhotoHeadCellId";
    MJPersonLastTableViewCell *cell             = [tableView dequeueReusableCellWithIdentifier:latestPhotoHeadCellId];
    if (!cell)
    {
        cell = [[MJPersonLastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:latestPhotoHeadCellId];
    }
    return cell;
    
}



@end
