//
//  WMNetWork.m
//  Charge
//
//  Created by olive on 16/6/16.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "WMNetWork.h"

@implementation WMNetWork

+(void)post:(NSString*)url parameters:(NSDictionary*)parameters success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    
    //设置超时时间
    //设置公共参数
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//
//    /**设置请求超时时间*/
    requestSerializer.timeoutInterval = 8;
//    /**设置相应的缓存策略*/
//    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//
//    /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
    [requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//
//
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    /**设置接受的类型*/
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
//
//
    
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
   //忽略https证书
   securityPolicy.validatesDomainName = NO;
   securityPolicy.allowInvalidCertificates = YES;
  
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.requestSerializer = requestSerializer;
//    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    session.requestSerializer = requestSerializer;
//    session.responseSerializer = responseSerializer;
    session.securityPolicy = securityPolicy;
    [session POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        if (failure){
            failure(error);
        }
    }];
}

+(void)get:(NSString*)url parameters:(NSDictionary*)parameters success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 8.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [session GET:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        if (failure){
            failure(error);
        }
    }];
}

@end
