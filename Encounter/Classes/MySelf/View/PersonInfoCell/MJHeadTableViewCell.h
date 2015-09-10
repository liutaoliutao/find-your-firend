//
//  MJHeadTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 9/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJHeadTableViewCell;
@protocol MJHeadTableViewCellDelegate <NSObject>

@optional

/**
 *  点击返回按钮代理
 *
 *  @param headTableViewCell
 *  @param btn
 */
- (void)headTableViewCell:(MJHeadTableViewCell *)headTableViewCell didClickReturnBtn:(UIButton *)btn;

/**
 *  点击更多按钮代理
 *
 *  @param headTableViewCell
 *  @param btn
 */
- (void)headTableViewCell:(MJHeadTableViewCell *)headTableViewCell didClickMoreBtn:(UIButton *)btn;




@end


@interface MJHeadTableViewCell : UITableViewCell

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 性别 */
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
/** 描述 */
@property (weak, nonatomic) IBOutlet UILabel *discLabel;

/** 字典 */
@property (nonatomic,strong) NSDictionary *dic;

/** 顶部按钮点击代理 */
@property (nonatomic,weak) id<MJHeadTableViewCellDelegate> delegate;


/**
 *  构造方法
 *
 *  @return
 */
+ (instancetype)headTableViewCellWithTableView:(UITableView *)tableView;


@end
