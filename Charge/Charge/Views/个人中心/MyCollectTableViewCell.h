//
//  MyCollectTableViewCell.h
//  Charge
//
//  Created by olive on 16/6/7.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString *fastLabs;//快充
@property (copy, nonatomic) NSString *slowLabs;//慢充
@property (copy, nonatomic) NSString *addresss;//地址
@property (copy, nonatomic) NSString *titleNames;//标题名字
@property (copy, nonatomic) NSString *distance;//距离

@property (copy, nonatomic) void(^daoHangBlock)(void);//导航


@end
