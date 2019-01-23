//
//  ChargeNumberCell.m
//  Charge
//
//  Created by 罗小友 on 2018/10/28.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "ChargeNumberCell.h"
#import "ChargeNumberModel1.h"
#import "ChargeNumberModel2.h"

@interface ChargeNumberCell()

@property (nonatomic ,strong) ChargeNumberModel1 *model;
@end
@implementation ChargeNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel1:(ChargeNumberModel1 *)model1{
    self.model = model1;
    self.labelA.text = [NSString stringWithFormat:@"%@%%",model1.soc];
    float a = model1.soc.floatValue / 100.00;
    self.ProgressA.progress = a;
    self.ProgressA.layer.masksToBounds = YES;
    self.ProgressA.layer.cornerRadius = 3.0;
    self.ProgressA.layer.borderWidth = 1.0;
    self.ProgressA.layer.borderColor = [UIColor blackColor].CGColor;
    
//    ，04，05，06    情况下，统一显示故障
//    00，情况下，统一显示可用
//    01,02,03      情况下，统一显示占用
    if ([model1.status isEqualToString:@"10"] || [model1.status isEqualToString:@"04"] || [model1.status isEqualToString:@"05"] || [model1.status isEqualToString:@"06"] || [model1.status isEqualToString:@"-1"]) {
     self.statusA.text = [NSString stringWithFormat:@"故障"];
        self.statusA.textColor = [UIColor redColor];
    }else if ([model1.status isEqualToString:@"01"] || [model1.status isEqualToString:@"02"] || [model1.status isEqualToString:@"03"]){
        self.statusA.text = [NSString stringWithFormat:@"占用"];
        self.statusA.textColor = [UIColor redColor];
    }else if ([model1.status isEqualToString:@"00"]){
        self.statusA.text = [NSString stringWithFormat:@"可用"];
        self.statusA.textColor = [UIColor greenColor];
    }
}


-(void)setModel2:(ChargeNumberModel1 *)model2{
    NSLog(@"model=%@",self.model.soc);
    self.labelB.text = [NSString stringWithFormat:@"%@%%",model2.soc];
     float a = model2.soc.floatValue / 100.00;
    self.progressB.progress = a;
    self.progressB.layer.masksToBounds = YES;
    self.progressB.layer.cornerRadius = 3.0;
    self.progressB.layer.borderWidth = 1.0;
    self.progressB.layer.borderColor = [UIColor blackColor].CGColor;
    if ([model2.status isEqualToString:@"10"] || [model2.status isEqualToString:@"04"] || [model2.status isEqualToString:@"05"] || [model2.status isEqualToString:@"06"] || [model2.status isEqualToString:@"-1"]) {
        self.statusB.text = [NSString stringWithFormat:@"故障"];
        self.statusB.textColor = [UIColor redColor];
    }else if ([model2.status isEqualToString:@"01"] || [model2.status isEqualToString:@"02"] || [model2.status isEqualToString:@"03"]){
        self.statusB.text = [NSString stringWithFormat:@"占用"];
        self.statusB.textColor = [UIColor redColor];
    }else if ([model2.status isEqualToString:@"00"]){        
        self.statusB.text = [NSString stringWithFormat:@"可用"];
        self.statusB.textColor = [UIColor greenColor];
    }
    
    //判断显示哪张图片
    if (([self.model.status isEqualToString:@"10"] || [self.model.status isEqualToString:@"04"] || [self.model.status isEqualToString:@"05"] || [self.model.status isEqualToString:@"06"] || [self.model.status isEqualToString:@"-1"] ||[self.model.status isEqualToString:@"01"] || [self.model.status isEqualToString:@"02"]) & ([model2.status isEqualToString:@"10"] || [model2.status isEqualToString:@"04"] || [model2.status isEqualToString:@"05"] || [model2.status isEqualToString:@"06"] || [model2.status isEqualToString:@"-1"] || [model2.status isEqualToString:@"01"] || [model2.status isEqualToString:@"02"] || [model2.status isEqualToString:@"03"])) {
        self.ZhuangImage.image = [UIImage imageNamed:@"left_red.png"];
    }else if (([self.model.status isEqualToString:@"10"] || [self.model.status isEqualToString:@"04"] || [self.model.status isEqualToString:@"05"] || [self.model.status isEqualToString:@"06"] || [self.model.status isEqualToString:@"-1"] ||[self.model.status isEqualToString:@"01"] || [self.model.status isEqualToString:@"02"]) & ([model2.status isEqualToString:@"00"])){
         self.ZhuangImage.image = [UIImage imageNamed:@"red.png"];
    }else if (([model2.status isEqualToString:@"10"] || [model2.status isEqualToString:@"04"] || [model2.status isEqualToString:@"05"] || [model2.status isEqualToString:@"06"] || [model2.status isEqualToString:@"-1"] || [model2.status isEqualToString:@"01"] || [model2.status isEqualToString:@"02"] || [model2.status isEqualToString:@"03"]) & [self.model.status isEqualToString:@"00"]){
        self.ZhuangImage.image = [UIImage imageNamed:@"red.png"];
    }else if ([model2.status isEqualToString:@"00"] & [self.model.status isEqualToString:@"00"]){
         self.ZhuangImage.image = [UIImage imageNamed:@"green.png"];
    }
    
    
    
}
@end
