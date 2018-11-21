//
//  PersonMessageViewController.m
//  Charge
//
//  Created by olive on 16/6/28.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "PersonMessageViewController.h"
#import "HeaderImageTableViewCell.h"
#import "QianMingViewController.h"
#import "ChangeNewNameViewController.h"
#import "PhoneNumViewController.h"
#import "QianMingTableViewCell.h"
#import "CarAuthenticateViewController.h"
#import "XFunction.h"
#import "UIImage-Extensions.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "PersonMesCaches.h"
#import "WMNetWork.h"
#import "PersonMessage.h"
#import "Config.h"
#import "NavView.h"
#import "API.h"

@interface PersonMessageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    UIButton *bgBtn;
    UIView *BgView;
    NSString *filePath;//文件路径
    NSString *name;//昵称
    NSString *age;//年龄
    NSString *newage;//年龄
    NSString *sex;//性别
    NSString *qianMing;//签名
    NSString *phone;//手机号
    NSString *ImageUrl;//头像
    UIPickerView *pickerViews;//年龄选择器
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayFuTitle;
@property (strong, nonatomic) NSArray *arrayTitle;
@property (strong, nonatomic) NSMutableArray *ageArray;

@end

@implementation PersonMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   // Do any additional setup after loading the view from its nib.
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"个人信息"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(StatusBarH +44);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarH +44, XYScreenWidth, XYScreenHeight - StatusBarH - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = RGBA(235, 236, 237, 1);
    self.arrayTitle = @[@[@"头像",@"昵称",@"性别",@"年龄",@"手机号",@"我的签名"]];
    
    [self initData];//初始化数据
}

-(void)initData
{
        //获取文件路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        MYLog(@"docPath  = %@",docPath);
        NSString *targetPath = [docPath stringByAppendingPathComponent:@"mes.plist"];
        MYLog(@"targetPath = %@",targetPath);
        PersonMesCaches *per = [NSKeyedUnarchiver unarchiveObjectWithFile:targetPath];
    
        //图片url路径
        ImageUrl = per.avatar;
        NSString *tempPhone = per.mobile;
        NSString *newPhone = [tempPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        phone = newPhone;
        
        if ([per.sex isEqualToString:@""]) {
            sex = @"请填写";
        }else
        {
            NSString *tempSex = per.sex;
            if ([tempSex intValue] == 0) {
                sex = @"男";
            }else if ([tempSex intValue] == 1)
            {
                sex = @"女";
            }else
            {
                sex = @"保密";
            }
        }
        
        if ([per.age isEqualToString:@""]) {
            newage = @"请填写";
        }else
        {
            newage = per.age;
        }
        
        NSString *tempnick = per.nick;
        
        if ([tempnick isEqualToString:[Config getOwnAccount]]) {
            NSString *newnick = [tempnick stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            name = newnick;
        }else
        {
            name = tempnick;
        }
        
        if ([per.signature isEqualToString:@""]) {
            qianMing = @"请填写";
        }else
        {
            qianMing = per.signature;
        }

    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"userId"] =[Config getOwnID];
    paramers[@"token"] =[Config getToken];
    
    MYLog(@"pessonMes token = %@",[Config getToken]);
    
    [WMNetWork get:GetPerMes parameters:paramers success:^(id responseObj) {
        
        MYLog(@"PerMesresponseObj = %@",responseObj);
        if ([responseObj[@"status"] intValue] == 401) {
           
            [Config removeOwnID];//移除ID
            [Config removeUseName];//移除用户名字
            //退出登陆时通知主控制器收起左滑界面
            [[NSNotificationCenter defaultCenter] postNotificationName:LeaveOutNoti object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
            [MBProgressHUD showError:@"账号异常登录"];
            return ;
        }

        if ([responseObj[@"status"] intValue] == 0) {
            
            PersonMessage  *per = [PersonMessage objectWithKeyValues:responseObj[@"result"]];
            [self saveDataWithSex:per.sex andAge:per.age andNick:per.nick andMobile:per.mobile andAvatar:per.avatar andSignature:per.signature];
            //图片路径赋值
            ImageUrl = per.avatar;
            
            NSString *tempPhone = per.mobile;
            NSString *newPhone = [tempPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            phone = newPhone;
            
            if ([per.sex isEqualToString:@""]) {
                sex = @"请填写";
            }else
            {
                NSString *tempSex = per.sex;
                if ([tempSex intValue] == 0) {
                    sex = @"男";
                }else if ([tempSex intValue] == 1)
                {
                    sex = @"女";
                }else
                {
                    sex = @"保密";
                }
            }
            
            if ([per.age isEqualToString:@""]) {
                newage = @"请填写";
            }else
            {
                newage = per.age;
            }
            
            NSString *tempnick = per.nick;
            
            if ([tempnick isEqualToString:[Config getOwnAccount]]) {
                NSString *newnick = [tempnick stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                name = newnick;
            }else
            {
                name = tempnick;
            }
            
            if ([per.signature isEqualToString:@""]) {
                qianMing = @"请填写";
            }else
            {
                qianMing = per.signature;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        MYLog(@"error = %@",error);
        [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
    }];
}


-(void)creatSelecter
{
    bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    bgBtn.backgroundColor = [UIColor blackColor];
    bgBtn.alpha = 0;
    [self.view addSubview:bgBtn];
    
    BgView = [[UIView alloc] initWithFrame:CGRectMake(0,XYScreenHeight+180, XYScreenWidth, 180)];
    BgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:BgView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBA(169, 169, 169, 1) forState:UIControlStateNormal];
    [cancelBtn addTarget: self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [BgView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, 0, 60, 40);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:RGBA(29, 167, 146, 1) forState:UIControlStateNormal];
    [sureBtn addTarget: self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [BgView addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(BgView);
        make.top.equalTo(BgView);
        make.size.mas_equalTo(CGSizeMake(60,40));
    }];
    
    pickerViews = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, XYScreenWidth, 180-40)];
    pickerViews.delegate = self;
    pickerViews.dataSource = self;
    [pickerViews selectRow:2 inComponent:0 animated:NO];
    [BgView addSubview:pickerViews];
    
     age = [NSString stringWithFormat:@"%@",[self.ageArray objectAtIndex:2]];
}

#pragma mark - UITableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 84;
    }
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.arrayTitle.count;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayTitle[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        UIAlertAction *paiZhaoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.delegate = self;
//            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//            picker.allowsEditing = YES;
//            
//            
//            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
//                
//                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                    picker.showsCameraControls = YES;
//                    
//                }else{
//                    MYLog(@"模拟器无法打开相机");
//                }
//                [self presentViewController:picker animated:YES completion:nil];
//            }
//        }];
//        
//        UIAlertAction *xiangCeAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.delegate = self;
//            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//            picker.allowsEditing = YES;
//            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            
//            [self presentViewController:picker animated:YES completion:nil];
//            
//        }];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        
//        [alertVC addAction:paiZhaoAction];
//        [alertVC addAction:xiangCeAction];
//        [alertVC addAction:cancelAction];
//        
//        [self presentViewController:alertVC animated:YES completion:nil];
    }else if (indexPath.section == 0 && indexPath.row == 5)
    {
        QianMingViewController *qianMingVC = [[QianMingViewController alloc] init];
        qianMingVC.qianMing = qianMing;
        qianMingVC.QianMingBlock = ^(NSString *qianMings){
            qianMing = qianMings;
           [self.tableView reloadData];
        };
        [self.navigationController pushViewController:qianMingVC animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        ChangeNewNameViewController *changeNameVC = [[ChangeNewNameViewController alloc] init];
        changeNameVC.name = name;
        changeNameVC.ReturnTextBlock = ^(NSString *nameText){
            name = nameText;
            MYLog(@"name = %@",name);
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:changeNameVC animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 2)
    {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *NanAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSMutableDictionary *parms = [NSMutableDictionary dictionary];
            parms[@"userId"] = [Config getOwnID];//用户ID
            parms[@"infoVal"] = @"0";//要修改的参数值
            parms[@"field"] = @"SEX";
            [MBProgressHUD showMessage:@""];
            [WMNetWork post:UpdateBase parameters:parms success:^(id responseObj) {
                MYLog(@"responseObj = %@",responseObj);
                [MBProgressHUD hideHUD];
                if ([responseObj[@"status"] intValue] == 0) {
                   NSString *tempSex = responseObj[@"result"][@"sex"];
                    if ([tempSex isEqualToString:@"0"]) {
                        sex = @"男";
                    }
                    [self.tableView reloadData];
                }
                
            } failure:^(NSError *error) {
                MYLog(@"error = %@",error);
                [MBProgressHUD hideHUD];
                [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
            }];
        }];
        
        UIAlertAction *NvAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSMutableDictionary *parms = [NSMutableDictionary dictionary];
            parms[@"userId"] = [Config getOwnID];//用户ID
            parms[@"infoVal"] = @"1";//要修改的参数值
            parms[@"field"] = @"SEX";
            [MBProgressHUD showMessage:@""];
            [WMNetWork post:UpdateBase parameters:parms success:^(id responseObj) {
                MYLog(@"responseObj = %@",responseObj);
                [MBProgressHUD hideHUD];
                if ([responseObj[@"status"] intValue] == 0) {
                  NSString  *tempSex = responseObj[@"result"][@"sex"];
                    if ([tempSex isEqualToString:@"1"]) {
                        sex = @"女";
                    }
                    [self.tableView reloadData];
                }
              
            } failure:^(NSError *error) {
                MYLog(@"error = %@",error);
                [MBProgressHUD hideHUD];
               [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
            }];
        }];
        
        [alertVc addAction:NanAction];
        [alertVc addAction:NvAction];
        //  调用self的方法展现控制器
        [self presentViewController:alertVc animated:YES completion:nil];
        
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        
        [self.ageArray removeAllObjects];
        self.ageArray = [NSMutableArray arrayWithObjects:@"50后",@"60后",@"70后",@"80后",@"90后",@"00后", nil];
        [self creatSelecter];
        
        [UIView animateWithDuration:0.3 animations:^{
            bgBtn.alpha = 0.3;
            BgView.frame = CGRectMake(0,XYScreenHeight-180, XYScreenWidth, 180);
        }];
    }else if (indexPath.section == 0 && indexPath.row == 4)
    {
        //手机号
        PhoneNumViewController *phoneVC = [[PhoneNumViewController alloc] init];
        [self.navigationController pushViewController:phoneVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        //车主认证
        CarAuthenticateViewController *carVC = [[CarAuthenticateViewController alloc] init];
        [self.navigationController pushViewController:carVC animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *cellIdetifier = @"imageCell";
        HeaderImageTableViewCell * HeaderImageCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
        if (HeaderImageCell == nil) {
            HeaderImageCell = [[[NSBundle mainBundle]loadNibNamed:@"HeaderImageTableViewCell" owner:nil options:nil]lastObject];
        }
        HeaderImageCell.NewImageUrl = ImageUrl;
        HeaderImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return HeaderImageCell;
    
    }else if (indexPath.section == 0 && indexPath.row == 5)
    {
        static NSString *cellIdetifier = @"qianMingCell";
        QianMingTableViewCell * qianMingCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
        if (qianMingCell == nil) {
            qianMingCell = [[[NSBundle mainBundle]loadNibNamed:@"QianMingTableViewCell" owner:nil options:nil]lastObject];
        }
        qianMingCell.qianMing = qianMing;
        qianMingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return qianMingCell;
    }else
    {
        static NSString *cellIdetifier = @"SttingCell";
        UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
        if (Cell == nil) {
            Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
        }
        NSString *content = self.arrayTitle[indexPath.section][indexPath.row];
        Cell.textLabel.text = [NSString stringWithFormat:@"%@",content];
        Cell.textLabel.font = [UIFont systemFontOfSize:14];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        if(indexPath.section == 0 && indexPath.row == 1)
        {
            Cell.detailTextLabel.text = name;
        }else if(indexPath.section == 0 && indexPath.row == 2)
        {
            Cell.detailTextLabel.text = sex;
        }else if(indexPath.section == 0 && indexPath.row == 3)
        {
            Cell.detailTextLabel.text = newage;
        }else if(indexPath.section == 0 && indexPath.row == 4)
        {
            Cell.detailTextLabel.text = phone;
        }else if(indexPath.section == 0 && indexPath.row == 5)
        {
            Cell.detailTextLabel.text = @"请选择";
        }
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return Cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pickerView代理方法


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;  // 返回1表明该控件只包含1列
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    
    return self.ageArray.count;
}

// UIPickerViewDelegate中定义的方法,返回当前行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.ageArray objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    age = [NSString stringWithFormat:@"%@",[self.ageArray objectAtIndex:row]];
}

#pragma mark - action
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelAction
{
    [UIView animateWithDuration:0.3 animations:^{
        bgBtn.alpha = 0;
        BgView.frame = CGRectMake(0,XYScreenHeight+180, XYScreenWidth, 180);
        [BgView removeFromSuperview];
    }];
}
//年龄选择确定按钮
-(void)sureBtnAction
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms[@"userId"] = [Config getOwnID];//用户ID
    parms[@"infoVal"] = age;//要修改的参数值
    parms[@"field"] = @"AGE";
    [MBProgressHUD showMessage:@""];
    [WMNetWork post:UpdateBase parameters:parms success:^(id responseObj) {
        MYLog(@"responseObj = %@",responseObj);
        [MBProgressHUD hideHUD];
        if ([responseObj[@"status"] intValue] == 0) {
            newage = responseObj[@"result"][@"age"];
            [self.tableView reloadData];
        }
        if ([responseObj[@"status"] intValue] == -1) {
            [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
        }
        
    } failure:^(NSError *error) {
        MYLog(@"error = %@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
    }];

    [self cancelAction];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
//  [MBProgressHUD showMessage:@"头像正在上传..."];
    NSData *mydata=UIImageJPEGRepresentation(image , 0.5);

    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    NSString *pictureDataString=[mydata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"id"] = [Config getOwnID];
    parmas[@"file"] = pictureDataString;
    
    [WMNetWork post:UpdateAvatars parameters:parmas success:^(id responseObj) {
        MYLog(@"responseObj = %@",responseObj);
    [MBProgressHUD hideHUD];
    [MBProgressHUD show:@"上传成功" icon:nil view:nil];
    ImageUrl = responseObj[@"imgUrl"];
    //刷新tableview
    [self.tableView reloadData];
    //更新存储头像
    [Config savePortrait:responseObj[@"imgUrl"]];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:responseObj[@"imgUrl"],@"imgUrl" ,nil];
                             
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeNewAvatar object:dict];
        
    } failure:^(NSError *error) {
        MYLog(@"error = %@",error);
    [MBProgressHUD hideHUD];
    [MBProgressHUD show:@"网络故障" icon:nil view:nil];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 保存个人信息缓存

- (void)saveDataWithSex:(NSString *)Sex andAge:(NSString *)Age andNick:(NSString *)Nick andMobile:(NSString *)Mobile andAvatar:(NSString *)Avatar andSignature:(NSString *)Signature
{
    PersonMesCaches *perCaches = [[PersonMesCaches alloc]init];
    perCaches.sex = Sex;
    perCaches.age = Age;
    perCaches.nick = Nick;
    perCaches.mobile = Mobile;
    perCaches.avatar = Avatar;
    perCaches.signature = Signature;
    
    //获取文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //文件类型可以随便取，不一定要正确的格式
    NSString *targetPath = [docPath stringByAppendingPathComponent:@"mes.plist"];
    
    //将自定义对象保存在指定路径下
    [NSKeyedArchiver archiveRootObject:perCaches toFile:targetPath];
    MYLog(@"文件已储存");
}

#pragma mark -- 获取个人信息缓存

//-(void)getData
//{
//    //获取文件路径
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *targetPath = [docPath stringByAppendingPathComponent:@"mes.plist"];
//    
//    PersonMesCaches *perCaches = [NSKeyedUnarchiver unarchiveObjectWithFile:targetPath];
//    MYLog(@"sex = %@ , age =%@ , nick = %@ , mobile = %@,avatar = %@,signature = %@",perCaches.sex,perCaches.age,perCaches.nick,perCaches.mobile,perCaches.avatar,perCaches.signature);
//    MYLog(@"文件已提取");
//}

//#pragma mark -保存图片到本地
//- (void)saveImgToLocal:(NSData *)data
//{
//    UIImage *img = [UIImage imageWithData:data];
//    CGSize imgSize = img.size;
//    CGFloat ratio = imgSize.height/imgSize.width;
//    UIImage *thumbimg=[img imageByScalingProportionallyToSize:CGSizeMake(120,120 * ratio)];
//    
//    //路径不存在则新建
//    if (![[NSFileManager alloc] fileExistsAtPath:filePath]){
//        NSString *newfilename = @"image.png";
//        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *_documentDirectory = [[NSString alloc] initWithString:[_paths objectAtIndex:0]];
//        filePath = [_documentDirectory stringByAppendingPathComponent:newfilename];
//        
//    }
//    
//    [UIImageJPEGRepresentation(thumbimg,1)writeToFile:filePath atomically:YES];
//    
//}


@end
