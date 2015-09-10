//
//  MJAttriubuteStrToNSString.m
//  Encounter
//
//  Created by 李明军 on 18/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#import "MJAttriubuteStrToNSString.h"
#import "MJFaceImgModel.h"

@implementation MJAttriubuteStrToNSString
- (void)setEmotion:(MJFaceImgModel *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.imgName];
}

@end
