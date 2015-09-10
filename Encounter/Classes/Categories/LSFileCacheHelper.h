//
//  LSFileCacheHelper.h
//  HaoShiHuo
//
//  Created by ldf on 14-8-20.
//  Copyright (c) 2014年 paris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSFileCacheHelper : NSObject
+ (void)setDocumentFileForJsonObject:(id)jsonObject WithFileName:(NSString *)fileName;
+ (id)getDocumentJsonObjectWithFileName:(NSString *)fileName;
+ (void)deleteDocumentFileWithFileName:(NSString *)fileName;
+ (void)creatLuodfCacheDirectory;
+ (void)setCacheFileForJsonObject:(id)jsonObject WithFileName:(NSString *)fileName;
+ (id)getCacheJsonObjectWithFileName:(NSString *)fileName;
+ (void)clearLuodfCache;
@end
