//
//  Singleton.h
//  CocoSocketDemo
//
//  Created by olive on 16/8/19.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t onceToken = 0; \
__strong static id sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = block(); \
}); \
return sharedInstance; \

@interface Singleton : NSObject

@property (nonatomic, assign) BOOL isLink; //是否是连接状态
@property (nonatomic, assign) BOOL isCharging; //是否是正在充电状态
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot

@property (nonatomic, copy) void (^connectFailBlcok)(NSString *);//重连失败bloc回调
@property (nonatomic, copy) void (^StartChargeBlock)(NSString *);//后台返回开始充电信息
@property (nonatomic, copy) void (^StartReceiveMesBlock)(NSString *);//后台返回详细充电信息
@property (nonatomic, copy) void (^StopChargingMesBlock)(NSString *);//后台返回停止充电指令
@property (nonatomic, copy) void (^ChargeStatusMesBlock)(NSString *);//后台返回查询充电桩状态结果
@property (nonatomic, copy) void (^YuYueChargeStatusMesBlock)(NSString *);//后台返回预约充电桩状态结果
@property (nonatomic, copy) void (^CancelYuYueChargeStatusMesBlock)(NSString *);//后台返回预约充电桩状态结果
@property (nonatomic, copy) void (^MoneyNoEnoughMesBlock)(NSString *);//后台返回用户余额不足停止充电指令结果

@property (nonatomic, copy) void (^InitFailBlock)(NSString *);//后台返回电桩初始化失败指令结果


+ (Singleton *)sharedInstance; //创建单例

-(void)socketConnectHost;// socket连接
-(void)cutOffSocket; // 断开socket连接
-(void)startReconectBlcok;//重连scoket
-(void)startChargingWithChargeNum:(NSString *)ChargeNum;//开启电桩
-(void)stopChargingWithChargeNum:(NSString *)ChargeNum;//停止充电
-(void)checkChargeStatusWithChargeNum:(NSString *)ChargeNum;//查询充电桩状态
-(void)continueCharging;//继续充电指令
-(void)yuYueChargeNum:(NSString *)ChargeNum cost:(NSString *)cost;//预约电桩
-(void)cancelChargeNum:(NSString *)ChargeNum;//取消预约电桩


@end
