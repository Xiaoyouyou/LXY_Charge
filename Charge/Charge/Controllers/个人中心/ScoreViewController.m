//
//  ScoreViewController.m
//  Charge
//
//  Created by olive on 17/4/13.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import "ScoreViewController.h"
#import "JiFenTableViewCell.h"
#import "XFunction.h"
#import "Masonry.h"
#import "NavView.h"

@interface ScoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataArray;//数据源
    UILabel *jifenLab;//积分
    UIButton *jifenBtnLab;//积分des按钮
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"我的积分" leftImgae:@"back" rightImage:@"guize"];
    nav.backBlock = ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    [self.view addSubview:nav];
    //绿色背景view
    UIView *greenView = [[UIView alloc] init];
    greenView.backgroundColor = RGBA(23, 179, 165, 1);
    [self.view addSubview:greenView];
    
    //积分
    jifenLab = [[UILabel alloc] init];
    jifenLab.text = @"20";
    [jifenLab sizeToFit];
    jifenLab.font = [UIFont systemFontOfSize:45];
    jifenLab.textColor = [UIColor whiteColor];
    jifenLab.textAlignment = NSTextAlignmentCenter;
    [greenView addSubview:jifenLab];
    
    //积分des按钮
    jifenBtnLab = [UIButton buttonWithType:UIButtonTypeCustom];
    jifenBtnLab.frame = CGRectZero;
    [jifenBtnLab setTitle:@"积分总额" forState:UIControlStateNormal];
    [jifenBtnLab setImageEdgeInsets:UIEdgeInsetsMake(0.0, -9, 0.0, 0.0)];
    [jifenBtnLab setImage:[UIImage imageNamed:@"jifen.png"] forState:UIControlStateNormal];
    [jifenBtnLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jifenBtnLab.titleLabel.font = [UIFont systemFontOfSize:14];
    [greenView addSubview:jifenBtnLab];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(nav.mas_bottom);
        make.height.mas_equalTo(160);
    }];
    
    [jifenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(greenView.mas_top).offset(52);
        make.centerX.equalTo(greenView);
    }];
    
    [jifenBtnLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jifenLab.mas_bottom);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(102,24));
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(greenView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView代理方法


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return arrayTitle.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdetifier = @"scroeCell";
    
    JiFenTableViewCell * jifenCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (jifenCell == nil) {
        jifenCell = [[[NSBundle mainBundle]loadNibNamed:@"JiFenTableViewCell" owner:nil options:nil]lastObject];
    }
 
    jifenCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return jifenCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.010;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.0;
}
@end
