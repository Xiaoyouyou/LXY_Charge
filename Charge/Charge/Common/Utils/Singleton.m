//
//  Singleton.m
//  CocoSocketDemo
//
//  Created by olive on 16/8/19.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import "Singleton.h"
#import "GCDAsyncSocket.h"
#import "XFunction.h"
#import "XStringUtil.h"
#import "Config.h"
#import <iconv.h>

//#define Host_IP @"192.168.1.101"
//#define Host_IP @"183.234.61.201"
//#define Host_IP @"192.168.1.101"

#define Host_IP @"47.107.14.253"
//#define Host_IP @"120.77.146.167"

#define Host_PORT 3005
//#define Host_PORT 1026
#define RepeatsCountS 90
#define Public @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDRC7JFsEdbatU1a59gF0juUyXzOoPwE3Gfa2NZd6B0yq/MudU+HKN+5bBk698A25cPIeQO/aHl9tMUCB2df0cXVZnAEijGB6It6LP4vz6KhKZBZD8bHXrb4OqrddoKrkWZtyZOVQBtq/GawEjGqRsIC8Y1l5XRjBandByK+U7ZlQIDAQAB"

@interface Singleton ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *clientSocket;
    //重连定时器
    NSTimer *_reconnectTimer;
}

@property (nonatomic, assign)  NSInteger repeatsCount;//重连次数
@property (nonatomic, assign)  int time;//超时时间
@property (nonatomic, retain)  NSTimer *TimeOut; // 连接超时计时器
@property (nonatomic, retain)  NSTimer *connectTimer; // 连接计时器
@property (nonatomic, assign)  NSString *flag;//标识位，用户主动切断连接，不用重连    1
                                              //       服务器掉线，默认为0
@end

@implementation Singleton

+(Singleton *)sharedInstance
{
    static Singleton *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    sharedInstace = [[self alloc] init];
        
    });

    return sharedInstace;
}

//开始重连socket
-(void)startReconectBlcok
{
//  [_reconnectTimer invalidate];
    if (_reconnectTimer == nil) {
       _reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reconnect) userInfo:nil repeats:true];
    NSLog(@"_reconnectTimer 的地址：%@",_reconnectTimer);
    }else
    {
        //开启定时器
        [_reconnectTimer setFireDate:[NSDate distantPast]];
    }
    
}

//连接socket
-(void)socketConnectHost
{
    //用户主动切断连接，不用重连 1
    //服务器掉线，默认为 0
    self.flag = @"0";
    //默认未连接为0
    self.isLink = NO;
    
    clientSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err;
  BOOL isSuccess =  [clientSocket connectToHost:Host_IP onPort:Host_PORT withTimeout:1 error:&err];
    MYLog(@"socket是否连接成功:%d",isSuccess);
    if (!err || [err isEqual:@"null"]) {
        MYLog(@"err = %@",err);
    }
}

-(void)reconnect
{
   //当连续5次没有连接成功时通知UI显示断网显示
    if (_repeatsCount == RepeatsCountS) {
        //断网提示block
        MYLog(@"重连30次失败");//弹框
        _repeatsCount = 0;//重置重连次数
        
        NSString *str = @"socket重连失败，退出当前界面";
        
        if (self.connectFailBlcok) {
            self.connectFailBlcok(str);
        }
   
        //关闭定时器
     //   [_reconnectTimer setFireDate:[NSDate distantFuture]];
        [_reconnectTimer invalidate];//关闭重连定时器
    }
    _repeatsCount +=1;
    [self socketConnectHost];//连接socket
}

#pragma mark - GCDAsyncSocketDelegate

//连接成功 回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {

    MYLog(@"连接成功");
    //连接成功，为1
    self.isLink = YES;
    
    _repeatsCount = 0;
    //关闭定时器
    [_reconnectTimer setFireDate:[NSDate distantFuture]];
 //   [_reconnectTimer invalidate];
    
    //如果正在充电，重连后发送继续充电指令
    if ([[Config getNormalEndChargingFlag] isEqualToString:@"0"]){//获得用户充电状态
    
//        [self continueCharging];//发送继续充电指令
    }
    
    [clientSocket readDataWithTimeout:- 1 tag:0];
}

- (NSString *)cleanUTF8:(NSData *)dat {
    NSData *data = [NSData dataWithData:dat]; // UTF-8编码
    //   NSString *str1 =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString *result = [NSMutableString string];
    const char *bytes = [data bytes];
    for (int i = 0; i < [data length]; i++) {
        [result appendFormat:@"%02hhx", (unsigned char)bytes[i]];
        
    }
    NSLog(@"result:%ld", result.length);
    return result;
    
}
  

// 收到消息 //为了能时刻接收到socket的消息，在长连接方法中进行读取数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    NSString *text = [self cleanUTF8:data];
    NSString *a = [text substringWithRange:NSMakeRange(0, 8)];
    if([a isEqualToString:@"00000000"] && a.length > 8){
        text = [text substringFromIndex:8];
    }
    [clientSocket readDataWithTimeout:-1 tag:0];//-1无穷大
    
   
    
//    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MYLog(@"收到消息 = %@",text);
    NSString *str = [text substringWithRange:NSMakeRange(4, 2)];
    
//后台确认开启充电指令
    if ([str isEqualToString:@"01"]) {
        MYLog(@"收到开启充电确认指令");
//        NSString *status = [text substringWithRange:NSMakeRange(4, 4)];
        if (self.StartChargeBlock) {
            self.StartChargeBlock(text);
        }
//        //桩ID
//        NSString *ID = [text substringWithRange:NSMakeRange(2, 18)];
//        MYLog(@"id = %@",ID);
//        //手机号
//        NSString *phoneNum = [text substringWithRange:NSMakeRange(20, 11)];
//        MYLog(@"phoneNum = %@",phoneNum);
        
    }
        
        if ([str isEqualToString:@"02"]) {
            MYLog(@"收到关闭充电确认指令");
//            NSString *status = [text substringWithRange:NSMakeRange(4, 4)];
            if (self.StopChargingMesBlock) {
                self.StopChargingMesBlock(text);
            }
        }
        
        
    
//状态检测回复
    if ([str isEqualToString:@"03"]) {
        MYLog(@"收到状态检测回复指令");
         NSString *status = [text substringWithRange:NSMakeRange(6, 2)];
        //     NSString *status =  [text substringWithRange:NSMakeRange(37, 12)];
        MYLog(@"status = %@",status);
        if (self.ChargeStatusMesBlock) {
            self.ChargeStatusMesBlock(status);
        }
        /*************************************/
    }
  
//点击结束充电之后，服务器的第二次返回
    if ([str isEqualToString:@"05"]) {
        
        //保存电费
        //                            [Config saveChargePay:[NSString stringWithFormat:@"%@￥",pay]];
        MYLog(@"充电完毕，后台推送的关于结束时间，金额等信息");
        if (self.StopChargingMesBlock) {
            self.StopChargingMesBlock(text);
        }
    }
//点击开起电桩之后，服务器的第二次返回
    if ([str isEqualToString:@"06"]) {
        MYLog(@"后台返回的关于桩是否启动成功的回调");
       
            if (self.StartChargeBlock) {
                self.StartChargeBlock(text);
            }
    }
    
    NSString *str1 = @"AABB0E00020D0A";
    if ([text rangeOfString:str1].location != NSNotFound) {
        MYLog(@"这个字符串中有AABB0002020D0A");
        MYLog(@"text = %@%@",text,@"\r\n");
        NSString *brStr = @"\r\n";//换行符
        NSString *newText = [NSString stringWithFormat:@"%@%@",text,brStr];
        MYLog(@"回复心跳");
        [self heartConnect:newText];
    }

//    NSString *str = @"not find";
//    if ([text rangeOfString:str].location != NSNotFound) {
//        MYLog(@"这个字符串中有not find");
//        NSString *chargeStr = @"充电桩掉线";
//        if (self.ChargeStatusMesBlock) {
//            self.ChargeStatusMesBlock(chargeStr);
//        }
//
//        if (self.YuYueChargeStatusMesBlock) {
//           self.YuYueChargeStatusMesBlock(chargeStr);
//        }
//    }
    
    //=======================================================//
   
    //=======================================================//
    
    
//        NSArray *b = [text componentsSeparatedByString:@"MM"];
//        MYLog(@"%@",b);
//        NSMutableArray *tempArray = [NSMutableArray array];
////
//        for (int i = 0; i < b.count; i++) {
//            NSString *tempStr = b[i];
//            if ([tempStr isEqualToString:@""]) {
//
//            }else
//            {
//                [tempArray addObject:[NSString stringWithFormat:@"MM%@",b[i]]];
//            }
//        }
    
//=======================================================//
        
//        for (int i = 0; i < tempArray.count; i++) {
//            NSString *tempStr = tempArray[i];
//            //判断返回数据有多少位   注释掉  以防以后还要用
//          if (tempStr.length >8) {
//            if (tempStr.length > 51) {

//                NSString *str = tempArray[i];
//                NSString *newStr = [str substringWithRange:NSMakeRange(0, 8)];
////              NSString *newStr = [str substringWithRange:NSMakeRange(0, 51)];
////            NSString *newStr1 = [str substringWithRange:NSMakeRange(43, str.length - 43)];
//                [tempArray removeObjectAtIndex:i];
//                [tempArray addObject:newStr];
//                [tempArray addObject:newStr1];
//            }
//        }
    //=======================================================//
//        MYLog(@"tempArray = %@",tempArray);
  //=======================================================//
//        for (int i = 0; i <tempArray.count; i++) {
//            NSString *text = tempArray[i];

//           if (text.length == 45) {
////            if (text.length == 51) {
//
//                NSString *str = [text substringFromIndex:43];
            //  NSString *str = [text substringFromIndex:49];
//                MYLog(@"str = %@",str);
            
//                if ([str isEqualToString:@"08"]) {//用户余额不足停止充电指令
//                    MYLog(@"收到后台发送用户余额不足停止充电指令");
//                    //消费 金额
//                    NSString *payMoney = [text substringWithRange:NSMakeRange(31, 6)];
//                    MYLog(@"payMoney = %@",payMoney);
//                    //已充电量
//                    // NSString *power = [text substringWithRange:NSMakeRange(40, 6)];
//                    NSString *power = [text substringWithRange:NSMakeRange(37, 6)];
//                    MYLog(@"power = %@",power);
//
//                    NSString *temp = nil;
//                    /*************************************/
//                    for(int i =0; i < [power length]; i++)
//                    {
//                        temp = [power substringWithRange:NSMakeRange(i, 1)];
//                        if ([temp isEqualToString:@"0"]) {
//
//                        }else
//                        {
//                            NSString *powerNum = [power substringWithRange:NSMakeRange(i, [power length] - i)];
//                            MYLog(@"powerNum = %@",powerNum);
//                            NSString *charging = [NSString stringWithFormat:@"%.2f",[powerNum floatValue]/100];
//                            MYLog(@"powerNum = %@",charging);
//                            //保存电量
//                            [Config saveCurrentPower:[NSString stringWithFormat:@"%@kwh",charging]];
//                            MYLog(@"getCurrentPower = %@",[Config getCurrentPower]);
//                            break;
//                        }
//                    }
//                    /*************************************/
//                    NSString *temps = nil;
//                    for(int i =0; i < [payMoney length]; i++)
//                    {
//                        temps = [payMoney substringWithRange:NSMakeRange(i, 1)];
//
//                        if ([temps isEqualToString:@"0"]) {
//
//                        }else
//                        {
//                            NSString *pays = [payMoney substringWithRange:NSMakeRange(i, [payMoney length] - i)];
//                            MYLog(@"payMoney = %@",pays);
//                            NSString *pay = [NSString stringWithFormat:@"%.2f",[pays floatValue]/100];
//                            MYLog(@"payMoney = %@",pay);
//                            //保存电费
//                            [Config saveChargePay:[NSString stringWithFormat:@"%@￥",pay]];
//
//                            MYLog(@"getChargePay = %@",[Config getChargePay]);
//                            break;
//                        }
//                    }
    //=======================================================//
//                    NSString *chargeStr = @"用户余额不足,停止充电！";
//                    if (self.MoneyNoEnoughMesBlock) {
//                        self.MoneyNoEnoughMesBlock(chargeStr);
//                    }
    //=======================================================//
//                }
/*************************************/
//                if ([str isEqualToString:@"02"]) {//后台确认开启充电指令
//                    MYLog(@"收到开启充电确认指令");
//
//                    if (self.StartChargeBlock) {
//                        self.StartChargeBlock(text);
//                    }
//                    //桩ID
//                    NSString *ID = [text substringWithRange:NSMakeRange(2, 18)];
//                    MYLog(@"id = %@",ID);
//                    //手机号
//                    NSString *phoneNum = [text substringWithRange:NSMakeRange(20, 11)];
//                    MYLog(@"phoneNum = %@",phoneNum);
//
//                }
       //=======================================================//
//                if ([str isEqualToString:@"03"]) {//后台发送充电金额，电量信息
//                    MYLog(@"收到后台发送电量信息指令");
//
//                    //消费 金额
//                    NSString *payMoney = [text substringWithRange:NSMakeRange(31, 6)];
//                    MYLog(@"payMoney = %@",payMoney);
//                    //已充电量
//                    NSString *power = [text substringWithRange:NSMakeRange(37, 6)];
//                    MYLog(@"power = %@",power);
//
//                    NSString *temp = nil;
//                    /*************************************/
//                    for(int i =0; i < [power length]; i++)
//                    {
//                        temp = [power substringWithRange:NSMakeRange(i, 1)];
//                        if ([temp isEqualToString:@"0"]) {
//
//                        }else
//                        {
//                            NSString *powerNum = [power substringWithRange:NSMakeRange(i, [power length] - i)];
//                            MYLog(@"powerNum = %@",powerNum);
//                            NSString *charging = [NSString stringWithFormat:@"%.2f",[powerNum floatValue]/100];
//                            MYLog(@"powerNum除于100 = %@",charging);
//                            //保存电量
//                            [Config saveCurrentPower:[NSString stringWithFormat:@"%@kwh",charging]];
//                            break;
//                        }
//                    }
//                    /*************************************/
//                    NSString *temps = nil;
//                    for(int i =0; i < [payMoney length]; i++)
//                    {
//                        temps = [payMoney substringWithRange:NSMakeRange(i, 1)];
//                        if ([temps isEqualToString:@"0"]) {
//
//                        }else
//                        {
//                            NSString *pays = [payMoney substringWithRange:NSMakeRange(i, [payMoney length] - i)];
//                            MYLog(@"payMoney = %@",pays);
//                            NSString *pay = [NSString stringWithFormat:@"%.2f",[pays floatValue]/100];
//                            MYLog(@"payMoney除于100 = %@",pay);
//                            //保存电费
//                            [Config saveChargePay:[NSString stringWithFormat:@"%@￥",pay]];
//                            break;
//                        }
//                    }
//                    /*************************************/
//                    if (self.StartReceiveMesBlock) {
//                        self.StartReceiveMesBlock(text);
//                    }
//
//                }
//  /*************************************/
//                if ([str isEqualToString:@"06"]) {//后台主动停止充电
//                    MYLog(@"收到后台主动停止充电确认指令");
//
//                    //消费 金额
//                    NSString *payMoney = [text substringWithRange:NSMakeRange(31, 6)];
//                    MYLog(@"payMoney = %@",payMoney);
//                    //已充电量
//                    NSString *power = [text substringWithRange:NSMakeRange(37, 6)];
//                    MYLog(@"power = %@",power);
//                    /*************************************/
//                    NSString *temp = nil;
//                    for(int i =0; i < [power length]; i++)
//                    {
//                        temp = [power substringWithRange:NSMakeRange(i, 1)];
//                        if ([temp isEqualToString:@"0"]) {
//
//                        }else
//                        {
//                            NSString *powerNum = [power substringWithRange:NSMakeRange(i, [power length] - i)];
//                            MYLog(@"powerNum = %@",powerNum);
//                            NSString *charging = [NSString stringWithFormat:@"%.2f",[powerNum floatValue]/100];
//                            MYLog(@"powerNum = %@",charging);
//                            //保存电量
//                            [Config saveCurrentPower:[NSString stringWithFormat:@"%@kwh",charging]];
//                            MYLog(@"getCurrentPower = %@",[Config getCurrentPower]);
//                            break;
//                        }
//                    }
//                    /*************************************/
//                    NSString *temps = nil;
//                    for(int i =0; i < [payMoney length]; i++)
//                    {
//                        temps = [payMoney substringWithRange:NSMakeRange(i, 1)];
//                        if ([temps isEqualToString:@"0"]) {
//
//                        }else
//                        {
//                            NSString *pays = [payMoney substringWithRange:NSMakeRange(i, [payMoney length] - i)];
//                            MYLog(@"payMoney = %@",pays);
//                            NSString *pay = [NSString stringWithFormat:@"%.2f",[pays floatValue]/100];
//                            MYLog(@"payMoney = %@",pay);
//                            //保存电费
//                            [Config saveChargePay:[NSString stringWithFormat:@"%@￥",pay]];
//
//                            MYLog(@"getChargePay = %@",[Config getChargePay]);
//                            break;
//                       }
//                    }
//                    /*************************************/
//                        if (self.StopChargingMesBlock) {
//                            self.StopChargingMesBlock(text);
//                        }
//
//       }
    /*************************************/
//                if ([str isEqualToString:@"07"]) {//状态检测回复
//                    MYLog(@"收到状态检测回复指令");
//                    NSString *status = [text substringWithRange:NSMakeRange(31, 12)];
//            //     NSString *status =  [text substringWithRange:NSMakeRange(37, 12)];
//                    MYLog(@"status = %@",status);
//                    /*************************************/
//                    if ([status isEqualToString:@"000000000000"]) {
//                        MYLog(@"状态正常");
//                        NSString *chargeStr = @"状态正常";
//                        if (self.ChargeStatusMesBlock) {
//                            self.ChargeStatusMesBlock(chargeStr);
//                        }
//                        [self cutOffSocket];//切断socket   短连接
//                        return;
//                    }else if([status isEqualToString:@"999999999999"])
//                    {
//                        MYLog(@"充电桩故障");
//                        NSString *chargeStr = @"充电桩故障";
//                        if (self.ChargeStatusMesBlock) {
//                            self.ChargeStatusMesBlock(chargeStr);
//                        }
//                        [self cutOffSocket];//切断socket
//                        return;
//                    }else if([status isEqualToString:@"999998999998"])
//                    {
//                        MYLog(@"充电桩正在使用");
//                        NSString *chargeStr = @"充电桩正在使用";
//                        if (self.ChargeStatusMesBlock) {
//                            self.ChargeStatusMesBlock(chargeStr);
//                        }
//                        [self cutOffSocket];//切断socket
//                        return;
//                    }else if ([status isEqualToString:@"999997999997"])
//                    {
//                       MYLog(@"充电桩预约中");
//                       NSString *chargeStr = @"充电桩被预约";
//                        if (self.ChargeStatusMesBlock) {
//                            self.ChargeStatusMesBlock(chargeStr);
//                        }
//                        [self cutOffSocket];//切断socket
//                        return;
//                    }
//                }
                /*************************************/
//                if ([str isEqualToString:@"10"]) {
//                    MYLog(@"收到预约回复指令");
//                    NSString *status = [text substringWithRange:NSMakeRange(31, 12)];
//                    if ([status isEqualToString:@"000000000000"]) {
//                        MYLog(@"状态正常");
//                        NSString *chargeStr = @"状态正常";
//                        if (self.YuYueChargeStatusMesBlock) {
//                            self.YuYueChargeStatusMesBlock(chargeStr);
//                        }
//                        [self cutOffSocket];//切断socket   短连接
//                        return;
//                    }
//                    /*************************************/
//                    if ([status isEqualToString:@"999997999997"])
//                    {
//                    MYLog(@"充电桩预约中");
//                    NSString *chargeStr = @"充电桩被预约";
//                    if (self.YuYueChargeStatusMesBlock) {
//                        self.YuYueChargeStatusMesBlock(chargeStr);
//                        }
//                    [self cutOffSocket];//切断socket
//                    return;
//                    }
//                /*************************************/
//                    if([status isEqualToString:@"999998999998"])
//                    {
//                    MYLog(@"充电桩正在使用");
//                    NSString *chargeStr = @"充电桩正在使用";
//                    if (self.YuYueChargeStatusMesBlock) {
//                        self.YuYueChargeStatusMesBlock(chargeStr);
//                        }
//                    [self cutOffSocket];//切断socket
//                    return;
//                    }
//                    /*************************************/
//                    if([status isEqualToString:@"999999999999"])
//                    {
//                    MYLog(@"充电桩故障");
//                    NSString *chargeStr = @"充电桩故障";
//                    if (self.YuYueChargeStatusMesBlock) {
//                        self.YuYueChargeStatusMesBlock(chargeStr);
//                        }
//                    [self cutOffSocket];//切断socket
//                    return;
//                   }
//                }
               /*************************************/
//                if ([str isEqualToString:@"11"]) {
//                    MYLog(@"收到取消预约回复指令");
//                    NSString *chargeStr = @"收到取消预约回复指令";
//                    if (self.CancelYuYueChargeStatusMesBlock) {
//                        self.CancelYuYueChargeStatusMesBlock(chargeStr);
//                        }
//                    [self cutOffSocket];//切断socket
//                    return;
//                }
            
            
            
            //和上面判断是否等于45是一组的
            
//            }else
//            {
//                MYLog(@"接收到的不是操作指令");
//            }
            
             //------------和上面的第二个for循环是一伙的--------------//
            
//        }
             //------------和上面的第一个for循环是一伙的--------------//
//    }

}

// 切断socket
-(void)cutOffSocket{
    
    //标示为用户主动切断连接
    self.flag = @"1";
    //置位socket为未连接
    self.isLink = NO;
    [self.connectTimer invalidate];
    [clientSocket disconnect];
    
}

//断开连接回调
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if ([self.flag isEqualToString:@"1"]) {//判断是否用户断开连接
      //不用重连
      MYLog(@"用户主动断开连接，不重连");
        return;
    }else
    {
      //重连
      MYLog(@"断开连接,重连中...");
      [self startReconectBlcok];//调用重连socket方法
    }
}

//socket 完成写入的时候调用
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    MYLog(@"消息发送完成");
}

#pragma mark-充电指令集
//继续充电
-(void)continueCharging
{
    if ([Config getChargeNum]) { //获取充电桩号
        MYLog(@"发送继续充电指令");
        NSString *brStr = @"\r\n";//换行符
        NSString *continueStr = [NSString stringWithFormat:@"MM%@%@00000000000009%@",[Config getChargeNum],[Config getMobile],brStr];
        MYLog(@"继续充电指令 = %@",continueStr);
        NSData   *dataStream = [continueStr dataUsingEncoding:NSUTF8StringEncoding];
        [clientSocket writeData:dataStream withTimeout:-1 tag:1];
    }else if ([[Config getChargeNum] isEqualToString:@""])
    {
        MYLog(@"充电桩号为空，不发送继续充电指令");
    }else
    {
        MYLog(@"发送继续充电指令，但没有保存的充电桩号，发送失败");
    }
}

//开始充电
-(void)startChargingWithChargeNum:(NSString *)ChargeNum
{
    NSString *brStr = @"\r\n";//换行符
    NSString * strAscll1 = [XStringUtil ascllString:ChargeNum];
    NSString *str1 = [NSString stringWithFormat:@"%@%@%@",@"01",strAscll1,[Config getMobile]];
    NSString *str2 = [RsaUtil encryptString:str1 publicKey:Public];
    NSString * strAscll2 = [XStringUtil ascllString:str2];
    NSString *startString = [NSString stringWithFormat:@"AABB6001%@",strAscll2];
//   NSString *startString = [NSString stringWithFormat:@"MM%@%@00000000000001%@",ChargeNum,[Config getMobile],brStr];//开启电桩指令
   NSData   *dataStream  = [startString dataUsingEncoding:NSUTF8StringEncoding];
   [clientSocket writeData:dataStream withTimeout:-1 tag:1];
}

//停止充电
-(void)stopChargingWithChargeNum:(NSString *)ChargeNum
{
   MYLog(@"停止充电");
   NSString *brStr = @"\r\n";//换行符
    
    NSString * strAscll1 = [XStringUtil ascllString:ChargeNum];
    NSString *str1 = [NSString stringWithFormat:@"%@%@%@",@"02",strAscll1,[Config getMobile]];
    NSString *str2 = [RsaUtil encryptString:str1 publicKey:Public];
    NSString * strAscll2 = [XStringUtil ascllString:str2];
    NSString *stopString = [NSString stringWithFormat:@"AABB6001%@",strAscll2];
//    NSString *stopString = [NSString stringWithFormat:@"MM%@%@00000000000005%@",ChargeNum,[Config getMobile],brStr];
    MYLog(@"停止充电指令 = %@",stopString);
    NSData   *dataStream  = [stopString dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:dataStream withTimeout:-1 tag:1];
}

//查询充电桩状
-(void)checkChargeStatusWithChargeNum:(NSString *)ChargeNum
{
    NSString *brStr = @"\r\n";//换行符
    NSString * strAscll1 = [XStringUtil ascllString:ChargeNum];
    NSString *str1 = [NSString stringWithFormat:@"%@%@",@"03",strAscll1];
    NSString *str2 = [RsaUtil encryptString:str1 publicKey:Public];
    NSString * strAscll2 = [XStringUtil ascllString:str2];
    NSString *checkString = [NSString stringWithFormat:@"AABB6001%@",strAscll2];
    
    NSData   *dataStream  = [checkString dataUsingEncoding:NSUTF8StringEncoding];
//    Byte *bytes = [dataStream bytes];
    [clientSocket writeData:dataStream withTimeout:-1 tag:1];
}

//预约电桩
-(void)yuYueChargeNum:(NSString *)ChargeNum cost:(NSString *)cost
{
    NSString *brStr = @"\r\n";//换行符
    //拼接参数
    NSString *checkString = [NSString stringWithFormat:@"MM%@%@000000%@10%@",ChargeNum,[Config getMobile],cost,brStr];
    MYLog(@"checkString = %@",checkString);
    NSData   *dataStream  = [checkString dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:dataStream withTimeout:-1 tag:1];
}

//取消预约电桩
-(void)cancelChargeNum:(NSString *)ChargeNum
{
    NSString *brStr = @"\r\n";//换行符
    NSString *checkString = [NSString stringWithFormat:@"MM%@%@00000000000011%@",ChargeNum,[Config getMobile],brStr];
    NSData   *dataStream  = [checkString dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:dataStream withTimeout:-1 tag:1];
}

//心跳包发送
-(void)heartConnect:(NSString *)str
{
    NSString *HeartString = str;
    NSData   *dataStream  = [HeartString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"HeartString = %@",HeartString);
    [clientSocket writeData:dataStream withTimeout:-1 tag:1];
}

@end
