//
//  SlideView.m
//  MakerMap
//
//  Created by kevin on 16/4/13.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "PersonSlideView.h"
#import "UIView+Ext.h"
#import "Masonry.h"
#import "XFunction.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "Config.h"
#import "WMNetWork.h"
#import "PersonMessage.h"
#import "MJExtension.h"
#import "UIImage-Extensions.h"
#import "PersonMesCaches.h"
#import "API.h"

@interface PersonSlideView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *superView;
@property (strong, nonatomic) NSArray *arrayPicture;
@property (strong, nonatomic) NSArray *arrayTitle;
@property (strong, nonatomic)  UIImageView *headerBtn;


@end
@implementation PersonSlideView
{
    UIView *viewBack;
    UIPanGestureRecognizer *viewPan;
    BOOL canShowLeft;
    BOOL canHideLeft;
    CGFloat panOriginX;
    UILabel *nameLab;
    UIView *lineView;
    NSString *ImageUrl;//头像
    
    UIImageView *bgImageView;//磨砂背景图片
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    if (self = [super initWithFrame:frame]) {
        
        _superView = superView;
        self.backgroundColor = [UIColor whiteColor];
        
        self.arrayPicture = @[@"yuyue",@"qianbao",@"jifencaidan",@"shouchang", @"setting"];
        self.arrayTitle = @[@"预约", @"钱包", @"积分", @"收藏", @"设置"];
       //备用
       // self.arrayPicture = @[@"qianbao",@"kefu",@"shouchang", @"setting"];
       //self.arrayTitle = @[@"钱包", @"客服",@"收藏",@"设置"];
        
        [self createUI];
        [self superHandle];
        //初始头像和名字
        [self initData];
        
        //监听通知事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeName:) name:ChangeNewName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeAvatar:) name:ChangeNewAvatar object:nil];
    }
    
    return self;
}

-(void)initData
{
    //获取文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    MYLog(@"docPath  = %@",docPath);
    NSString *targetPath = [docPath stringByAppendingPathComponent:@"mes.plist"];
    MYLog(@"targetPath = %@",targetPath);
    
    PersonMesCaches *per = [NSKeyedUnarchiver unarchiveObjectWithFile:targetPath];
    
    NSString *thirdDocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *thirdTargetPath = [thirdDocPath stringByAppendingPathComponent:@"ThirdMes.plist"];
    
    PersonMesCaches *thirdPer = [NSKeyedUnarchiver unarchiveObjectWithFile:thirdTargetPath];
    
    //如果有第三方登陆标记就赋值第三方标记，如果没有赋值其他
    NSString *thirdType = [NSString stringWithFormat:@"%@",[Config getThirdLoginType]];
    NSLog(@"thirdPer = %@",thirdType);
    // 登录平台，0：账号密码登录，1：微信登录，2：qq登录
    if ([thirdType isEqualToString:@"1"]) {
        
        nameLab.text = thirdPer.nick;
        //图片url路径
        ImageUrl = thirdPer.avatar;
        NSLog(@"avatar = %@",thirdPer.avatar);
        
        if (ImageUrl) {
            [_headerBtn sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"grayIcon"] options:SDWebImageRefreshCached];
            [bgImageView sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"bgImages"] options:SDWebImageRefreshCached];
        }else
        {
            _headerBtn.image = [UIImage imageNamed:@"grayIcon"];
          
        }
    }else if ([thirdType isEqualToString:@"2"])
    {
        nameLab.text = thirdPer.nick;
        //图片url路径
        ImageUrl = thirdPer.avatar;
        NSLog(@"avatar = %@",thirdPer.avatar);
        
        if (ImageUrl) {
            [_headerBtn sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"grayIcon"] options:SDWebImageRefreshCached];
            [bgImageView sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"bgImages"] options:SDWebImageRefreshCached];
        }else
        {
            _headerBtn.image = [UIImage imageNamed:@"grayIcon"];
        }
    
    }else{
        
        //初始化名字
        NSString *tempUseName = [Config getUseName];
        
        if ([tempUseName isEqualToString:[Config getOwnAccount]]) {
            NSString *newUserName = [tempUseName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            nameLab.text = newUserName;
            MYLog(@"newUserName = %@",newUserName);
        }else
        {
            nameLab.text = tempUseName;
            MYLog(@"tempUseName = %@",tempUseName);
        }
        
        //图片url路径
        ImageUrl = per.avatar;
        
        if (ImageUrl) {
            [_headerBtn sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"grayIcon"] options:SDWebImageRefreshCached];
            [bgImageView sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"bgImages"] options:SDWebImageRefreshCached];
        }else
        {
            _headerBtn.image = [UIImage imageNamed:@"grayIcon"];
        }
    }
}

- (void)superHandle
{
    viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XYScreenWidth, XYScreenHeight)];
    viewBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [viewBack addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
    
    viewPan = [[UIPanGestureRecognizer alloc]init];
    viewPan.delegate = self;
    [viewPan addTarget:self action:@selector(viewPan:)];
    [self addGestureRecognizer:viewPan];
}

-(void)tap
{
    [self leftViewShow:NO];
}

- (void)createUI
{
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(163);
    }];
    
    bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"grayIcon"];
    [bgView addSubview:bgImageView];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(163);
       // make.height.equalTo(self);
    }];
    
    UIView *effectView;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 磨砂视图
    effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    [bgImageView addSubview:effectView];
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(164);
    //    make.height.equalTo(self);
    }];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick:)];
    _headerBtn = [[UIImageView  alloc] init];
    _headerBtn.layer.masksToBounds = YES;
    _headerBtn.layer.cornerRadius = 68*0.5;
    _headerBtn.layer.borderWidth = 1.8;
  //  _headerBtn.layer.borderColor = RGBA(29, 167, 146, 1).CGColor;
    _headerBtn.layer.borderColor = RGBA(255, 255, 255, 1).CGColor;
    _headerBtn.userInteractionEnabled = YES;
    _headerBtn.image = [UIImage imageNamed:@"grayIcon"];
    [_headerBtn addGestureRecognizer:tap];
    [self addSubview:_headerBtn];
    
    [_headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(68, 68));
    }];
    
    nameLab = [[UILabel alloc] init];
    nameLab.textColor = [UIColor blackColor];
    nameLab.font = [UIFont systemFontOfSize:14];
    nameLab.text = @"FBI 帅哥";
    nameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLab];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerBtn.mas_bottom).offset(8);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(34);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor clearColor];
    lineView.alpha = 0.1;
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLab.mas_bottom).offset(23);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(1);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.5;
    //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.layer.shadowOffset = CGSizeMake(1, 0);
    self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = YES; //设置tableview 不能滚动
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)viewPan:(UIPanGestureRecognizer *)pan
{
    CGPoint locate = [pan locationInView:_superView];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        //        MYLog(@"Began%f",locate.x);
        BOOL isLeftShow = self.originX != -self.sizeWidth-5;
        
        panOriginX = locate.x;
        if (!isLeftShow) {
            if (panOriginX<50) {
                
                [self.superview addSubview:viewBack];
                [self.superview addSubview:self];
                canShowLeft = YES;
            }
            else
            {
                canShowLeft = NO;
            }
            canHideLeft = NO;
        }
        else
        {
            canHideLeft = YES;
            canShowLeft = NO;
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        //        MYLog(@"Ended%f",locate.x);
        if (canShowLeft) {
            [self handleShowPoint:locate.x target:120];
        }
        else if (canHideLeft) {
            [self handleShowPoint:locate.x target:250];
        }
    }
    
    if ((canShowLeft)&&pan.state != UIGestureRecognizerStateEnded&&pan.state != UIGestureRecognizerStateBegan) {
        CGFloat offsetX = (locate.x - panOriginX)-self.sizeWidth;
        
        if (offsetX<0) {
            CGFloat scale = (self.originX + self.sizeWidth)/self.sizeWidth;
            viewBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4*scale];
            self. originX = offsetX;
        }
        
    }
    else if (canHideLeft&&pan.state != UIGestureRecognizerStateEnded&&pan.state != UIGestureRecognizerStateBegan) {
        CGFloat offsetX = -(panOriginX -locate.x);
        
        if (offsetX<0) {
            self. originX = offsetX;
           
            CGFloat scale = (self.originX + self.sizeWidth)/self.sizeWidth;
            viewBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4*scale];
        }
        else
        {
            canHideLeft = NO;
        }
    }
}
- (void)handleShowPoint:(CGFloat)pointX target:(CGFloat)targetX
{
    if (pointX>targetX) {
        [self leftViewShow:YES];
        canShowLeft = NO;
        canHideLeft = YES;
    }
    else
    {
        [self leftViewShow:NO];
        canHideLeft = NO;
    }
}

- (void)leftViewShow:(BOOL)show
{
    if (show) {
        
        if (viewBack.superview == nil) {
            [self.superview addSubview:viewBack];
            [self.superview addSubview:self];
        }
        [UIView animateWithDuration:0.35 delay:0.f usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            viewBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            self.originX = 0;
        }completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.35 delay:0.f usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.originX = -self.sizeWidth-5;
            viewBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        }completion:^(BOOL finished) {
            [viewBack removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}
- (void)handle:(LeftViewBlock)block
{
    if (block) {
        _leftBlock = block;
    }
}
#pragma mark - UITableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTitle.count;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        MYLog(@"预约");
        if ([self.delegate respondsToSelector:@selector(yuYueClick)]) {
            [self.delegate yuYueClick];
        }
     }else if (indexPath.section == 0 && indexPath.row == 1)
     {
        MYLog(@"钱包");
        if ([self.delegate respondsToSelector:@selector(qianBaoClick)]) {
            [self.delegate qianBaoClick];
         }
     }else if (indexPath.section == 0 && indexPath.row == 2)
    {
        MYLog(@"客服");
        //客服点击了
        if ([self.delegate respondsToSelector:@selector(keFuClick)]) {
            [self.delegate keFuClick];
        }
  
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        MYLog(@"收藏");
        if ([self.delegate respondsToSelector:@selector(shouChangClick)]) {
            [self.delegate shouChangClick];
        }
    }else if (indexPath.section == 0 && indexPath.row == 4)
    {
        MYLog(@"设置");
        if ([self.delegate respondsToSelector:@selector(settingClick)]) {
            [self.delegate settingClick];
      }
    }
}

//设置滑动，
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ruturn NO不实现滑动
    return NO;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    return view;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdetifier = @"myCells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
    }
    
    [cell.textLabel setText:_arrayTitle[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    [cell.imageView setImage:[UIImage imageNamed:_arrayPicture[indexPath.row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (IBAction)headerClick:(id)sender {
    MYLog(@"点击头像");
    if ([self.delegate respondsToSelector:@selector(headerClick)]) {
        [self.delegate headerClick];
    }
}

-(void)ChangeName:(NSNotification *)noti
{

   NSString *thirdType = [NSString stringWithFormat:@"%@",[Config getThirdLoginType]];
    if ([thirdType isEqualToString:@"1"]) {
    }else
    {
     nameLab.text = noti.userInfo[@"text"];
    }
}

-(void)ChangeAvatar:(NSNotification *)noti
{
    NSString *thirdType = [NSString stringWithFormat:@"%@",[Config getThirdLoginType]];
    if ([thirdType isEqualToString:@"1"]) {

    }else
    {
        [_headerBtn sd_setImageWithURL:[NSURL URLWithString:[Config getPortrait]] placeholderImage:[UIImage imageNamed:@"grayIcon"] options:SDWebImageRefreshCached];
        [bgImageView sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"bgImages"] options:SDWebImageRefreshCached];
    }
}

//第三方资料存储
-(void)saveThirdMesWithNick:(NSString *)Nick andAvatar:(NSString *)Avatar
{
    PersonMesCaches *perCaches = [[PersonMesCaches alloc]init];
    perCaches.nick = Nick;
    perCaches.avatar = Avatar;
    //获取文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //文件类型可以随便取，不一定要正确的格式
    NSString *targetPath = [docPath stringByAppendingPathComponent:@"ThirdMes.plist"];
    //将自定义对象保存在指定路径下
    [NSKeyedArchiver archiveRootObject:perCaches toFile:targetPath];
    
}

@end
