//
//  MyCarTableViewCell.h
//  Charge
//
//  Created by 罗小友 on 2018/10/21.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCarListModel.h"

typedef void(^ChangeBlock)(void);
typedef void(^CancelBlock)(void);
@interface MyCarTableViewCell : UITableViewCell
@property (copy, nonatomic) ChangeBlock change;
@property (copy, nonatomic) CancelBlock cancel;
@property (strong, nonatomic) IBOutlet UIImageView *chargeIamge;
@property (strong, nonatomic) IBOutlet UILabel *CarModels;
@property (strong, nonatomic) IBOutlet UILabel *CarNumber;
@property (strong, nonatomic) IBOutlet UILabel *CarChargeType;
@property (nonatomic ,strong)MyCarListModel *listModel;

+(instancetype)creatMyCarCell;
@end
