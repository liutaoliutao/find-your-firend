//
//  UIImageView+Extension.h
//  Encounter
//
//  Created by 李明军 on 10/7/15.
//  Copyright (c) 2015年 AiTa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

/**
 *  裁剪图片
 *
 *  @param newImage 裁剪图片
 */
- (void)scaleImageForSelf:(UIImage *)newImage;

@end
