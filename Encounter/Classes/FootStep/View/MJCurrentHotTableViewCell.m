//
//  MJCurrentHotTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 30/6/15.
//  Copyright (c) 2015年 AiTa. All rights reserved.
//

#import "MJCurrentHotTableViewCell.h"
#import "MJConst.h"
#import "MJHotSpotListModel.h"


@interface MJCurrentHotTableViewCell()

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
/** 距离 */
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
/** 热点文字 */
@property (weak, nonatomic) IBOutlet UILabel *hotStrLabel;

@end



@implementation MJCurrentHotTableViewCell

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
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJCurrentHotTableViewCell" owner:self options:nil] firstObject];
    }
    return self;
}


- (void)setHotListModel:(MJHotSpotListModel *)hotListModel
{
    _hotListModel = hotListModel;
    
    if (_hotListModel.distance) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%0.2fkm",(double)(_hotListModel.distance/1000)];
    }
    
    self.hotStrLabel.text   = _hotListModel.PlaceName;
    [NSString stringWithFormat:@"%@",_hotListModel.Image];
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:_hotListModel.Image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.headImgV.image = [UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
    }];
}

/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)currentHotTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *currentHotTableViewCellId = @"currentHotTableViewCellId";
    
    MJCurrentHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:currentHotTableViewCellId];
    
    if (!cell)
    {
        cell = [[MJCurrentHotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currentHotTableViewCellId];
    }
    return cell;
    
}


@end
