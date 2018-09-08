//
//  PositionCityViewController.m
//  Charge
//
//  Created by olive on 16/7/13.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "PositionCityViewController.h"
#import "MJExtension.h"
#import "CityModel.h"
#import "XFunction.h"
#import "Masonry.h"

@interface PositionCityViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
   NSMutableArray *toBeReturned;
   NSMutableArray *suoYinArray;
}
@property (strong, nonatomic) IBOutlet UITextField *cityChooseTextField;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong, nonatomic) NSMutableArray *allData;
@property (strong, nonatomic) NSMutableArray *tempArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITableView *tableview1;
@property (assign, nonatomic) BOOL isSearch;

@property (strong, nonatomic) IBOutlet UILabel *locationCity;

@property (strong, nonatomic) IBOutlet UILabel *locationCityLab;//当前定位地址


- (IBAction)cancelAction:(id)sender;

@end

@implementation PositionCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setting];
//    toBeReturned = [[NSMutableArray alloc]init];
//    for(char c = 'A';c<='Z';c++)
//        [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
//    MYLog(@"toBeReturned = %@",toBeReturned);
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CityList.plist" ofType:nil];
    _dataArray  = [NSArray arrayWithContentsOfFile:plistPath];
    _cityArray = [NSMutableArray array];
    suoYinArray = [NSMutableArray array];
    _tempArray = [NSMutableArray array];
    
    for (int i = 0; i <self.dataArray.count; i++) {
        [suoYinArray addObject:self.dataArray[i][@"state"]];
    }
    for (int i = 0; i< self.dataArray.count; i++) {
        [_cityArray addObject:self.dataArray[i][@"city"]];
    }
    self.allData = [NSMutableArray array];
    //所有城市数据
    for (int i = 0; i < _cityArray.count; i++) {
        NSMutableArray *tempArray = [NSMutableArray array];
        tempArray = _cityArray[i];
        for (int p = 0;p < tempArray.count ; p++) {
            [_allData addObject:tempArray[p]];
        }
    }
    
    //初始化数据
    self.locationCityLab.text = self.locationCitys;
    self.locationCityLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityClick)];
    [self.locationCityLab addGestureRecognizer:tap];
    
}

#pragma mark - 设置

-(void)cityClick
{
    MYLog(@"dfsdfa");
    
    self.ChooseCityBlack(self.locationCitys);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)setting
{
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor grayColor]];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去除多余空白行
    
    [self creatTempTableView];
}

-(void)creatTempTableView
{
    self.tableview1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    self.tableview1.tag = 1;
    self.tableview1.alpha = 0;
    self.tableview1.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableview1];
    
    [self.tableview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationCity.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return self.tempArray.count;
    }else
    {
    NSArray *cityArray = self.dataArray[section][@"city"];
    return cityArray.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 1) {
        return 1;
    }else
    {
        return self.dataArray.count;
    }
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        static NSString *cellIdetifier = @"SearchCells";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
        }
        cell.textLabel.text = self.tempArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = RGBA(77, 78, 79, 1);
        return cell;
    }else
    {
        static NSString *cellIdetifier = @"SearchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
        }
        NSArray *cityArray = self.dataArray[indexPath.section][@"city"];
        cell.textLabel.text = cityArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = RGBA(77, 78, 79, 1);
        return cell;
    }
}
//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return nil;
    }
//  return toBeReturned;
    return suoYinArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    if (tableView.tag == 1) {
        return 0;
    }
    
    NSInteger count = 0;
    for(NSString *character in suoYinArray)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
//设置_tableView的章、节
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
//  return toBeReturned[section];
    
    if (tableView.tag == 1) {
        return nil;
    }
    return suoYinArray[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        [self.cityChooseTextField resignFirstResponder];
        self.ChooseCityBlack(self.tempArray[indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
         [self.cityChooseTextField resignFirstResponder];
        NSArray *cityArray = self.dataArray[indexPath.section][@"city"];
        self.ChooseCityBlack(cityArray[indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - action

- (IBAction)cancelAction:(id)sender {
    
    [self.cityChooseTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - uitextfield 代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.cityChooseTextField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 15){
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            [self.tempArray removeAllObjects];
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            for (int i = 0; i < self.allData.count; i++) {
                NSRange chinese = [self.allData[i] rangeOfString:text options:NSCaseInsensitiveSearch];
                if (chinese.location != NSNotFound) {
                    [self.tempArray addObject:self.allData[i]];
                }
            }
            self.tableView.alpha = 0;
            self.tableview1.alpha = 1;
            [self.tableview1 reloadData];
            
        }else{
            
            [self.tempArray removeAllObjects];
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            for (int i = 0; i < self.allData.count; i++) {
                NSRange chinese = [self.allData[i] rangeOfString:text options:NSCaseInsensitiveSearch];
                if (chinese.location != NSNotFound) {
                    [self.tempArray addObject:self.allData[i]];
                }
            }
            self.tableView.alpha = 0;
            self.tableview1.alpha = 1;
            [self.tableview1 reloadData];
      
        }
    if (strLength == 0) {
        self.tableView.alpha = 1;
        self.tableview1.alpha = 0;
        [self.tableView reloadData];
    }
    
     return YES;
}

@end
