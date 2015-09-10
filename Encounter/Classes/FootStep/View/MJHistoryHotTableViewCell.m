//
//  MJHistoryHotTableViewCell.m
//  Encounter
//
//  Created by 李明军 on 17/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJHistoryHotTableViewCell.h"
#import "MJConst.h"
#import "MJHistoryHotSpotModel.h"

@interface MJHistoryHotTableViewCell()

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
/** 热点名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 内容 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** 标识 */
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@end


@implementation MJHistoryHotTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJHistoryHotTableViewCell" owner:self options:nil] lastObject];
    }
    return  self;
}

/**
 *  setter赋值
 *
 *  @param historyModel
 */
- (void)setHistoryModel:(MJHistoryHotSpotModel *)historyModel
{
    _historyModel = historyModel;
    
    self.nameLabel.text = _historyModel.PlaceName;
    
    
    if (self.inStr == kMJHistoryHotTableViewCellInStrCurrent)
    {
        self.signLabel.text = @"当前热点";
    }
    else
    {
        NSString *dateStr = [_historyModel.CreateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSString *date = [dateStr substringToIndex:19];
        MJLog(@"date%@",date);
                
        self.signLabel.text = [NSString caculateDateToNowWithDateStr:date];
        
    }
    
    
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_historyModel.Image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         self.headImgView.image = [UIImage circleImageWithImage:image borderColor:[UIColor clearColor] borderWidth:1];
     }];
    
    if (_historyModel.NickName && _historyModel.Content)
    {
        self.contentLabel.text = [NSString stringWithFormat:@"%@%@",_historyModel.NickName,_historyModel.Content];
    }
    else if (_historyModel.NickName && !_historyModel.Content)
    {
        self.contentLabel.text = [NSString stringWithFormat:@"%@",_historyModel.NickName];
    }
    else
    {
        self.contentLabel.text = @"";
    }

    
}

/**
 *  构造方法
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)historyHotTVCWithTableView:(UITableView *)tableView
{
    static NSString *historyHotCellId = @"historyHotCellId";
    
    MJHistoryHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyHotCellId];
    
    if (!cell) {
        cell = [[MJHistoryHotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyHotCellId];
    }
    return cell;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
