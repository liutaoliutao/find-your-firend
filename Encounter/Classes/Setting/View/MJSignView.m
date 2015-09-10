//
//  MJSignView.m
//  MJ150
//
//  Created by 高文富 on 15/5/11.
//  Copyright (c) 2015年 AitaCompany. All rights reserved.
//


#import "MJSignView.h"

@implementation MJSignView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


/**
 *  画出自定义标记
 *
 *  @param rect rect
 */
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // Drawing code
    //  1.0 获取图层上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //  1.1 设置颜色
    [[UIColor redColor] set];
    //  1.2 根据是否传入字符串计算所画圆半径
    CGFloat region;
    NSInteger drawNum    = self.drawStr.intValue;
    if (drawNum) {
        region           = rect.size.width * 0.5;
    }else{
        region           = rect.size.width * 0.25;
    }
    //  1.3 画圆
    CGContextAddArc(context, rect.size.width * 0.5, rect.size.height * 0.5, region, 0, M_PI * 2, 1);
    //  1.4 闭合上下文
    CGContextFillPath(context);
    
    //  2.0 如果字符串有值且不为零，画出字符串
    if (!drawNum)return;
    //  2.1 如果是一位数
    if ( drawNum < 10) {
        
        [self.drawStr drawInRect:CGRectMake(4, 0, rect.size.width , rect.size.height ) withAttributes:@{
                                                                    NSFontAttributeName              : [UIFont systemFontOfSize:12] ,
                                                                    NSForegroundColorAttributeName   : [UIColor whiteColor]}];
    //  2.2 如果是两位数
    }else if(10 <= drawNum){
        [self.drawStr drawInRect:CGRectMake(1, 0, rect.size.width , rect.size.height ) withAttributes:@{
                                                                    NSFontAttributeName              : [UIFont systemFontOfSize:10],
                                                                    NSForegroundColorAttributeName   : [UIColor whiteColor]}];
    }
}

/**
 *  当收到设置时，重绘
 *
 *  @param drawStr 
 */
- (void)setDrawStr:(NSString *)drawStr
{
    _drawStr = drawStr;
    [self setNeedsDisplay];
}

@end
