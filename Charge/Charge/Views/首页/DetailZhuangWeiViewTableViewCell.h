//
//  DetailZhuangWeiViewTableViewCell.h
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailZhuangWeiViewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *zhuangNum;//桩号
@property (strong, nonatomic) IBOutlet UIImageView *status;//状态
@property (strong, nonatomic) IBOutlet UILabel *types;//快和慢
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;//状态图片

@end
