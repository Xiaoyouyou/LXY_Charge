//
//  XFunction.h
//  xuemiyun
//
//  Created by xueyiwangluo on 15/1/12.
//  Copyright (c) 2015年 广州学易网络科技有限公司. All rights reserved.
//
#define RegisterVcTextfielTag 100
#define RegisterVcTextfielTag1 101
#define LogingVCTextfielTag2 102
#define ChangePassWordVCTag3 103
#define ChangePassWordVCTag4 104
#define ReplacePhoneNumVCTag5 105
#define ReplacePhoneNumVCTag6 106

#define PersonMesNoti         @"PersonMesNoti"
#define PersonMesNotis        @"PersonMesNotis"
#define ChangePassWordNoti    @"ChangePassWordNoti"
#define ChangePassWordNotis   @"ChangePassWordNotis"
#define ReplacePhoneNumNoti   @"ReplacePhoneNumNoti"
#define ReplacePhoneNumNotis  @"ReplacePhoneNumNotis"

#define CheckChargingNotis  @"CheckChargingNotis"//新手机登陆检查状态通知

#define LeaveOutNoti  @"LeaveOutNot"
#define ChangeNewName @"ChangeNewName"//更新名字通知
#define ChangeNewAvatar @"ChangeNewAvatar"//更新头像通知
#define ChargeingMessage @"ChargeingMessage"//更新首页正在充电状态通知
#define EndChargeingMessage @"EndChargeingMessage"//结束首页正在充电状态通知
#define YiChangLogin @"YiChangLogin"//异常登陆通知
#define TouchSaoMa @"3DtouchSaoMa"//3Dtouch扫码通知
#define JiTingChargeNot @"JiTingChargeNot"//急停停止充电通知
#define UNenoughChargeNot @"UNenoughChargeNot"//急停停止充电通知
#define ThirdLoginPush @"thirdLoginPush"//第三方登陆推出通知

//tableviewCell字体
#define TableViewCellFont [UIFont systemFontOfSize:15];
#define TableViewCellFuTitleFont [UIFont systemFontOfSize:13];


//是否iPhone5
#define IS_IPHONE_5_SCREEN [[UIScreen mainScreen] bounds].size.height >= 568.0f && [[UIScreen mainScreen] bounds].size.height < 1024.0f
//是否iPhone5以上的
#define IS_IPHONE_5UP_SCREEN [[UIScreen mainScreen] bounds].size.height > 960.0f

//是否iphone6以下的
#define IS_IPHONE_6DOWN_SCREEN [[UIScreen mainScreen] bounds].size.height < 1334.0f
//是否iphone6以上的
#define IS_IPHONE_6UP_SCREEN [[UIScreen mainScreen] bounds].size.height > 1334.0f

#define IsIphone4           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize (CGSizeMake(640, 960),\
[[UIScreen mainScreen] currentMode].size) :NO)

// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

//// 是否iPhone6以下
//#define isBeforeIPone6      [[UIScreen mainScreen] bounds].size.height >= 960.0f && [[UIScreen mainScreen] bounds].size.height <= 1136.0f
// 是否iPhone6
#define isIPone6      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(750, 1334), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否iPone6Plus
#define isIPone6Plus      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1242, 2208), \
[[UIScreen mainScreen] currentMode].size) : \
NO)
//414*3=1242
//736*3=2208

#ifdef DEBUG
#define MYLog(...)                  NSLog(__VA_ARGS__)
#else
#define MYLog(...)
#endif

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define iOS7_0 @"7.0"

#define kIsIOS7 [UIDevice currentDevice].systemVersion.floatValue >= 7.0f


//颜色和透明度设置
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

#define MyBlueColor                 RGBA(48, 130, 219, 1)
#define MyOrangeColor               RGBA(255, 102, 51, 1)
#define LightGrayBgColor            RGBA(242, 242, 242, 1)
#define MyTextColorBlack            RGBA(35, 24, 21, 1)
#define MyTextColorGray             RGBA(154, 153, 153, 1)

#define ViewStartX(view)               (view).frame.origin.x
#define ViewStartY(view)               (view).frame.origin.y
#define ViewWidth(view)                (view).frame.size.width
#define ViewHeight(view)               (view).frame.size.height

#define ISLOGINED                       @"isLogined"

#define KEYPASSWORD                     @"userPassword"
#define KEYMEMBER_NO                    @"member_no"
#define KEYMEMBER_NAME                  @"member_name"
#define KEYMEMBER_ID                    @"fr_member_id"
#define KEYAPPTOKEN                     @"apptoken"
#define KEYTOKEN                        @"token"
#define KEYEMAIL                        @"email"
#define KEYPHONENUMBER                  @"phoneNumber"
#define KEYHEADICON                     @"head_icon"

#define FLAG_LABEL                      @"label"
#define FLAG_CLASSIFICATION             @"classification"
#define FLAG_SHARE                      @"share"
#define FLAG_ASKQUESTION                @"askquestion"
#define FLAG_PRAISE                     @"praise"
#define FLAG_COMMENT                    @"comment"
#define FLAG_ADOPT                      @"adopt"

#define FLAG_GETVERIFICATION            @"verification"
#define FLAG_SUBMIT                     @"submit"
#define FLAG_LOGIN                      @"login"
#define FLAG_CREATEPLATE                @"create_plate"
#define FLAG_DEFAULTPLATE               @"default_plate"
#define FLAG_CREATEGROUP                @"create_group"
#define FLAG_EXITGROUP                  @"exit_group"
#define FLAG_CREATEFAVORITE             @"create_favorite"
#define FLAG_COLLECTION                 @"collection"
#define FLAG_CANCELCOLLECTION           @"cancel_collection"
#define FLAG_DOWNLOAD                   @"download"
#define FLAG_ADDCONCERN                 @"addConcern"
#define FLAG_ADDADDRESS                 @"addAddress"
#define FLAG_MODIFYADDRESS              @"modifyAddress"
#define FLAG_SUBMITCHATBOOK             @"submitChatBook"

#define FLAG_ENDLOAD                    @"endLoad"

#define FLAG_CLOSE                      @"close"
#define FLAG_DELETE                     @"delete"

#define FLAG_UPLOADIMG                  @"upload_img"
#define FLAG_UPLOADHEADIMAGE            @"upload_headImage"

#define FLAG_SETGROUPTOP                @"set_grounp_top"

#define TIMEFORMAT                      @"yyyy-MM-dd HH:mm:ss"
#define TIMESTAMP                       @"yyyyMMddHHmmss"//时间戳格式

#define XYScreenWidth [UIScreen mainScreen].bounds.size.width
#define XYScreenHeight [UIScreen mainScreen].bounds.size.height

#define TITLEBAT_HEIGHT                 64
#define BOTTOMBAR_HEIGHT                49
#define NAVIGATIONBAR_HEIGHT            44
#define STATUSBAR_HEIGHT                20
#define TAB_BUTTON_HEIGHT               50

//整个屏分成四块，从上到下分别为：TITLEBAT_HEIGHT TAB_BUTTON_HEIGHT CONTENT_HEIGHT BOTTOMBAR_HEIGHT
//TITLEBAT_HEIGHT 标题栏高度
//TAB_BUTTON_HEIGHT 标题样下如果TAB选项卡的高度
//CONTENT_HEIGHT 内容的高度
//BOTTOMBAR_HEIGHT 底部导航栏的高度
//CONTENT_TAB 隐藏Tab后内容的高度

//除去标题 Tab 底部导航的高度
#define CONTENT_HEIGHT              XYScreenHeight - TITLEBAT_HEIGHT - TAB_BUTTON_HEIGHT - BOTTOMBAR_HEIGHT
//内容高度与Tab的高度
#define CONTENT_TAB_HEIGHT          XYScreenHeight - TITLEBAT_HEIGHT - BOTTOMBAR_HEIGHT
//除去标题栏的高度
#define CONTENT_TAB_BOTTOM_HEIGHT   XYScreenHeight - TITLEBAT_HEIGHT

#define TOOLBAR_HEIGHT                          40//33
#define KEYBOARD_HEIGHT                         40//33
//一像素线
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)

//宏抽取单例
#define SingleStatement(name)                         + (id)shared##name;
#define SingleDefinition(name)                        static id _instace = nil;\
+ (instancetype)shared##name\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instace = [[[self class] alloc] init];\
    });\
    return _instace;\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        if (_instace == nil) {\
            _instace = [super allocWithZone:zone];\
        }\
    });\
    return _instace;\
}

typedef void (^ModalCallback) (NSDictionary *dic);
typedef void (^StringCallback) (NSString *str);
