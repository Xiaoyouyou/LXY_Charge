//
//  MyCarTableViewCell.h
//  Charge
//
//  Created by 罗小友 on 2018/10/21.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCarTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *CarModels;
@property (strong, nonatomic) IBOutlet UILabel *CarNumber;
@property (strong, nonatomic) IBOutlet UILabel *CarChargeType;


+(instancetype)creatMyCarCell;
@end
