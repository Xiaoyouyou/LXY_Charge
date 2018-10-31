//
//  ChooseView.m
//  Charge
//
//  Created by 罗小友 on 2018/10/31.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "ChooseView.h"

@interface ChooseView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIScrollView *scroll;
@end

@implementation ChooseView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubViews:frame];
    };
    return self;
};
//创建子view
-(void)addSubViews:(CGRect)frame{
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYScreenWidth, 44)];
    NSArray *btnTitle = @[@"距离最近",@"价格最低",@"筛选"];
    for (int i = 0; i < btnTitle.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%@",btnTitle[i]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i * (XYScreenWidth / 3), 0, XYScreenWidth / 3, 44);
        btn.tag = i;
        [btn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchDown];
        [topBackView addSubview:btn];
    }
    [self addSubview:topBackView];
    //添加tableView
    //添加tableView
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44, XYScreenWidth, XYScreenHeight - 44)];
    self.scroll = scroll;
    scroll.backgroundColor = RGB_COLOR(109, 109, 109, 1.0);
    [self addSubview:scroll];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 6, XYScreenWidth, XYScreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [scroll addSubview:table];
   
}
-(void)chooseType:(UIButton *)btn{
    NSLog(@"点击了按钮--%ld",btn.tag);
   
}
@end
