//
//  API.h
//  TeslarHelper
//
//  Created by olive on 15/9/14.
//  Copyright (c) 2015年 XingGuo. All rights reserved.
//

#ifndef TeslarHelper_API_h
#define TeslarHelper_API_h

//183.234.61.201:8081/app  正式版
//112.74.20.252 测试版
#define XYScreenWidth [UIScreen mainScreen].bounds.size.width
#define XYScreenHeight [UIScreen mainScreen].bounds.size.height
#define StatusBarH  [UIApplication sharedApplication].statusBarFrame.size.height

//RGB color
#define RGB_COLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define BaseURL @"http://120.77.146.167:88/app/phone/"
#define RequestURL(string) [NSString stringWithFormat:@"%@%@",BaseURL,string]

//APPKey
#define WeChat_appkey    @"wx99369c2484d2a152" //微信APPkey
#define BaiDuMap_appkey  @"DDOXVg1C3et2vlrZwzSvwLlhHPCQkcsh" //百度APPkey
#define YouMeng_appkey   @"5840e455c895767de90010ae" //友盟APPkey
#define WeChat_appSecret @"7aacd13968afdcce98968bf57290eb55" //微信APPSecret
#define JPUSH_appkey   @"34315539ed9431af470f4cf0" //极光推送APPkey
#define Rich_APM_appkey   @"a4d6715be1384a8bab9b663de6311601" //Rich_APM_appkey
#define QQappid   @"1105836079" //QQ登陆APPID

//APP api
//#define Login_Host @"http://183.234.61.201:8081/app/phone/login.action" //登陆

#define Login_Host RequestURL(@"login.action")  //登陆
#define Reg_Host   RequestURL(@"reg.action") //注册
#define UpdateAvatars RequestURL(@"uploadFile")  //更新头像
#define WeChatPayHost RequestURL(@"balanceRecharge.action")  //微信支付
#define GetYanZhengMa RequestURL(@"getMobileCodes.action")  //获取验证码
#define JiaoYanCodes  RequestURL(@"checkCodes.action")  //校验验证码
#define ChangePassWord  RequestURL(@"updatePassword.action")  //更改密码
#define GetPerMes  RequestURL(@"userInfo.action")  //获取用户信息
#define UpdateBase RequestURL(@"updateBase.action")  //修改用户信息
#define GetBalance RequestURL(@"getBalance.action")  //获取用户余额
#define UpdateMobile RequestURL(@"updateMobile.action")  //更换手机号
#define CheckPassWord RequestURL(@"checkPassword.action") //修改密码校验密码接口
//#define ScanQrCode @"http://183.234.61.201:8081/app/phone/scanQrCode.action"  //扫码获取充电桩信息
#define ScanQrCode RequestURL(@"scanQrCode.action")   //扫码获取充电桩信息
#define RecommendList RequestURL(@"recommendList.action")   //获取周边推荐充电站列表
#define Collect RequestURL(@"collect.action")   //收藏充电站
#define CancelCollect RequestURL(@"cancelCollect.action")   //取消收藏充电站
#define CollectionList RequestURL(@"collectionList.action")   //获取收藏列表
#define FeedBack RequestURL(@"feedback.action")   //意见反馈
#define BalanceDetailList RequestURL(@"balanceDetailList.action")   //获取余额明细
#define CheckLastChargingState RequestURL(@"checkCharging.action")   //检测上次充电状态
#define UploadDeviceLocation RequestURL(@"uploadDeviceLocation.action")   //上传设备经纬度
//192.168.1.124:8080

#define PaintingMap RequestURL(@"paintingMap.action")   //获取地图锚点
#define CheckStationDetail RequestURL(@"stationDetail.action")   //查询充电站详情
#define CheckZhouBianCharge RequestURL(@"recommendList.action")   //查询周边电桩
#define ReservationInfoCharge RequestURL(@"reservationInfo.action")   //查看预约信息
#define ReservationCharge RequestURL(@"reserve.action")   //预约电桩
#define CancelCharge RequestURL(@"cancelReservation.action")   //取消预约

#define OutOfLogin RequestURL(@"logout.action")   //退出登陆
#define ChargingLog RequestURL(@"chargingLog.action")   //我的动态
#define UserGuide @"http://120.77.146.167:88/cdy/documents/index.html"  //用户指南 RequestURL(@"login.action")
#define Alipays RequestURL(@"getAlipayParams.action") //支付宝支付

#define WeChatLogin RequestURL(@"weixin_loginAccessToken.action") //微信登陆api
#define BindingPhone RequestURL(@"bindMobile.action") //第三方平台登陆后绑定手机
#define GetWeChatMessage RequestURL(@"weixin_getUserInfo.action") //获取微信用户信息
#define UPloadThirdMes RequestURL(@"uploadLoginInfo.action") //上传第三方平台登陆信息
#define JuDianCharge @"http://120.77.146.167:88/cdy/client/dist/other_station_list.json"//聚电桩数据  RequestURL(@"login.action")


#define ChargeMyCareList RequestURL(@"vehicles.action") //我的车辆列表
#define ChargeAddMyCare RequestURL(@"addVehicle.action") //添加我的车辆
#define ChargeCostList RequestURL(@"chargingList.action") //充电计费规则
#define Chargenumber RequestURL(@"equipmentList.action") //桩位个数接口
#define ChargeMessge RequestURL(@"getCurrentChargInfo.action")

#define ChargeMessageList RequestURL(@"chargingLog.action") //充电记录
//#define WeChatLogin @"https://api.weixin.qq.com/sns/oauth2/access_token"//微信登陆api



#endif
