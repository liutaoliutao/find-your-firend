//
//  MJNoDataView.m
//  Encounter
//
//  Created by 李明军 on 2/7/15.
//  Copyright (c) 2015年 AiTa. All rights reserved.
//

#import "MJNoDataView.h"

@implementation MJNoDataView

- (instancetype)init
{
    if (self = [super init])
    {
        self = [[[NSBundle mainBundle]loadNibNamed:@"MJNodataView" owner:self options:nil] firstObject];
    }
    return self;
}




@end
