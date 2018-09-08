//
//  QianMingViewController.h
//  Charge
//
//  Created by olive on 16/6/14.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QianMingViewController : UIViewController

@property (copy, nonatomic) void (^QianMingBlock)(NSString *qianMingText);
@property (copy, nonatomic) NSString *qianMing;

@end
