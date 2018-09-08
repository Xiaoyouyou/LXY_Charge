//
//  MyTextView.m
//  xuemiyun
//
//  Created by xueyiwangluo on 15/3/30.
//  Copyright (c) 2015年 广州学易网络科技有限公司. All rights reserved.
//

#import "MyTextView.h"
#import "XFunction.h"

@implementation MyTextView

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = [[UILabel alloc] initWithFrame:CGRectMake(14, 7, 292, 20)];
        self.placeholder.text = placeholder;
        self.placeholder.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
        self.placeholder.textAlignment = NSTextAlignmentLeft;
        self.placeholder.font = [UIFont systemFontOfSize:15];
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = RGBA(34, 24, 21, 1);
        [self addSubview:self.placeholder];
        self.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 0);
        
//        [self createToolBar];
    }
    return self;
}

-(void)createToolBar
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height + 2, XYScreenWidth, 33)];
    
    //设置style
    
    [toolBar setBarStyle:UIBarStyleDefault];
    
    toolBar.backgroundColor = LightGrayBgColor;
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    doneBtn.frame = CGRectMake(0, 0, 40, 30);
    
    [doneBtn addTarget:self action:@selector(resignKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    
    //在toolBar上加上这些按钮
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    
    [toolBar setItems:buttonsArray];

    [self setInputAccessoryView:toolBar];
}

//隐藏键盘
- (void)resignKeyboard {
    [self resignFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
