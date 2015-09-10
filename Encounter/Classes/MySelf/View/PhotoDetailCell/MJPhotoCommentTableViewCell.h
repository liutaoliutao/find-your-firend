//
//  MJPhotoCommentTableViewCell.h
//  Encounter
//
//  Created by 李明军 on 28/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJPhotoDetailUserCellModel,MJPhotoCommentTableViewCell;



@protocol  MJPhotoCommentTableViewCellDelegate<NSObject>

@optional
- (void)photoCommentTVC:(MJPhotoCommentTableViewCell *)photoCommentTV didClickImgWithUserId:(NSInteger)userid;

@end

@interface MJPhotoCommentTableViewCell : UITableViewCell

/** 照片详情模型数据 */
@property (nonatomic,strong) MJPhotoDetailUserCellModel *phtoDetailUserCellModel;
/**  */
@property (nonatomic,weak) id<MJPhotoCommentTableViewCellDelegate> delegate;

/**
 *  可重用tableViewCell
 *
 *  @param tableView tableView
 *
 *  @return cell
 */
+ (instancetype)photoCommentTableViewCellWithTableView:(UITableView *) tableView;

@end
