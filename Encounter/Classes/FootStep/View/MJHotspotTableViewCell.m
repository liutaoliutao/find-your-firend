//
//  MJHotspotTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 16/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJHotspotTableViewCell.h"
#import "MJHotSpotListModel.h"
#import "MJConst.h"

@interface MJHotspotTableViewCell()

/** 排名 */
@property (weak, nonatomic) IBOutlet UILabel *listNumLabel;
/** 热点名称 */
@property (weak, nonatomic) IBOutlet UILabel *hotNameLabel;
/** 距离 */
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation MJHotspotTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJHotspotTableViewCell" owner:self options:nil] firstObject];
    }
    return self;
}



- (void)setHotspotListModel:(MJHotSpotListModel *)hotspotListModel
{
    _hotspotListModel = hotspotListModel;
    self.listNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_hotspotListModel.Ranking];
    if (_hotspotListModel.Ranking == 1)
    {
        [self.listNumLabel setTextColor:MJColor(251, 10, 22)];
    }
    else if (_hotspotListModel.Ranking == 2)
    {
        [self.listNumLabel setTextColor:MJColor(252, 86, 10)];
    }
    else if (_hotspotListModel.Ranking == 3)
    {
        [self.listNumLabel setTextColor:MJColor(253, 138, 10)];
    }
    else
    {
        [self.listNumLabel setTextColor:MJColor(18, 105, 254)];
    }
    self.hotNameLabel.text = _hotspotListModel.PlaceName;
    double distance = _hotspotListModel.distance;
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2fkm",distance/1000];
}


/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)hotspotTabCellWithTableView:(UITableView *)tableView
{
    static NSString *hotspotTabCellId = @"hotspotTabCellId";
    
    MJHotspotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotspotTabCellId];
    if (!cell) {
        cell = [[MJHotspotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotspotTabCellId];
    }
    return cell;
}


@end
