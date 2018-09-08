//
//  TipView.m
//  Charge
//
//  Created by olive on 16/12/2.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "TipView.h"
#import "Masonry.h"
#import "XFunction.h"

@interface TipView()

@property (nonatomic, strong) UIImageView *imageView;//提示图片
@property (nonatomic, strong) UILabel *showLab;//提示语

@end

@implementation TipView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image andshowText:(NSString *)showText;
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(235, 236, 237, 1);
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.imageView];
        
        self.showLab = [[UILabel alloc] init];
        self.showLab.text = showText;
        self.showLab.font = [UIFont systemFontOfSize:14];
        self.showLab.textColor = [UIColor blackColor];
        self.showLab.textAlignment = NSTextAlignmentCenter;
        [self.showLab sizeToFit];
        [self addSubview:self.showLab];
    }
    return self;
}

//偏上显示的约束
-(void)SetUpMasonry
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(150);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(126, 126));
    }];
    
    [self.showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
    }];
}

//居中的约束
-(void)SetCenterMasonry
{
  [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self).offset(100);
      make.centerX.equalTo(self);
      make.size.mas_equalTo(CGSizeMake(126, 126));
  }];
    
 [self.showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
    }];
    
}

@end
