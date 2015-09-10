//
//  UIImage+CZ.m
//  B06.图片水印
//
//  Created by Apple on 15/1/2.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "UIImage+CZ.h"
#import "MJConst.h"

@implementation UIImage (CZ)


-(UIImage*)getSubImage:(CGRect)rect

{
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    
    
    UIGraphicsBeginImageContext(smallBounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, smallBounds, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}


+(UIImage *)waterImageWithBgImageName:(NSString *)bgImageName waterImageName:(NSString *)waterImageName scale:(CGFloat)scale{
    // 生成一张有水印的图片，一定要获取UIImage对象 然后显示在imageView上
    
    //创建一背景图片
    UIImage *bgImage = [UIImage imageNamed:bgImageName];
    //NSLog(@"bgImage Size: %@",NSStringFromCGSize(bgImage.size));
    // 1.创建一个位图【图片】，开启位图上下文
    // size:位图大小
    // opaque: alpha通道 YES:不透明/ NO透明 使用NO,生成的更清析
    // scale 比例 设置0.0为屏幕的比例
    // scale 是用于获取生成图片大小 比如位图大小：20X20 / 生成一张图片：（20 *scale X 20 *scale)
    //NSLog(@"当前屏幕的比例 %f",[UIScreen mainScreen].scale);
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, scale);
    
    // 2.画背景图
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 3.画水印
    // 算水印的位置和大小
    // 一般会通过一个比例来缩小水印图片
    UIImage *waterImage = [UIImage imageNamed:waterImageName];
#warning 水印的比例，根据需求而定
    CGFloat waterScale = 0.4;
    CGFloat waterW = waterImage.size.width * waterScale;
    CGFloat waterH = waterImage.size.height * waterScale;
    CGFloat waterX = bgImage.size.width - waterW;
    CGFloat waterY = bgImage.size.height - waterH;
    
    
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    // 4.从位图上下文获取 当前编辑的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    // 5.结束当前位置编辑
    UIGraphicsEndImageContext();
    
    
    return newImage;
}


+(UIImage *)circleImageWithImage:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{

    //需求：从位图上下文，裁剪图片[裁剪成圆形，也添加圆形的边框]，生成一张图片
    
    // 获取要裁剪的图片
//    UIImage *img = [UIImage imageNamed:imageName];
    CGRect imgRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // 1.开启位图上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    
#warning 在自定义的view的drawRect方法里，调用UIGraphicsGetCurrentContext获取的上下文，是图层上下文(Layer Graphics Context)
    // 1.1 获取位图上下文
    CGContextRef bitmapContext = UIGraphicsGetCurrentContext();
    
    // 2.往位图上下裁剪图片
    
    // 2.1 指定一个圆形的路径，把圆形之外的剪切掉
    CGContextAddEllipseInRect(bitmapContext, imgRect);
    CGContextClip(bitmapContext);
    
//    UIGraphicsPushContext(bitmapContext);
    // 2.2 添加图片
    [image drawInRect:imgRect];
    
    // 2.3 添加边框
    // 设置边框的宽度
    CGContextSetLineWidth(bitmapContext, borderWidth);
    // 设置边框的颜色
    [borderColor set];
    CGContextAddEllipseInRect(bitmapContext, imgRect);
    CGContextStrokePath(bitmapContext);
    
    
    // 3.获取当前位图上下文的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.结束位图编辑
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  裁剪方形
 *
 *  @param image       图片
 *  @param borderColor
 *  @param borderWidth
 *
 *  @return
 */
+(UIImage *)clipImageWithImage:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    
    //需求：从位图上下文，裁剪图片[裁剪成圆形，也添加圆形的边框]，生成一张图片
    
    // 获取要裁剪的图片
    //    UIImage *img = [UIImage imageNamed:imageName];
    CGRect imgRect = CGRectMake(0, 0, image.size.height, image.size.width);
    CGRect rectT   = CGRectMake(0, 0,  image.size.height, 249);
    
    // 1.开启位图上下文
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    UIGraphicsBeginImageContextWithOptions(imgRect.size, NO, 0.0);
    
#warning 在自定义的view的drawRect方法里，调用UIGraphicsGetCurrentContext获取的上下文，是图层上下文(Layer Graphics Context)
    // 1.1 获取位图上下文
    CGContextRef bitmapContext = UIGraphicsGetCurrentContext();
    
    // 2.往位图上下裁剪图片
    
    // 2.1 指定一个矩形的路径，把圆形之外的剪切掉
    CGContextAddRect(bitmapContext, imgRect);
    
    CGContextClip(bitmapContext);
    
    //    UIGraphicsPushContext(bitmapContext);
    // 2.2 添加图片
    [image drawInRect:imgRect];
    
    // 2.3 添加边框
//    // 设置边框的宽度
//    CGContextSetLineWidth(bitmapContext, borderWidth);
//    // 设置边框的颜色
//    [borderColor set];
//    CGContextAddEllipseInRect(bitmapContext, imgRect);
//    CGContextStrokePath(bitmapContext);
    
    
    // 3.获取当前位图上下文的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.结束位图编辑
    UIGraphicsEndImageContext();
    
    return newImage;
}


/**
 *  裁剪长方形方形
 *
 *  @param image       图片
 *  @param borderColor
 *  @param borderWidth
 *
 *  @return
 */
+(UIImage *)clipPhotoImageWithImage:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    
    //需求：从位图上下文，裁剪图片[裁剪成圆形，也添加圆形的边框]，生成一张图片
    
    // 获取要裁剪的图片
    //    UIImage *img = [UIImage imageNamed:imageName];
    CGRect imgRect = CGRectMake(0, 0, image.size.width, image.size.width * 0.65);
    
    // 1.开启位图上下文
    //    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    UIGraphicsBeginImageContextWithOptions(imgRect.size, NO, 0.0);
    
#warning 在自定义的view的drawRect方法里，调用UIGraphicsGetCurrentContext获取的上下文，是图层上下文(Layer Graphics Context)
    // 1.1 获取位图上下文
    CGContextRef bitmapContext = UIGraphicsGetCurrentContext();
    
    // 2.往位图上下裁剪图片
    
    // 2.1 指定一个圆形的路径，把圆形之外的剪切掉
    CGContextAddRect(bitmapContext, imgRect);
    
    CGContextClip(bitmapContext);
    
    //    UIGraphicsPushContext(bitmapContext);
    // 2.2 添加图片
    [image drawInRect:imgRect];
    
    // 2.3 添加边框
    // 设置边框的宽度
    CGContextSetLineWidth(bitmapContext, borderWidth);
    // 设置边框的颜色
    [borderColor set];
    CGContextAddEllipseInRect(bitmapContext, imgRect);
    CGContextStrokePath(bitmapContext);
    
    
    // 3.获取当前位图上下文的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.结束位图编辑
    UIGraphicsEndImageContext();
    
    return newImage;
}



/**
 *  将图片存入缓存
 *
 *  @param img 头像图片
 */
+ (NSString *)saveImgInDocumentWithImg:(UIImage *)img WithName:(NSString *)nameStr
{
    //  将图片转换为data
    NSData *data                    = [self setImgToDataWithImg:img];
    
    //  拼接路径
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory     = [paths objectAtIndex:0];
    NSString *userHeadImgfileName   = [NSString stringWithFormat:@"%@.jpg",nameStr];
    NSString *userHeadImgFilePath   = [documentDirectory stringByAppendingPathComponent:userHeadImgfileName];
    //  删除已存在同名文件
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:userHeadImgFilePath error:nil];
    
    [data writeToFile:userHeadImgFilePath atomically:YES];
    MJLog(@"存入头像图片文件%@",userHeadImgFilePath);
    return userHeadImgFilePath;
}

/**
 *  将图片转换为data
 *
 *  @param img 图片
 *
 *  @return 转换之后的data
 */
+ (NSData *)setImgToDataWithImg:(UIImage *)img
{
    NSData *data = nil;
//    if (UIImagePNGRepresentation(img) == nil)
//    {
        data = UIImageJPEGRepresentation(img, 0.2);
//    }
//    else
//    {
//        data = UIImagePNGRepresentation(img);
//        
//    }
    return data;
}


@end
