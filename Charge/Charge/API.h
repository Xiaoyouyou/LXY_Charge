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


//APPKey
#define WeChat_appkey    @"wx99369c2484d2a152" //微信APPkey
#define BaiDuMap_appkey  @"DDOXVg1C3et2vlrZwzSvwLlhHPCQkcsh" //百度APPkey
#define YouMeng_appkey   @"5840e455c895767de90010ae" //友盟APPkey
#define WeChat_appSecret @"7aacd13968afdcce98968bf57290eb55" //微信APPSecret
#define JPUSH_appkey   @"34315539ed9431af470f4cf0" //极光推送APPkey
#define Rich_APM_appkey   @"a4d6715be1384a8bab9b663de6311601" //Rich_APM_appkey
#define QQappid   @"1105836079" //QQ登陆APPID

//APP api
#define Login_Host @"http://183.234.61.201:8081/app/phone/login.action" //登陆
#define Reg_Host   @"http://183.234.61.201:8081/app/phone/reg.action"//注册
#define UpdateAvatars @"http://183.234.61.201:8081/app/phone/uploadFile" //更新头像
#define WeChatPayHost @"http://183.234.61.201:8081/app/phone/balanceRecharge.action" //微信支付
#define GetYanZhengMa @"http://183.234.61.201:8081/app/phone/getMobileCodes.action" //获取验证码
#define JiaoYanCodes  @"http://183.234.61.201:8081/app/phone/checkCodes.action" //校验验证码
#define ChangePassWord  @"http://183.234.61.201:8081/app/phone/updatePassword.action" //更改密码
#define GetPerMes  @"http://183.234.61.201:8081/app/phone/userInfo.action" //获取用户信息
#define UpdateBase @"http://183.234.61.201:8081/app/phone/updateBase.action" //修改用户信息
#define GetBalance @"http://183.234.61.201:8081/app/phone/getBalance.action" //获取用户余额
#define UpdateMobile @"http://183.234.61.201:8081/app/phone/updateMobile.action" //更换手机号
#define CheckPassWord @"http://183.234.61.201:8081/app/phone/checkPassword.action"//修改密码校验密码接口
#define ScanQrCode @"http://183.234.61.201:8081/app/phone/scanQrCode.action"  //扫码获取充电桩信息
#define RecommendList @"http://183.234.61.201:8081/app/phone/recommendList.action"  //获取周边推荐充电站列表
#define Collect @"http://183.234.61.201:8081/app/phone/collect.action"  //收藏充电站
#define CancelCollect @"http://183.234.61.201:8081/app/phone/cancelCollect.action"  //取消收藏充电站
#define CollectionList @"http://183.234.61.201:8081/app/phone/collectionList.action"  //获取收藏列表
#define FeedBack @"http://183.234.61.201:8081/app/phone/feedback.action"  //意见反馈
#define BalanceDetailList @"http://183.234.61.201:8081/app/phone/balanceDetailList.action"  //获取余额明细
#define CheckLastChargingState @"http://183.234.61.201:8081/app/phone/checkCharging.action"  //检测上次充电状态
#define UploadDeviceLocation @"http://183.234.61.201:8081/app/phone/uploadDeviceLocation.action"  //上传设备经纬度
//192.168.1.124:8080

#define PaintingMap @"http://183.234.61.201:8081/app/phone/paintingMap.action"  //获取地图锚点
#define CheckStationDetail @"http://183.234.61.201:8081/app/phone/stationDetail.action"  //查询充电站详情
#define CheckZhouBianCharge @"http://183.234.61.201:8081/app/phone/recommendList.action"  //查询周边电桩
#define ReservationInfoCharge @"http://183.234.61.201:8081/app/phone/reservationInfo.action"  //查看预约信息
#define ReservationCharge @"http://183.234.61.201:8081/app/phone/reserve.action"  //预约电桩
#define CancelCharge @"http://183.234.61.201:8081/app/phone/cancelReservation.action"  //取消预约
#define OutOfLogin @"http://183.234.61.201:8081/app/phone/logout.action"  //退出登陆
#define ChargingLog @"http://183.234.61.201:8081/app/phone/chargingLog.action"  //我的动态
#define UserGuide @"http://183.234.61.201:8081/cdy/documents/index.html"  //用户指南
#define Alipays @"http://183.234.61.201:8081/app/phone/getAlipayParams.action"//支付宝支付

#define WeChatLogin @"http://183.234.61.201:8081/app/phone/weixin_loginAccessToken.action"//微信登陆api
#define BindingPhone @"http://183.234.61.201:8081/app/phone/bindMobile.action"//第三方平台登陆后绑定手机
#define GetWeChatMessage @"http://183.234.61.201:8081/app/phone/weixin_getUserInfo.action"//获取微信用户信息
#define UPloadThirdMes @"http://183.234.61.201:8081/app/phone/uploadLoginInfo.action"//上传第三方平台登陆信息


#define JuDianCharge @"http://183.234.61.201:8081/cdy/client/dist/other_station_list.json"//聚电桩数据
//#define WeChatLogin @"https://api.weixin.qq.com/sns/oauth2/access_token"//微信登陆api



#endif
