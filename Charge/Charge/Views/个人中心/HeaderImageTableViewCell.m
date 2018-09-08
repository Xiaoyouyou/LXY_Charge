//
//  HeaderImageTableViewCell.m
//  Charge
//
//  Created by olive on 16/6/7.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "HeaderImageTableViewCell.h"
#import "XFunction.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "PersonMessage.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "Config.h"
#import "UIImageView+WebCache.h"
#import "API.h"
#import "WMNetWork.h"

@interface HeaderImageTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation HeaderImageTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
  
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width*0.5;
    self.headerImageView.layer.borderWidth = 1;
    self.headerImageView.layer.borderColor = RGBA(29, 167, 146, 1).CGColor;
    MYLog(@" NEW frame = %@",NSStringFromCGRect(self.headerImageView.frame));
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setNewImageUrl:(NSString *)NewImageUrl
{
    _NewImageUrl = NewImageUrl;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:NewImageUrl] placeholderImage:[UIImage imageNamed:@"grayIcon"] options:SDWebImageRefreshCached];
}

@end
