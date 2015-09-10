//
//  NSMutableURLRequest+MJPostDataAppend.h
//  AppPOST
//
//  Created by mac on 15/4/22.
//  Copyright (c) 2015年 LiMingjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableURLRequest (MJPostDataAppend)

/**
 *  拼接POST数据体
 */
+ (instancetype)requestPostDataAppendWithURL:(NSURL *)url boundary:(NSString *)boundary fileName:(NSString *)filename andDataPath:(NSString *)path;

+ (instancetype)requestForWithUrl:(NSString *)url dic:(NSDictionary *)params imgKey:(NSString *)picKey;

@end
