//
//  ChooseTableViewCell.h
//  Charge
//
//  Created by 罗小友 on 2018/11/1.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseModel;
typedef void(^DaoHangEvent)(NSString *la,NSString *lo);

@interface ChooseTableViewCell : UITableViewCell
@property (nonatomic ,copy)DaoHangEvent daohang;
@property (nonatomic ,strong)ChooseModel *model;
@end
