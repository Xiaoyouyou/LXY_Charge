//
//  MyNoticationTableViewCell.m
//  Charge
//
//  Created by 罗小友 on 2018/11/4.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "MyNoticationTableViewCell.h"
#import "MyNoticationModel.h"
@interface MyNoticationTableViewCell()
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *subTitle;

@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *time;
@end


@implementation MyNoticationTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 20;
    
}

-(void)setNotiModel:(MyNoticationModel *)notiModel
{
    self.title.text = notiModel.title;
    self.subTitle.text = notiModel.subTitle;
    self.content.text = [NSString stringWithFormat:@"    %@",notiModel.content];
    self.time.text = notiModel.startDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
