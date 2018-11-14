/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "QRCodeReaderViewController.h"
#import "QRCodeReaderView.h"
#import "UIView+Extension.h"
#import "XFunction.h"
#import "InsetsTextField.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "OpenChangeViewController.h"
#import "Masonry.h"
#import "WMNetWork.h"
#import "API.h"
#import "Config.h"
#import "XFunction.h"
#import "NavView.h"
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>

#define mainHeight     [[UIScreen mainScreen] bounds].size.height
#define mainWidth      [[UIScreen mainScreen] bounds].size.width
#define navBarHeight   self.navigationController.navigationBar.frame.size.height

@interface QRCodeReaderViewController ()<QRCodeReaderViewDelegate>
{
    InsetsTextField *textField;
}
@property (strong, nonatomic) QRCodeReaderView     *cameraView;
@property (strong, nonatomic) UIButton             *cancelButton;
@property (strong, nonatomic) QRCodeReader         *codeReader;
@property (assign, nonatomic) BOOL                 startScanningAtLoad;
@property (assign, nonatomic) BOOL                 showTorchButton;
@property (strong, nonatomic) UILabel              *lblTip;
@property (strong, nonatomic) UILabel              *lblTip1;
@property (strong, nonatomic) UILabel              *lblTip2;
@property (strong, nonatomic) UILabel              *lblTip3;
@property (strong, nonatomic) UILabel              *lblTip4;
@property (strong, nonatomic) UIButton             *TorchButton;
@property (strong, nonatomic) UIImageView          *imgLine;
@property (strong, nonatomic) NSTimer              *timerScan;

@property (strong, nonatomic) UIImageView  *img1;
@property (strong, nonatomic) UIImageView  *img2;
@property (strong, nonatomic) UIImageView  *img3;
@property (strong, nonatomic) UIImageView  *img4;
@property (strong, nonatomic) UIButton *shouBtn;
@property(strong,nonatomic) UIView *inputView;

@property (copy, nonatomic) void (^completionBlock) (NSString * __nullable);

@end

@implementation QRCodeReaderViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)dealloc
{
  [self stopScanning];

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    return [self initWithCancelButtonTitle:nil];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle
{
  return [self initWithCancelButtonTitle:cancelTitle metadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
}

- (id)initWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
  return [self initWithCancelButtonTitle:nil metadataObjectTypes:metadataObjectTypes];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle metadataObjectTypes:(NSArray *)metadataObjectTypes
{
  QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:metadataObjectTypes];

  return [self initWithCancelButtonTitle:cancelTitle codeReader:reader];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader
{
  return [self initWithCancelButtonTitle:cancelTitle codeReader:codeReader startScanningAtLoad:true];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad
{
  return [self initWithCancelButtonTitle:cancelTitle codeReader:codeReader startScanningAtLoad:startScanningAtLoad showTorchButton:NO];
}

- (id)initWithCancelButtonTitle:(nullable NSString *)cancelTitle codeReader:(nonnull QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad  showTorchButton:(BOOL)showTorchButton
{
  if ((self = [super init])) {
    self.view.backgroundColor = [UIColor whiteColor];
    self.codeReader             = codeReader;
    self.startScanningAtLoad    = startScanningAtLoad;
    self.showTorchButton        = showTorchButton;
    
  //  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"手电筒" style:UIBarButtonItemStylePlain target:self action:@selector(toggleTorchAction)];

    [self setupUIComponentsWithCancelButtonTitle:cancelTitle];
    [self setupAutoLayoutConstraints];

    [_cameraView.layer insertSublayer:_codeReader.previewLayer atIndex:0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];

    __weak typeof(self) weakSelf = self;

    [codeReader setCompletionWithBlock:^(NSString *resultAsString) {
      if (weakSelf.completionBlock != nil) {
        weakSelf.completionBlock(resultAsString);
      }

      if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(reader:didScanResult:)]) {
        [weakSelf.delegate reader:weakSelf didScanResult:resultAsString];
      }
        
    }];
  }
  return self;
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle
{
  return [[self alloc] initWithCancelButtonTitle:cancelTitle];
}

+ (instancetype)readerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
  return [[self alloc] initWithMetadataObjectTypes:metadataObjectTypes];
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle metadataObjectTypes:(NSArray *)metadataObjectTypes
{
  return [[self alloc] initWithCancelButtonTitle:cancelTitle metadataObjectTypes:metadataObjectTypes];
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader
{
  return [[self alloc] initWithCancelButtonTitle:cancelTitle codeReader:codeReader];
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad
{
  return [[self alloc] initWithCancelButtonTitle:cancelTitle codeReader:codeReader startScanningAtLoad:startScanningAtLoad];
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad  showTorchButton:(BOOL)showTorchButton
{
    
  return [[self alloc] initWithCancelButtonTitle:cancelTitle codeReader:codeReader startScanningAtLoad:startScanningAtLoad showTorchButton:showTorchButton];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
    
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    CGFloat c_width = mainWidth - 100;
    CGFloat s_height = mainHeight - 40;
    CGFloat y = (s_height - c_width) / 2 - s_height / 6;
    CGFloat cwidth = mainWidth;
    
    _imgLine.frame = CGRectMake(0, y+77, cwidth, 12);
    
    [self scanAnimate];
    [self startScanning];
}

- (void)loadView:(CGRect)rect
{
//    _imgLine.frame = CGRectMake(0, _cameraView.innerViewRect.origin.y, mainWidth, 12);
//    [self scanAnimate];
}

- (void)viewWillDisappear:(BOOL)animated
{
      [super viewWillDisappear:animated];
//  CGFloat c_width = mainWidth - 100;
//  CGFloat s_height = mainHeight - 40;
//  CGFloat y = (s_height - c_width) / 2 - s_height / 6;
//  CGFloat cwidth = mainWidth;
//
//    
  [self stopScanning];
//  _imgLine.frame = CGRectMake(0, y+77, cwidth, 12);
  self.navigationController.interactivePopGestureRecognizer.enabled = YES;

}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];

  _codeReader.previewLayer.frame = self.view.bounds;
}

- (BOOL)shouldAutorotate
{
  return YES;
}

#pragma mark - Controlling the Reader

- (void)startScanning {
  [_codeReader startScanning];
  
    if(_timerScan)
    {
        [_timerScan invalidate];
        _timerScan = nil;
    }
    
    _timerScan = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanAnimate) userInfo:nil repeats:YES];
}

- (void)stopScanning {
  [_codeReader stopScanning];
    if(_timerScan)
    {
        [_timerScan invalidate];
        _timerScan = nil;
    }
}

#pragma mark - Managing the Orientation

- (void)orientationChanged:(NSNotification *)notification
{
  [_cameraView setNeedsDisplay];

  if (_codeReader.previewLayer.connection.isVideoOrientationSupported) {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    _codeReader.previewLayer.connection.videoOrientation = [QRCodeReader videoOrientationFromInterfaceOrientation:
                                                            orientation];
  }
}

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    NSLog(@"已经知道扫码了");
    NSLog(@"内部resultAsString = %@",completionBlock);
    self.completionBlock = completionBlock;

}

#pragma mark - Initializing the AV Components

- (void)setupUIComponentsWithCancelButtonTitle:(NSString *)cancelButtonTitle
{
    self.cameraView                                       = [[QRCodeReaderView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    _cameraView.clipsToBounds                             = YES;
    self.cameraView.delegate = self;
    [self.view addSubview:_cameraView];
    
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"充电" rightTitle:@"手电筒"];
    [nav setRightBtnMasonry];
    nav.rightBlock = ^{
        [self toggleTorchAction];//手电筒
    };
    
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(44 + StatusBarH);
    }];
    
    CGFloat c_width = mainWidth - 100;
    CGFloat s_height = mainHeight - 40;
    CGFloat y = (s_height - c_width) / 2 - s_height / 6;
    
    _lblTip2 = [[UILabel alloc] initWithFrame:CGRectMake(0,y + 30, mainWidth, 15)];
    _lblTip2.text = @"请将充电桩表面或者液晶屏幕上的二维码";
    _lblTip2.textColor = [UIColor whiteColor];
    _lblTip2.font = [UIFont systemFontOfSize:15];
    _lblTip2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lblTip2];
    
    _lblTip3 = [[UILabel alloc] initWithFrame:CGRectMake(0,y + 30 + 20, mainWidth, 15)];
    _lblTip3.text = @"放入框内即可自动扫描";
    _lblTip3.textColor = [UIColor whiteColor];
    _lblTip3.font = [UIFont systemFontOfSize:15];
    _lblTip3.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lblTip3];
    
    CGFloat corWidth = 16;
    
    _img1 = [[UIImageView alloc] initWithFrame:CGRectMake(49, y + 77, corWidth, corWidth)];
    _img1.image = [UIImage imageNamed:@"cor1"];
    [self.view addSubview:_img1];
    
    _img2 = [[UIImageView alloc] initWithFrame:CGRectMake(35 + c_width, y + 77, corWidth, corWidth)];
    _img2.image = [UIImage imageNamed:@"cor2"];
    [self.view addSubview:_img2];
    
    _img3 = [[UIImageView alloc] initWithFrame:CGRectMake(49, y + c_width + 64, corWidth, corWidth)];
    _img3.image = [UIImage imageNamed:@"cor3"];
    [self.view addSubview:_img3];
    
    _img4 = [[UIImageView alloc] initWithFrame:CGRectMake(35 + c_width, y + c_width + 64, corWidth, corWidth)];
    _img4.image = [UIImage imageNamed:@"cor4"];
    [self.view addSubview:_img4];
    
    _shouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shouBtn.frame = CGRectMake(XYScreenWidth/2 - 60,y + 90 + c_width +5+20+20, 120, 42);
    _shouBtn.backgroundColor = RGBA(29, 167, 146, 1);
    [_shouBtn setTitle:@"输入电桩号" forState:UIControlStateNormal];
    [_shouBtn setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
    [_shouBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [_shouBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shouBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _shouBtn.layer.masksToBounds = YES;
    _shouBtn.layer.cornerRadius = 5;
    [self.view addSubview:_shouBtn];
    
   _imgLine = [[UIImageView alloc] init];
    _imgLine.image = [UIImage imageNamed:@"QRCodeScanLine"];
   [self.view addSubview:_imgLine];
    

   [_codeReader.previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

  if ([_codeReader.previewLayer.connection isVideoOrientationSupported]) {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    _codeReader.previewLayer.connection.videoOrientation = [QRCodeReader videoOrientationFromInterfaceOrientation:orientation];
  }

  if (_showTorchButton && [_codeReader isTorchAvailable]) {

      _TorchButton = [UIButton buttonWithType:UIButtonTypeCustom];
      _TorchButton.frame = CGRectMake(0,y + 90 + c_width +5+20+35, 42, 42);
      _TorchButton.centerX = self.view.centerX;
      [_TorchButton setBackgroundImage:[UIImage imageNamed:@"ic_map_light"] forState:UIControlStateNormal];
      [_TorchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_TorchButton addTarget:self action:@selector(toggleTorchAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:_TorchButton];
  }

  self.cancelButton                                       = [[UIButton alloc] init];
  _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
  [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
  [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_cancelButton];

}

- (void)setupAutoLayoutConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_cameraView, _cancelButton);
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView][_cancelButton(0)]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_cancelButton]-|" options:0 metrics:nil views:views]];
}

- (void)scanAnimate
{
    CGFloat c_width = mainWidth - 100;
    CGFloat s_height = mainHeight - 40;
    CGFloat y = (s_height - c_width) / 2 - s_height / 6;
    CGFloat cwidth = mainWidth;
    
    _imgLine.frame = CGRectMake(0, y+77, cwidth, 12);
    
//  _imgLine.frame = CGRectMake(0, _cameraView.innerViewRect.origin.y, mainWidth, 12);
//    _imgLine.frame = CGRectMake(35,y+77, cwidth, 12);
//    [UIView animateWithDuration:3 animations:^{
//        _imgLine.frame = CGRectMake(_imgLine.frame.origin.x, _imgLine.frame.origin.y + _cameraView.innerViewRect.size.height - 6, _imgLine.frame.size.width, _imgLine.frame.size.height);
//    }];
    [UIView animateWithDuration:3 animations:^{
      _imgLine.frame = CGRectMake(_imgLine.frame.origin.x,_imgLine.frame.origin.y + c_width-5,cwidth,12);
    }];
}

- (void)switchDeviceInput
{
  [_codeReader switchDeviceInput];
}

#pragma mark - Catching Button Events

- (void)cancelAction:(UIButton *)button
{
  [_codeReader stopScanning];
    
    if(_timerScan)
    {
        [_timerScan invalidate];
        _timerScan = nil;
    }
    
  if (_completionBlock) {
    _completionBlock(nil);
  }

  if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
    [_delegate readerDidCancel:self];
  }
}

- (void)switchCameraAction:(UIButton *)button
{
  [self switchDeviceInput];
}

- (void)toggleTorchAction
{
  [_codeReader toggleTorch];
}

-(void)click
{
    _lblTip2.alpha = 0;
    _lblTip3.alpha = 0;
    _img1.alpha = 0;
    _img2.alpha = 0;
    _img3.alpha = 0;
    _img4.alpha = 0;
    _shouBtn.alpha = 0;
    _imgLine.alpha = 0;
    [self createInputView];
}

-(UIView*)createInputView{
    if (!self.inputView) {
        self.inputView = [UIView new];
        [self.view addSubview:self.inputView];
        [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(30);
            make.right.offset(-30);
            make.height.mas_equalTo(110);
            make.center.equalTo(self.view).centerOffset(CGPointMake(0, -50));
        }];
        textField = [InsetsTextField new];
        [textField becomeFirstResponder];
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.cornerRadius = 3;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = [UIFont systemFontOfSize:14];
    //  textField.placeholder = @"请输入电桩号";
        [self.inputView addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.inputView).insets(UIEdgeInsetsMake(0, 0, 60, 0));
        }];
        
        //如果有之前输入的充电桩号就赋值
   //     if ([Config getInPutChargeNum]){
     //      textField.placeholder = @"";
       //    textField.text = [Config getInPutChargeNum];
       // }else
       // {
       //    textField.placeholder = @"请输入电桩号";
       // }
        
        UIButton *switchToScaning = [UIButton buttonWithType:UIButtonTypeCustom];
        switchToScaning.layer.cornerRadius = 5;
        switchToScaning.layer.masksToBounds = YES;
        switchToScaning.backgroundColor = [UIColor whiteColor];
        switchToScaning.titleLabel.font = [UIFont systemFontOfSize:14];
        [switchToScaning setTitle:@"切换扫码" forState:UIControlStateNormal];
        [switchToScaning addTarget:self action:@selector(qieHuaSaoMa) forControlEvents:UIControlEventTouchUpInside];
        [switchToScaning setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.inputView addSubview:switchToScaning];
        [switchToScaning mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputView.mas_left);
            make.height.mas_equalTo(50);
            make.top.equalTo(textField.mas_bottom).with.offset(10);
        }];
        
        UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yesBtn.layer.cornerRadius = 5;
        yesBtn.layer.masksToBounds = YES;
        yesBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [yesBtn setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
        [yesBtn addTarget:self action:@selector(sureBtn) forControlEvents:UIControlEventTouchUpInside];
        [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.inputView addSubview:yesBtn];
        [yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(switchToScaning.mas_centerY);
            make.left.equalTo(switchToScaning.mas_right).offset(10);
            make.right.right.equalTo(self.inputView.mas_right);
            make.height.equalTo(switchToScaning.mas_height);
            make.width.equalTo(switchToScaning.mas_width);
        }];
    }
    return self.inputView;
}

-(void)qieHuaSaoMa
{
    _lblTip2.alpha = 1;
    _lblTip3.alpha = 1;
    _img1.alpha = 1;
    _img2.alpha = 1;
    _img3.alpha = 1;
    _img4.alpha = 1;
    _shouBtn.alpha = 1;
    _imgLine.alpha = 1;
    [self.inputView removeFromSuperview];
    self.inputView = nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)sureBtn
{
    //判断是否登陆
    if ([Config getOwnID]) {
   
            //判断输入的充电桩号
            if ([textField.text isEqualToString:@""] || [textField.text length]==0) {
                [MBProgressHUD show:@"请输入充电桩号" icon:nil view:self.view];
            }
            else
            {
                //收起键盘
                [self.view endEditing:YES];
                
                //二维码是24位数字
                    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
                    parmas[@"qrCode"] = textField.text;//扫描结果10
                    parmas[@"token"] = [Config getToken];
                    NSLog(@"token = %@",[Config getToken]);
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                    [WMNetWork get:ScanQrCode parameters:parmas success:^(id responseObj) {
                        
                        NSLog(@"responseObjrrrrrrr = %@",responseObj);
                        
                        if ([responseObj[@"status"] intValue] == 0) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //                            [MBProgressHUD hideHUD];
                            //保存手动输入的充电桩号
                           // [Config saveInPutChargeNum:textField.text];
                            
                            OpenChangeViewController *openVC = [[OpenChangeViewController alloc] init];
                            
                            NSString *equStr = responseObj[@"equipmentNum"];
                            //                           NSString *equStr = resultAsString;
                            
                            NSString *chargingStr = responseObj[@"stationName"];
                            openVC.equipmentNum = equStr;
                            openVC.chargingAddress = chargingStr;
                            NSLog(@"chargingStr地址 = %@",chargingStr);
                            [self.navigationController pushViewController:openVC animated:YES];
                            
                        }else if ([responseObj[@"status"] intValue] == 401)
                        {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //[MBProgressHUD hideHUD];
                            [Config removeOwnID];//移除ID
                            [Config removeUseName];//移除用户名字
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            
                            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"手机号登陆异常" message:nil preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *sureAction= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                            }];
                            
                            [alertVc addAction:sureAction];
                            
                            //调用self的方法展现控制器
                            [self presentViewController:alertVc animated:YES completion:nil];
                            
                        }else
                        {
                            [MBProgressHUD showError:responseObj[@"message"]];
                        }
                    } failure:^(NSError *error) {
                        NSLog(@"error = %@",error);
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if (error) {
                            [MBProgressHUD showError:@"网络连接失败"];
                        }
                    }];
                    
                
//                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"该二维码无效，或者不属于兴国充电桩" preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                       
//                    }];
//                    
//                    [alertVc addAction:sureAction];
//                    [self presentViewController:alertVc animated:YES completion:nil];
                }
        
        
    }else
    {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登陆账号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         
        }];
        
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
 }
@end
