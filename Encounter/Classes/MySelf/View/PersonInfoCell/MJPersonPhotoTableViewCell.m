//
//  MJPersonPhotoTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 9/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJPersonPhotoTableViewCell.h"
#import "MJConst.h"

@interface MJPersonPhotoTableViewCell()

/** 第一张 */
@property (weak, nonatomic) IBOutlet UIImageView *firstPImgV;
/** 第二张 */
@property (weak, nonatomic) IBOutlet UIImageView *seconPImgV;
/** 第三张 */
@property (weak, nonatomic) IBOutlet UIImageView *thirdImgV;
/** 第四张 */
@property (weak, nonatomic) IBOutlet UIImageView *forthImgV;
/** 第五张 */
@property (weak, nonatomic) IBOutlet UIImageView *fifthImgV;

@end


@implementation MJPersonPhotoTableViewCell

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJPersonPhotoTableViewCell"
                                              owner:self
                                            options:nil]
                lastObject];
    }
    return self;
}

/**
 *  setter方法设置相册
 *
 *  @param photoUrlStrArray
 */
- (void)setPhotoUrlStrArray:(NSArray *)photoUrlStrArray
{
    _photoUrlStrArray = photoUrlStrArray;
    for (NSInteger i = 0; i < 5; i++)
    {
        if (_photoUrlStrArray[0])
        {
            [self.firstPImgV sd_setImageWithURL:[NSURL URLWithString:_photoUrlStrArray[0]]];
        }
        if (_photoUrlStrArray.count > 1)
        {
            [self.seconPImgV sd_setImageWithURL:[NSURL URLWithString:_photoUrlStrArray[1]]];
        }
        if (_photoUrlStrArray.count > 2)
        {
            [self.thirdImgV sd_setImageWithURL:[NSURL URLWithString:_photoUrlStrArray[2]]];
        }
        if (_photoUrlStrArray.count > 3)
        {
            [self.forthImgV sd_setImageWithURL:[NSURL URLWithString:_photoUrlStrArray[3]]];
        }
        if (_photoUrlStrArray.count > 4)
        {
            [self.fifthImgV sd_setImageWithURL:[NSURL URLWithString:_photoUrlStrArray[4]]];
        }
    }
}


/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)photoTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *personPhotoHeadCellId   = @"personPhotoHeadCellId";
    MJPersonPhotoTableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:personPhotoHeadCellId];
    if (!cell)
    {
        cell = [[MJPersonPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:personPhotoHeadCellId];
    }
    return cell;
    
}

/**
 *  按钮点击
 *
 *  @param sender
 */
- (IBAction)btnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(personPhotoTVC:didClickBtn:withUserId:withDic:)]) {
        [self.delegate personPhotoTVC:self didClickBtn:sender withUserId:self.userid withDic:self.dic];
    }
}


@end
