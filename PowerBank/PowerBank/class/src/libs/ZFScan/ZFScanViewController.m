//
//  ZFScanViewController.m
//  ZFScan
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZFMaskView.h"
#import <ImageIO/ImageIO.h>
#import "WMInputSerialNumberViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ZFScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, CBCentralManagerDelegate>

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIButton * goToSettings;
/** 设备 */
@property (nonatomic, strong) AVCaptureDevice * device;
/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession * session;
/** 相机图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
/** 扫描支持的编码格式的数组 */
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;
/** 遮罩层 */
@property (nonatomic, strong) ZFMaskView * maskView;
/** 返回按钮 */
@property (nonatomic, strong) UIButton * backButton;
/** 手电筒 */
@property (nonatomic, strong) UIButton * flashlight;
/** 返回提示Label */
@property (nonatomic, strong) UILabel * backHintLabel;
/** 手电筒提示Label */
@property (nonatomic, strong) UILabel * flashlightHintLabel;
/** 蓝牙控制中心 */
@property (nonatomic, strong) CBCentralManager * bluetoothManager;
/** 是否要打开蓝牙的弹窗 */
@property (nonatomic, strong) WMCustomAlert * alert;
/** 提示Label */
@property (nonatomic, strong) UILabel * warningLabel;

@end

@implementation ZFScanViewController

- (NSMutableArray *)metadataObjectTypes{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil];
        
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
        }
    }
    
    return _metadataObjectTypes;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.maskView removeAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码充电";
    if (![[AppSettings sharedInstance] isCameraAuthority]) {
        if (!_bgView) {
            _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _bgView.backgroundColor = ThemeColor;
            _goToSettings = [[UIButton alloc] init];
            _goToSettings.backgroundColor = [UIColor redColor];
            [_goToSettings addTarget:self action:@selector(goToSettings:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:_goToSettings];
            
            _goToSettings.sd_layout
            .centerXEqualToView(_bgView)
            .centerYEqualToView(_bgView)
            .widthIs(100)
            .heightIs(100);
            
            [self.view addSubview:_bgView];
        }
        return;
    }
    [self capture];
    [self addUI];
//    (void)self.bluetoothManager;
    if (!_isWarranty) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_0
        NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                  CBCentralManagerOptionShowPowerAlertKey,
                                  @"babyBluetoothRestore",
                                  CBCentralManagerOptionRestoreIdentifierKey, nil];
#else
        NSDictionary * options = nil;
#endif
        NSArray * backgroundModes = [[[NSBundle alloc] infoDictionary] objectForKey:@""];
        if ([backgroundModes containsObject:@"bluetooth-central"]) {
            _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
        } else {
            _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:[NSNumber numberWithBool:NO]}];
        }
    }
}

- (void)dealloc
{
    [_alert hide];
}

- (void)goToSettings:(UIButton *)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"App-Prefs:root=com.ool.baiju"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=com.ool.baiju"]];
    }
    
}

/**
 *  添加遮罩层
 */
- (void)addUI{
    
    self.maskView = [[ZFMaskView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.maskView];
    
    //提示框
//    CGFloat warn_width = 60;
//    CGFloat warn_height = 30;
//    
//    self.warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, warn_width * 2, warn_height)];
//    self.warningLabel.backgroundColor = [UIColor redColor];
//    self.warningLabel.text = @"请对准充电宝上的二维码";
//    self.warningLabel.textAlignment = NSTextAlignmentCenter;
//    self.warningLabel.textColor = ZFWhite;
//    [self.view addSubview:self.warningLabel];
    
    
    //返回按钮
    CGFloat back_width = 35;
    CGFloat back_height = 60;
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backButton.frame = CGRectMake(0, 0, back_width, back_height);
    [self.backButton setImage:[[UIImage imageNamed:@"openlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [self.backButton setImage:[[UIImage imageNamed:@"openlightSelect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
//    [self.backButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(flashlightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    //返回提示Label
    CGFloat backHint_width = 60;
    CGFloat backHint_height = 30;
    
    self.backHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backHint_width * 2, backHint_height)];
//    self.backHintLabel.text = @"手动输入设备编码";
    self.backHintLabel.text = @"点亮扫码区域";
    self.backHintLabel.textAlignment = NSTextAlignmentCenter;
    self.backHintLabel.textColor = ZFWhite;
    [self.view addSubview:self.backHintLabel];
    
    //手电筒
    CGFloat flashlight_width = 35;
    CGFloat flashlight_height = 60;
    
    self.flashlight = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashlight.frame = CGRectMake(0, 0, flashlight_width, flashlight_height);
//    [self.flashlight setImage:[UIImage imageNamed:@"openlight"] forState:UIControlStateNormal];
    [self.flashlight setImage:[[UIImage imageNamed:@"inputNumber"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [self.flashlight addTarget:self action:@selector(flashlightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.flashlight addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashlight];
    
    //手电筒提示Label
    CGFloat flashlightHint_width = 60;
    CGFloat flashlightHint_height = 30;
    
    self.flashlightHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, flashlightHint_width * 2.5, flashlightHint_height)];
//    self.flashlightHintLabel.text = @"点亮扫码区域";
    self.flashlightHintLabel.text = @"手动输入设备编码";
    self.flashlightHintLabel.textAlignment = NSTextAlignmentCenter;
    self.flashlightHintLabel.textColor = ZFWhite;
    [self.view addSubview:self.flashlightHintLabel];
  
    
    //横屏
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        
        self.backButton.center = CGPointMake(100, SCREEN_HEIGHT / 2);;
        self.backHintLabel.center = CGPointMake(100, CGRectGetMaxY(self.backButton.frame) + CGRectGetHeight(self.backHintLabel.frame) / 2);
        self.flashlight.center = CGPointMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT / 2);
        self.flashlightHintLabel.center = CGPointMake(SCREEN_WIDTH - 100, CGRectGetMaxY(self.flashlight.frame) + CGRectGetHeight(self.flashlightHintLabel.frame) / 2);
    
    //竖屏
    }else{
        self.backButton.center = CGPointMake(SCREEN_WIDTH / 4, SCREEN_HEIGHT - 100);
        self.backHintLabel.center = CGPointMake(SCREEN_WIDTH / 4, CGRectGetMaxY(self.backButton.frame) + CGRectGetHeight(self.backHintLabel.frame) / 2);
        self.flashlight.center = CGPointMake(SCREEN_WIDTH / 4 * 3, SCREEN_HEIGHT - 100);
        self.flashlightHintLabel.center = CGPointMake(SCREEN_WIDTH / 4 * 3, CGRectGetMaxY(self.flashlight.frame) + CGRectGetHeight(self.flashlightHintLabel.frame) / 2);
    }
}

/**
 *  扫描初始化
 */
- (void)capture{
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    [self.session addInput:input];
    [self.session addOutput:metadataOutput];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:self.previewLayer];
    
    //设置扫描支持的编码格式(如下设置条形码和二维码兼容)
    metadataOutput.metadataObjectTypes = self.metadataObjectTypes;
    
    //开始捕获
    [self.session startRunning];
}

#pragma mark - 取消事件

/**
 * 输入编号开启充电宝
 */
- (void)cancelAction{
//    if (self.navigationController) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    WMInputSerialNumberViewController * vc = [[WMInputSerialNumberViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 打开/关闭 手电筒

- (void)flashlightAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"openlightSelect"] forState:UIControlStateSelected];
        self.flashlightHintLabel.textColor = DominantColor;
        
        //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
        
    }else{
        [sender setImage:[UIImage imageNamed:@"openlightSelect"] forState:UIControlStateSelected];
        self.flashlightHintLabel.textColor = ZFWhite;
        
        //关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        self.returnScanBarCodeValue(metadataObject.stringValue);
        
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - 横竖屏适配

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    self.maskView.frame = CGRectMake(0, 0, size.width, size.height);
    self.previewLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [self.maskView resetFrame];
    
    //横屏(转之前是横屏，转之后是竖屏)
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        
        self.backButton.center = CGPointMake(SCREEN_HEIGHT / 4, SCREEN_WIDTH - 100);
        self.backHintLabel.center = CGPointMake(SCREEN_HEIGHT / 4, CGRectGetMaxY(self.backButton.frame) + CGRectGetHeight(self.backHintLabel.frame) / 2);
        self.flashlight.center = CGPointMake(SCREEN_HEIGHT / 4 * 3, SCREEN_WIDTH - 100);
        self.flashlightHintLabel.center = CGPointMake(SCREEN_HEIGHT / 4 * 3, CGRectGetMaxY(self.flashlight.frame) + CGRectGetHeight(self.flashlightHintLabel.frame) / 2);
    
    //竖屏(转之前是竖屏，转之后是横屏)
    }else{
        self.backButton.center = CGPointMake(100, SCREEN_WIDTH / 2);
        self.backHintLabel.center = CGPointMake(100, CGRectGetMaxY(self.backButton.frame) + CGRectGetHeight(self.backHintLabel.frame) / 2);
        self.flashlight.center = CGPointMake(SCREEN_HEIGHT - 100, SCREEN_WIDTH / 2);
        self.flashlightHintLabel.center = CGPointMake(SCREEN_HEIGHT - 100, CGRectGetMaxY(self.flashlight.frame) + CGRectGetHeight(self.flashlightHintLabel.frame) / 2);
        
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:{
            NSLog(@"蓝牙没有开启");
            WMCustomAlert * alert = [[WMCustomAlert alloc] initWithTitle:@"打开蓝牙功能会更快开启充电宝开关，是否开启" cancleButtonTitle:@"否" commitButtonTitle:@"是" isCancleImage:NO];
            alert.cancleBlock = ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Bluetooth"]];
            };
            _alert = alert;
            [alert show];
        }
            break;
        case CBCentralManagerStatePoweredOn:
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"当前设备不支持蓝牙");
            break;
        default:
            break;
    }
}



- (CBCentralManager *)bluetoothManager
{
    if (_bluetoothManager == nil) {
        _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _bluetoothManager;
}

@end
