//
//  StartSearchViewController.m
//  Charge
//
//  Created by olive on 16/7/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "StartSearchViewController.h"
#import "SearchMessageTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"
#import "XFunction.h"

@interface StartSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BMKPoiSearch* _poisearch;
    BMKMapView* _mapView;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *qiDianTextField;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)backAction:(id)sender;

@end

@implementation StartSearchViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_qiDianTextField becomeFirstResponder];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.dataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, XYScreenWidth, XYScreenHeight-66) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha = 1;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
    _qiDianTextField.returnKeyType = UIReturnKeySearch;
    
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        MYLog(@"poiInfoList = %@",poiResultList.poiInfoList);

        if (poiResultList.poiInfoList == nil) {
            [MBProgressHUD hideHUD];
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"抱歉，未找到结果!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            
            [alertVc addAction:sureAction];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
        
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        
        for (int i = 0; i < poiResultList.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [poiResultList.poiInfoList objectAtIndex:i];
            [self.dataArray addObject:poi];
        }
        
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        MYLog(@"起始点有歧义!");
        [MBProgressHUD hideHUD];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"起始点有歧义!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    } else {
        MYLog(@"抱歉，未找到结果!");
        [MBProgressHUD hideHUD];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"抱歉，未找到结果!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    _poisearch.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo* poi = self.dataArray[indexPath.row];
    self.qiDianBlock(poi.name);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdetifier = @"SearchMessageTableViewCell";
//    SearchMessageTableViewCell * MySearchMesCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
//    if (MySearchMesCell == nil) {
//        MySearchMesCell = [[[NSBundle mainBundle]loadNibNamed:@"MyCollectTableViewCell" owner:nil options:nil]lastObject];
//    }
//    [MySearchMesCell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    BMKPoiInfo* poi = self.dataArray[indexPath.row];
//    MySearchMesCell.title = poi.name;
//    MySearchMesCell.address = poi.city;
//    
//    return MySearchMesCell;
    
    static NSString *cellIdetifier = @"myCellss";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdetifier];
    }
    BMKPoiInfo* poi = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",poi.name];
    cell.detailTextLabel.text = poi.address;
    cell.imageView.image = [UIImage imageNamed:@"shouchang"];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - action

- (IBAction)backAction:(id)sender {
    [_qiDianTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_qiDianTextField resignFirstResponder];
    
    [MBProgressHUD showMessage:@""];
    
    //初始化检索对象
    _poisearch =[[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    //发起检索
    BMKPOICitySearchOption *option = [[BMKPOICitySearchOption alloc] init];
    option.pageSize = 12; //pageCapacity
    option.city = @"广州";
    option.keyword = _qiDianTextField.text;
    BOOL flag = [_poisearch poiSearchInCity:option];
    if(flag)
    {
        MYLog(@"周边检索发送成功");
    }
    else
    {
        MYLog(@"周边检索发送失败");
        [MBProgressHUD hideHUD];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"周边检索发送失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    
    return YES;
}

@end
