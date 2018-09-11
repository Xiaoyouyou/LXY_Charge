//
//  DetailZhuangBtnView.m
//  Charge
//
//  Created by 罗小友 on 2018/9/11.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import "DetailZhuangBtnView.h"
#import "API.h"

@interface DetailZhuangBtnView()
@property (nonatomic ,strong)UIButton *btnStatus;
@end

@implementation DetailZhuangBtnView

-(instancetype)initWithFrame:(CGRect)frame count:(NSUInteger)count{
    
    if (self == [super initWithFrame:frame]) {
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:self.bounds];
        scroll.showsHorizontalScrollIndicator = NO;
        [self addSubview:scroll];
        CGFloat btnX = 0;
        CGFloat btnY = 3;
        CGFloat btnW = (XYScreenWidth - 50)/4;
        CGFloat btnH = 30;
        scroll.contentSize = CGSizeMake(count * (btnW + 10) + 10, btnH);
        for (int i = 0; i < count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(changePrice:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"00:00 - 23:59" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor blackColor] forState:normal];
            [btn.titleLabel sizeToFit];
            btnX = i * (btnW + 10) + 10;
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 4;
            btn.layer.masksToBounds = YES;
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            NSLog(@"btnY:%lf",btnY);
            btn.tag = i;
            [scroll addSubview:btn];
           
        }
   
    }
    
    
    return  self;
}


-(void)changePrice:(UIButton *)button{
    
    if (_btnStatus == nil){
        button.selected = YES;
        _btnStatus = button;
    }
    else if (_btnStatus !=nil && _btnStatus == button){
        button.selected = YES;
        
    }
    else if (_btnStatus!= button && _btnStatus!=nil){
        _btnStatus.selected = NO;
        button.selected = YES;
        _btnStatus = button;
        
    }
    
    self.btnClickBlock(button);
    NSLog(@"点击的是:%ld",button.tag);
}

@end
