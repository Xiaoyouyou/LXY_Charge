//
//  WMNetWork.h
//  Charge
//
//  Created by olive on 16/6/16.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WMNetWork : NSObject

+(void)post:(NSString*)url parameters:(NSMutableDictionary*)parameters success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

+(void)get:(NSString*)url parameters:(NSMutableDictionary*)parameters success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;


@end
