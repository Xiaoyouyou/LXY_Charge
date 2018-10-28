//
//  ChargeNumberCell.h
//  Charge
//
//  Created by 罗小友 on 2018/10/28.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargeNumberModel1.h"
#import "ChargeNumberModel2.h"
@interface ChargeNumberCell : UITableViewCell

@property (strong, nonatomic) ChargeNumberModel1 *model1;
@property (strong, nonatomic) ChargeNumberModel1 *model2;
@property (strong, nonatomic) IBOutlet UIImageView *ZhuangImage;
@property (strong, nonatomic) IBOutlet UILabel *ZhuangID;
@property (strong, nonatomic) IBOutlet UIProgressView *ProgressA;
@property (strong, nonatomic) IBOutlet UIProgressView *progressB;
@property (strong, nonatomic) IBOutlet UILabel *statusA;
@property (strong, nonatomic) IBOutlet UILabel *statusB;

@property (strong, nonatomic) IBOutlet UILabel *labelA;
@property (strong, nonatomic) IBOutlet UILabel *labelB;
@end
