//
//  NavView.m
//  Charge
//
//  Created by olive on 16/12/9.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "NavView.h"
#import "Masonry.h"
#import "XFunction.h"


@interface NavView ()
{
    UILabel *showLab;
    UIView *lineView;
    UIImageView *imageView;//左边图片
    UIImageView *rightImageView;//右边图片

    UIView *tapView;//左边手势按钮
    UIView *rightTapView;//右边的手势按钮
    
    UIButton *rightBtn;
    UIButton *rightBtn1;
}

@end

@implementation NavView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        //标题
//        self.backgroundColor = RGB_COLOR(29, 167, 145, 1.0);
        self.backgroundColor = [UIColor whiteColor];
        showLab = [[UILabel alloc] init];
        showLab.text = title;
//        showLab.font = [UIFont fontWithName:@"Helvetica Bold" size:16];
        showLab.font = [UIFont systemFontOfSize:16];
        showLab.textColor = [UIColor blackColor];
        showLab.textAlignment = NSTextAlignmentCenter;
        [showLab sizeToFit];
        [self addSubview:showLab];
        
        //线
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.3;
        [self addSubview:lineView];
        
        //返回
        imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"back@2x.png"];
        [self addSubview:imageView];
        
        //tapView
        tapView = [[UIView alloc] init];
        [self addSubview:tapView];
        
        //返回手势
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] init]initWithTarget:self action:@selector(back)];
        [tapView addGestureRecognizer:tap];
        
        //添加right按钮
        
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 0, 0);
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn addTarget: self action:@selector(rightBtnlAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        
        [self MakeMasonry];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title rightTitle:(NSString *)rightTitle//设置右边按钮初始化
{
    if (self = [super initWithFrame:frame]) {
        //标题
//        self.backgroundColor = RGB_COLOR(29, 167, 145, 1.0);
        self.backgroundColor = [UIColor whiteColor];
        showLab = [[UILabel alloc] init];
        showLab.text = title;
//        showLab.font = [UIFont fontWithName:@"Helvetica Bold" size:15];
        showLab.font = [UIFont systemFontOfSize:16];
        showLab.textColor = [UIColor blackColor];
        showLab.textAlignment = NSTextAlignmentCenter;
        [showLab sizeToFit];
        [self addSubview:showLab];
        
        //线
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.3;
        [self addSubview:lineView];
        
        //返回
        imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"back@2x.png"];
        [self addSubview:imageView];
        
        //tapView
        tapView = [[UIView alloc] init];
        [self addSubview:tapView];
        
        //返回手势
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] init]initWithTarget:self action:@selector(back)];
        [tapView addGestureRecognizer:tap];
        
        //添加right按钮
        
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 0, 0);
        [rightBtn sizeToFit];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   //   [rightBtn addTarget: self action:@selector(rightBtnlAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        
        //rightTapView
        rightTapView = [[UIView alloc] init];
        [self addSubview:rightTapView];
        
        //右边按钮手势
        UITapGestureRecognizer *RightTap = [[[UITapGestureRecognizer alloc] init]initWithTarget:self action:@selector(rightTapViewAction)];
        [rightTapView addGestureRecognizer:RightTap];
        
        [self MakeMasonry];
        [self setRightBtnTitleMasonry];
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame title:(NSString *)title leftImgae:(NSString *)leftImage rightImage:(NSString *)rightImage
{
    if (self = [super initWithFrame:frame]) {
        //标题
//       self.backgroundColor = RGB_COLOR(29, 167, 145, 1.0);
        self.backgroundColor = [UIColor whiteColor];
        showLab = [[UILabel alloc] init];
        showLab.text = title;
        //        showLab.font = [UIFont fontWithName:@"Helvetica Bold" size:15];
        showLab.font = [UIFont systemFontOfSize:16];
        showLab.textColor = [UIColor blackColor];
        showLab.textAlignment = NSTextAlignmentCenter;
        [showLab sizeToFit];
        [self addSubview:showLab];
        
        //线
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.3;
        [self addSubview:lineView];
        
        //左边的图片
        imageView = [[UIImageView alloc] init];
        [imageView sizeToFit];
        imageView.image = [UIImage imageNamed:leftImage];
        
        [self addSubview:imageView];
        
        //tapView
        tapView = [[UIView alloc] init];
        [self addSubview:tapView];
        
        //返回手势
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] init]initWithTarget:self action:@selector(back)];
        [tapView addGestureRecognizer:tap];
        
        //右边的图片
        rightImageView = [[UIImageView alloc] init];
        [rightImageView sizeToFit];
        rightImageView.image = [UIImage imageNamed:rightImage];
        
        [self addSubview:rightImageView];
        
        
        //rightTapView
        rightTapView = [[UIView alloc] init];
        [self addSubview:rightTapView];
        
        //右边按钮手势
        UITapGestureRecognizer *RightTap = [[[UITapGestureRecognizer alloc] init]initWithTarget:self action:@selector(rightTapViewAction)];
        [rightTapView addGestureRecognizer:RightTap];
        
        [self MakeMasonry];
        [self setRightBtnMasonry];
        
    }
    return self;
}

//左边图片返回按钮 右边文字按钮
- (id)initWithFrame:(CGRect)frame title:(NSString *)title leftImgae:(NSString *)leftImage rightButton:(NSString *)rightStr
{
    if (self = [super initWithFrame:frame]) {
        //标题
//        self.backgroundColor = RGB_COLOR(29, 167, 145, 1.0);
        self.backgroundColor = [UIColor whiteColor];
        showLab = [[UILabel alloc] init];
        showLab.text = title;
        //        showLab.font = [UIFont fontWithName:@"Helvetica Bold" size:15];
        showLab.font = [UIFont systemFontOfSize:16];
        showLab.textColor = [UIColor blackColor];
        showLab.textAlignment = NSTextAlignmentCenter;
        [showLab sizeToFit];
        [self addSubview:showLab];
        
        //线
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.3;
        [self addSubview:lineView];
        
        //左边的图片
        imageView = [[UIImageView alloc] init];
        [imageView sizeToFit];
        imageView.image = [UIImage imageNamed:leftImage];
        
        [self addSubview:imageView];
        
        //tapView
        tapView = [[UIView alloc] init];
        [self addSubview:tapView];
        
        //返回手势
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] init]initWithTarget:self action:@selector(back)];
        [tapView addGestureRecognizer:tap];
        
        //右边的btn
        rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn1 setTitle:rightStr forState:UIControlStateNormal];
        rightBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [rightBtn1 addTarget:self action:@selector(rightTapViewAction) forControlEvents:UIControlEventTouchDown];
        [self addSubview:rightBtn1];
        
        
//        //rightTapView
//        rightTapView = [[UIView alloc] init];
//        [self addSubview:rightTapView];
//
//        //右边按钮手势
//        UITapGestureRecognizer *RightTap = [[[UITapGestureRecognizer alloc] init]initWithTarget:self action:@selector(rightTapViewAction)];
//        [rightTapView addGestureRecognizer:RightTap];
        
        [self MakeMasonry];
        [self setRightBtnMasonry];
        
    }
    return self;
}



-(void)MakeMasonry
{
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(self);
       make.left.equalTo(self);
       make.right.equalTo(self);
       make.height.mas_equalTo(0.5);
    }];
  
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-12);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(CGSizeMake(21,21));
    }];
    
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(44);
    }];
    
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.centerX.equalTo(self);
        make.centerY.equalTo(imageView);
    }];
}



-(void)setRightBtnMasonry //设置右边按钮约束
{
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-12);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(CGSizeMake(21,21));
    }];
    
    [rightTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(44);
    }];
 
    [rightBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(showLab);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(65);
    }];
}


-(void)setRightBtnTitleMasonry
{
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(showLab);
        make.right.equalTo(self).offset(-15);
    }];
    
    [rightTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(44);
    }];
   

}

#pragma mark - action


-(void)rightTapViewAction
{
    [self rightBtnlAction];
}

-(void)rightBtnlAction
{
    if (self.rightBlock) {
        self.rightBlock();
    }
}

-(void)back
{
    if (self.backBlock) {
        self.backBlock();
    }
}

@end
