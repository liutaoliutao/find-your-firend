//
//  NSMutableURLRequest+MJPostDataAppend.m
//  AppPOST
//
//  Created by mac on 15/4/22.
//  Copyright (c) 2015年 LiMingjun. All rights reserved.
//

#import "NSMutableURLRequest+MJPostDataAppend.h"
#import "MJConst.h"

@implementation NSMutableURLRequest (MJPostDataAppend)

/**
 *  拼接POST数据体
 */
+ (instancetype)requestPostDataAppendWithURL:(NSURL *)url boundary:(NSString *)boundary fileName:(NSString *)filename andDataPath:(NSString *)path
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [request requestPOSTDataWithBoundary:boundary andFileName:filename andDataPath:path];
    //  数据头
    NSString *str = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:str forHTTPHeaderField:@"Content-Type"];
    return request;
}

#pragma mark - http请求POST数据体拼接
/**
 *  http请求POST数据体拼接
 */
- (NSData *)requestPOSTDataWithBoundary:(NSString *)boundary andFileName:(NSString *)fileName andDataPath:(NSString *)path
{
    
    /**
     Content-Length	1785
     Content-Type	multipart/form-data; boundary=---------------------------1305717219539110401992233893
     
     
     --1305717219539110401992233893
     Content-Disposition: form-data; name="userfile"; filename="app.plist"
     Content-Type: application/octet-stream
     */
    //  1.0定义可变数据
    NSMutableData *dataD = [NSMutableData data];
    //  2.0拼接数据体
    //  2.0.1数据体开始分割符：\r\n--(自定义分隔符)\r\n
    NSString *str = [NSString stringWithFormat:@"\r\n--%@\r\n",boundary];
    [dataD appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //  2.0.2数据体name和filename：Content-Disposition: form-data; name=\"userfile\"; filename=\"（自定义filename）\"\r\n
    str = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",fileName];
    [dataD appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //  2.0.3数据体文件格式：Content-Type: application/octet-stream\r\n\r\n
    str = [NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
    [dataD appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //  2.0.4数据体发送的主要数据
    [dataD appendData:[NSData dataWithContentsOfFile:path]];
    //  2.0.5数据体结束分隔符：\r\n--（自定义分隔符）--\r\n
    str = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
    [dataD appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    return dataD;
}


+ (instancetype)requestForWithUrl:(NSString *)url dic:(NSDictionary *)params imgKey:(NSString *)picKey
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request    = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary            = [[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary         = [[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    UIImage *image                  = [params objectForKey:picKey];
    
    NSData* data                    = UIImagePNGRepresentation(image);
    MJLog(@"----------------图片数据流\n%@\n图片数据流结束------------------",data);
    
    //http body的字符串
    NSMutableString *body           = [[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys                   = [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key               = [keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:picKey])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"boris.png\"\r\n",picKey];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    MJLog(@"不包括结束符的body%@",body);
    //声明结束符：--AaB03x--
    NSString *end                   = [[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData    = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    MJLog(@"%@",request.HTTPBody);
    //http method
    [request setHTTPMethod:@"POST"];
    
    return request;
}



@end
