//
//  ChangeNewNameViewController.h
//  Charge
//
//  Created by olive on 16/6/15.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKAvoidKeyboardViewController.h"


@interface ChangeNewNameViewController : WKAvoidKeyboardViewController

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) void(^ReturnTextBlock)(NSString *nameText);

@end
