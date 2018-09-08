//
//  YuYueTableViewCell.m
//  Charge
//
//  Created by olive on 16/6/30.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "YuYueTableViewCell.h"


@interface YuYueTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (strong, nonatomic) IBOutlet UILabel *addressLab;//地址
@property (strong, nonatomic) IBOutlet UILabel *distanceLab;//距离
@property (strong, nonatomic) IBOutlet UILabel *priceLab;//价格/度

@end

@implementation YuYueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - set方法
-(void)setPrice:(NSString *)price
{
    _price = price;
    self.priceLab.text = price;
}


-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLab.text = title;
   
}

-(void)setAddress:(NSString *)address
{
    _address = address;
    self.addressLab.text = address;
}

-(void)setDistance:(NSString *)distance
{
    _distance = distance;
    self.distanceLab.text = distance;
    
}


@end
