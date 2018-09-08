//
//  SearchMessageTableViewCell.m
//  Charge
//
//  Created by olive on 16/7/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "SearchMessageTableViewCell.h"
#import "XFunction.h"


@interface SearchMessageTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (strong, nonatomic) IBOutlet UILabel *addressLab;//地址

@end

@implementation SearchMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    MYLog(@"title = %@",title);
    self.titleLab.text = title;
}

-(void)setAddress:(NSString *)address
{
    _address = address;
    self.addressLab.text = address;
}

@end
