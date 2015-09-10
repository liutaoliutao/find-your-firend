//
//  UIImage+CZ.h
//  B06.图片水印
//
//  Created by Apple on 15/1/2.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CZ)

/**
 *  更具rect裁剪图片，不变形裁剪
 *
 *  @param rect rect
 *
 *  @return 裁剪后的图片
 */
-(UIImage*)getSubImage:(CGRect)rect;

/**
 *
 *  @param bgImageName    背景图片
 *  @param waterImageName 水印图片
 *  @param scale 图片生成的比例
 *  @return 添加了水印的背景图片
 */
+(UIImage *)waterImageWithBgImageName:(NSString *)bgImageName waterImageName:(NSString *)waterImageName scale:(CGFloat)scale;


/**
 *
 *  @param imageName    需要裁剪的图片
 *  @param borderColor 边框的颜色
 *  @param borderWidth 边框的宽度
 *  @return 一个裁剪 带有边框的圆形图片
 */
+(UIImage *)circleImageWithImage:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  裁剪方形
 *
 *  @param image       图片
 *  @param borderColor
 *  @param borderWidth
 *
 *  @return
 */
+(UIImage *)clipImageWithImage:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  裁剪长方形方形
 *
 *  @param image       图片
 *  @param borderColor
 *  @param borderWidth
 *
 *  @return
 */
+(UIImage *)clipPhotoImageWithImage:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  将图片存入缓存
 *
 *  @param img 头像图片
 */
+ (NSString *)saveImgInDocumentWithImg:(UIImage *)img WithName:(NSString *)nameStr;

@end
