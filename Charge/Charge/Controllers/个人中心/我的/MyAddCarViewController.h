//
//  MyAddCarViewController.h
//  Charge
//
//  Created by 罗小友 on 2018/10/17.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCarListModel;
@interface MyAddCarViewController : UIViewController
@property (nonatomic ,strong)NSString *titles;
@property (nonatomic ,strong)NSString *careID;
@property (nonatomic ,strong)MyCarListModel *carModel;
@end
