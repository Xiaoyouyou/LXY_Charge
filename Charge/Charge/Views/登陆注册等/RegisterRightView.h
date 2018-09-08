//
//  RegisterRightView.h
//  Charge
//
//  Created by olive on 16/6/14.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
//状态
//    rightView.ShowSuessMess = ^{
//[MBProgressHUD show:@"短信发送成功" icon:nil view:weakSelf.view];
//};
//rightView.ShowFailMess = ^{
//    [MBProgressHUD show:@"短信发送失败" icon:nil view:weakSelf.view];
//};
//rightView.ShowNetWorkFailMess = ^{
//    [MBProgressHUD show:@"网络连接超时" icon:nil view:weakSelf.view];
//};

@interface RegisterRightView : UIView

@property (copy, nonatomic) NSString *phoneNum;
@property (copy, nonatomic) void(^ShowSuessMess)(void); // 发送成功
@property (copy, nonatomic) void(^ShowFailMess)(void);//发送失败
@property (copy, nonatomic) void(^ShowNetWorkFailMess)(void);//网络错误

@end
