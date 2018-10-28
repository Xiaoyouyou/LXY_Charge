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
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 8.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [session POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
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
    
    [session GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(success){
            
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

@end
