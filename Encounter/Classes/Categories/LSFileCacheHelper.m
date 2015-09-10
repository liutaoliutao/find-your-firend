//
//  LSFileCacheHelper.m
//  HaoShiHuo
//
//  Created by ldf on 14-8-20.
//  Copyright (c) 2014年 paris. All rights reserved.
//

#import "LSFileCacheHelper.h"
@implementation LSFileCacheHelper
+ (void)setDocumentFileForJsonObject:(id)jsonObject WithFileName:(NSString *)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filePath=[path stringByAppendingPathComponent:fileName];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [jsonString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
+ (id)getDocumentJsonObjectWithFileName:(NSString *)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *json_path=[path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:json_path]) {
        NSData *data=[NSData dataWithContentsOfFile:json_path];
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers
                                                        error:nil];
        return jsonObject;
    }else{
        return nil;
    }
}
+ (void)deleteDocumentFileWithFileName:(NSString *)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *json_path=[path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:json_path]) {
        [fileManager removeItemAtPath:json_path error:nil];
    }
}
+ (void)creatLuodfCacheDirectory{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[paths lastObject];
    NSString *directoryPath=[path stringByAppendingPathComponent:@"Luodf"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directoryPath]) {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
+ (void)setCacheFileForJsonObject:(id)jsonObject WithFileName:(NSString *)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Luodf"];
    NSString *filePath=[path stringByAppendingPathComponent:fileName];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [jsonString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
+ (id)getCacheJsonObjectWithFileName:(NSString *)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Luodf"];
    NSString *json_path=[path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:json_path]) {
        NSData *data=[NSData dataWithContentsOfFile:json_path];
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers
                                                        error:nil];
        return jsonObject;
    }else{
        return nil;
    }
}
+ (void)clearLuodfCache{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Luodf"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:nil];
    if (fileList) {
        for (NSString *fileName in fileList) {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:filePath]) {
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
    }
}
@end
