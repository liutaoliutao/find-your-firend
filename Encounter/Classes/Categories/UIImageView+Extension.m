//
//  UIImageView+Extension.m
//  Encounter
//
//  Created by 李明军 on 10/7/15.
//  Copyright (c) 2015年 AiTa. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIImage+CZ.h"

@implementation UIImageView (Extension)

- (void)scaleImageForSelf:(UIImage *)newImage
{
    
    
//    CGSize size;
//    
//    size.width = self.frame.size.width ;
//    
//    size.height = (self.frame.size.width * image.size.height) /image.size.width ;
//    
//    UIImage *newImage = [image scaleToSize:size];
    
   
    
    CGFloat srcRatio = newImage.size.height/newImage.size.width;
    
    CGFloat desRatio = self.frame.size.height/self.frame.size.width;
    
    
    
    CGRect rect;
    
    if(srcRatio > desRatio){ //截上下，宽一致
        
        CGFloat ratio = newImage.size.width/self.frame.size.width;//缩放比
        
        rect.size.height = self.frame.size.height * ratio ;
        
        rect.size.width = newImage.size.width;
        
        rect.origin.x = 0;
        
        rect.origin.y = (newImage.size.height - self.frame.size.height)/2.0;
        
        self.image = [newImage getSubImage:rect];
        
    }else if (srcRatio < desRatio)
        
        //截左右，高一致
    {
        
        CGFloat ratio = newImage.size.height/self.frame.size.height;
        
        rect.size.width = self.frame.size.width * ratio;
        
        rect.size.height = newImage.size.height ;
        
        rect.origin.x =newImage.size.width - self.frame.size.width/2.0;
        
        rect.origin.y =  0;
        
        
        
        self.image = [newImage getSubImage:rect];
        
    }else
        
    {
        
        self.image = newImage;//得到的图片的长宽比与iamgeView的长宽比一致，不用裁剪
        
    }
    
    
}



@end
