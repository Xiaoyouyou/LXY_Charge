//
//  DetailZhuangWeiHeaderView.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "DetailZhuangWeiHeaderView.h"
#import "Masonry.h"
#import "XFunction.h"

#define scrollW (XYScreenWidth - 10)

@interface DetailZhuangWeiHeaderView ()<UIScrollViewDelegate>
@property (nonatomic ,strong) UIView *backView;
@property (nonatomic ,strong) UIScrollView *scroll;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,strong) NSTimer *timer;
@end

@implementation DetailZhuangWeiHeaderView


-(void)setPicArray:(NSArray *)picArray{
    _picArray = picArray;
    [self addScrollViewWithArray:picArray];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
 
    self.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    }
    return self;
}


//销毁定时器
-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}


//添加UI
-(void)creatUI
{
    //添加轮播图
    _backView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, scrollW, 200)];
    [self addSubview:_backView];
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollW, 200)];
   
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    [self.backView addSubview:_scroll];
    
    
    //创建 初始化
    _pageControl = [[UIPageControl alloc]init];
    //设置指示器默认显示的颜色
    _pageControl.pageIndicatorTintColor = [UIColor redColor];
    //设置当前选中的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    //设置当前默认显示位置
    _pageControl.currentPage = 0;
    //将pageControl添加到视图中
    [self.backView addSubview:_pageControl];
    //设置frame
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).mas_offset((self.backView.bounds.size.width - 150) / 2);
        make.bottom.mas_equalTo(self.backView.mas_bottom).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.right.mas_equalTo(self.backView).mas_offset(-(self.backView.bounds.size.width - 150) / 2);
    }];
    
    
    //
    _pictImageView = [[UIImageView alloc] init];
    _pictImageView.layer.cornerRadius = 3;
    _pictImageView.clipsToBounds = YES;
    [self addSubview:_pictImageView];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:15];
    _titleLab.text = @"太古汇充电1区";
    [_titleLab sizeToFit];
    _titleLab.textColor = [UIColor blackColor];
    [self addSubview:_titleLab];
    
    _FutitleLab = [[UILabel alloc] init];
    _FutitleLab.font = [UIFont systemFontOfSize:12];
    _FutitleLab.text = @"天河路383号1区";
    _FutitleLab.numberOfLines = 0;
    _FutitleLab.textColor = RGBA(132, 133, 134, 1);
    [self addSubview:_FutitleLab];
    
    //添加一个导航按钮
    
    
    
    _diastaceLab = [[UILabel alloc] init];
    _diastaceLab.font = [UIFont systemFontOfSize:13];
    _diastaceLab.text = @"600m";
    [_diastaceLab sizeToFit];
    _diastaceLab.textColor = RGBA(132, 133, 134, 1);
    [self addSubview:_diastaceLab];
    
    
    _fastImageView = [[UIImageView alloc] init];
    _fastImageView.image = [UIImage imageNamed:@"kuais"];
    [self addSubview:_fastImageView];
    

    _slowImageView = [[UIImageView alloc] init];
    _slowImageView.image = [UIImage imageNamed:@"mans"];
    [self addSubview:_slowImageView];
    
    _fastLab = [[UILabel alloc] init];
    _fastLab.font = [UIFont systemFontOfSize:13];
    _fastLab.text = @"交流(2)";
    [_fastLab sizeToFit];
    _fastLab.textColor = RGBA(132, 133, 134, 1);
    [self addSubview:_fastLab];
    
    _slowLab = [[UILabel alloc] init];
    _slowLab.font = [UIFont systemFontOfSize:13];
    _slowLab.text = @"直流(2)";
    [_slowLab sizeToFit];
    _slowLab.textColor = RGBA(132, 133, 134, 1);
    [self addSubview:_slowLab];
    
    [self setConstrain];
}


-(void)setConstrain
{
    
    
    
    [_pictImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.size.mas_equalTo(CGSizeMake(64, 64));
        make.top.equalTo(_backView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        
    }];
 
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pictImageView.mas_right).offset(15);
        make.top.equalTo(_backView.mas_bottom).offset(10);
        
    }];
    
    [_FutitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pictImageView.mas_right).offset(15);
        make.top.equalTo(_titleLab.mas_bottom).offset(5);
        make.width.mas_equalTo(220);
        
    }];

    [_diastaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(_backView.mas_bottom).offset(20);
        
    }];

    [_fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
       make.left.equalTo(_pictImageView.mas_right).offset(15);
       make.top.equalTo(_FutitleLab.mas_bottom).offset(10);
       make.size.mas_equalTo(CGSizeMake(11, 11));
        
    }];
    
    [_fastLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fastImageView.mas_right).offset(5);
        make.top.equalTo(_FutitleLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(55,11));
    
    }];
    
    [_slowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_fastLab.mas_right);
        make.top.equalTo(_FutitleLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(11, 11));
        
    }];
    
    [_slowLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_slowImageView.mas_right).offset(5);
        make.top.equalTo(_FutitleLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(55,11));
        
    }];

}



//----------------------------------------//
-(void)addScrollViewWithArray:(NSArray *)array{
    
  _scroll.contentSize = CGSizeMake(scrollW * array.count, 200);
    //设置点的个数
  _pageControl.numberOfPages = array.count;

    for (int i = 0; i < array.count; i++) {
        
        UIView *back =  [[UIView alloc] initWithFrame:CGRectMake(scrollW * i, 0, scrollW, 200)];
        UIImageView *imageview = [[UIImageView alloc] init];//WithImage: [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL  URLWithString:array[i]]]]];
        NSURL *url = [NSURL URLWithString:array[i]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *images = [UIImage imageWithData:data];
        imageview.image = images;
        
        imageview.frame = back.bounds;
        [back addSubview:imageview];
        [_scroll addSubview:back];
    }

    //启动定时器
    [self initTimerFunction];
}

//添加定时器
-(void)initTimerFunction{
    //创建计时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoSelectPage) userInfo:nil repeats:YES];
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    [mainLoop addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}


-(void)autoSelectPage{
    //取出当前的偏移量
    CGPoint offset =  self.scroll.contentOffset;
    //取出当前的设置显示 的page指示
    NSInteger  currentPage = self.pageControl.currentPage;
    
    if (currentPage == (self.picArray.count - 1)) {
        //设置为初始值
        currentPage = 0;
        offset = CGPointZero;
        //更新offset
        [self.scroll setContentOffset:offset animated:YES];
    }else{
        currentPage++;
        offset.x += scrollW;
        //更新offset
        [self.scroll setContentOffset:offset animated:YES];
    }
    //更新pageControl显示
    self.pageControl.currentPage = currentPage;
}



#pragma mark  scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取当前scrollview 的X轴方向的 偏移量
    CGFloat offset = self.scroll.contentOffset.x;
    //每个图片页面的宽度
    CGFloat pageWi = scrollW;
    //设置当前的显示位置
    self.pageControl.currentPage = offset/pageWi;
}

//6、当手势滑动scrollview的时候停止定时器任务，滑动结束的时候开启定时任务
//当滑动开始的时候 ，停止计数器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //取消定时器任务
    [self.timer invalidate];
}
//当滑动停止时启动定时器任务
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.timer fire];
    //设置自动滚动定时任务
    [self initTimerFunction];
}

@end
