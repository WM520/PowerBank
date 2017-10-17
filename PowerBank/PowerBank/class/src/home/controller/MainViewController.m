//
//  ViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/6/2.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "MainViewController.h"
#import "MineViewController.h"
#import "WRNavigationBar.h"
#import "LoginViewController.h"
#import "WMMainRightViewController.h"
#import "WMMainLeftViewViewController.h"
#import "ToolsView.h"
#import "WMUserModel.h"
#import "WMMessageViewController.h"

@interface MainViewController ()
<ToolsViewDelegate>
@property (strong, nonatomic) UIButton *mineButton;
@property (strong, nonatomic) UIButton *messageButton;
@property (strong, nonatomic) UISegmentedControl * segmentControl;
@property (strong, nonatomic) UIScrollView * mainScrollview;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) WMMainLeftViewViewController * leftVC;
@property (strong, nonatomic) WMMainRightViewController * rightVC;
@property (strong, nonatomic) MAMapView * mapView;
@property (strong, nonatomic) ToolsView * toolsView;
@property (nonatomic, strong) WMScopeView * scopeView;
@property (nonatomic, copy) NSString * deviceID;
/** 用户信息model */
@property (nonatomic, strong) WMUserModel * userModel;

@end

@implementation MainViewController

#pragma mark -lifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    // 初始化导航栏
    [self configNavBar];
    [self setupChildViewControllers];
    // 初始化页面控件
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti1) name:@"noti1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti2) name:@"noti2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swithModeAction) name:@"addressMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapModeAction) name:@"mapMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(opensuccess) name:@"opensuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeShare) name:@"closeShare" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exit) name:@"exit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openfailed) name:@"openfailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCancle) name:@"orderCancle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderEnded) name:@"orderEnded" object:nil];
//    [[NSNotificationCenter defaultCenter]  postNotificationName:@"haveshareorder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveShareOrder) name:@"haveshareorder" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_index == 0) {
        [_mainScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        
    } else if (_index == 1) {
        [_mainScrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
    
    if (_scopeView) {
        _scopeView.hidden = NO;
    }
    
    if ([AppSettings checkIsLogin]) {
        [WMRequestHelper acquiringInformation:[[AppSettings sharedInstance] stringForKey:@"token"] withCompletionHandle:^(BOOL success, id dataDic) {
            if (success) {
                if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"] && [[dataDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    WMUserModel * model = [WMUserModel modelWithDictionary:[dataDic objectForKey:@"data"]];
                    [[AppSettings sharedInstance] loginsaveCache:model];
                    _userModel = model;
                }
            }
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_scopeView) {
        _scopeView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notifocationMethods
- (void)noti1
{
    _toolsView.hidden = YES;
}

- (void)noti2
{
    _toolsView.hidden = NO;
}

- (void)swithModeAction
{
    _toolsView.hidden = YES;
}

- (void)mapModeAction
{
    _toolsView.hidden = NO;
}

- (void)setupChildViewControllers
{
    WMMainLeftViewViewController * leftvc = [[WMMainLeftViewViewController alloc] init];
    [self addChildViewController:leftvc];
    WMMainRightViewController * rightvc = [[WMMainRightViewController alloc] init];
    [self addChildViewController:rightvc];
}

- (void)opensuccess
{
    _toolsView.shareButton.selected = YES;
}

- (void)closeShare
{
    _toolsView.shareButton.selected = NO;
    _index = 0;
    if (_leftVC.sendOrderView) {
        _leftVC.sendOrderView.hidden = NO;
    }
    [_mainScrollview setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)exit
{
    _toolsView.shareButton.selected = NO;
    _index = 0;
    [_mainScrollview setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)openfailed
{
    _index = 0;
    _toolsView.shareButton.selected = NO;
    [_mainScrollview setContentOffset:CGPointMake(0, 0) animated:NO];
}
- (void)orderCancle
{
    _index = 0;
    _toolsView.shareButton.selected = NO;
    [_mainScrollview setContentOffset:CGPointMake(0, 0) animated:NO];
    if (_toolsView.hidden) {
        _toolsView.hidden = NO;
    }
}

- (void)orderEnded
{
    _index = 0;
    _toolsView.shareButton.selected = NO;
    [_mainScrollview setContentOffset:CGPointMake(0, 0) animated:NO];
    if (_toolsView.hidden) {
        _toolsView.hidden = NO;
    }
}

- (void)haveShareOrder
{
    _index = 1;
    _toolsView.shareButton.selected = YES;
    [_mainScrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
}

#pragma mark -configNavBar
- (void)configNavBar
{
    // 自定义nav
    [self wr_setNavBarBarTintColor:DominantColor];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.mineButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, leftBarItem];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.messageButton];
    UIBarButtonItem *rightNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightNagetiveSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[rightNagetiveSpacer, rightBarItem];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 110, 30)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"OOL"];
    self.navigationItem.titleView = imageView;
}
#pragma mark -initUI
-(void)initUI
{
    [self.view addSubview:self.mainScrollview];
    WMMainLeftViewViewController * leftVc = self.childViewControllers[0];
    leftVc.view.x = 0;
    leftVc.view.y = 0;
    leftVc.view.width = self.mainScrollview.width;
    leftVc.view.height = self.mainScrollview.height;
    [self.mainScrollview addSubview:leftVc.view];
    _leftVC = leftVc;
    
    WMMainRightViewController * vc = self.childViewControllers[1];
    vc.view.y = 0;
    vc.view.width = SCREEN_WIDTH;
    vc.view.height = self.mainScrollview.height;
    vc.view.x = SCREEN_WIDTH;
    vc.isVisabel = 0;
    [self.mainScrollview addSubview:vc.view];
    _rightVC = vc;
    
    _toolsView = [[ToolsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 122, SCREEN_WIDTH, 122)];
    _toolsView.delegate = self;
    _toolsView.userInteractionEnabled = YES;
    [self.view addSubview:_toolsView];
}

#pragma mark -initData
- (void)initData
{
    _index = 0;
}

#pragma mark -protectMethods
// 跳转个人中心页面
- (void)goToMine
{
    BOOL isLogin = [AppSettings checkIsLogin];
    if (!isLogin) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
            
        }];
        return;
    }
    MineViewController *vc = [[MineViewController alloc] init];
    vc.userModel = _userModel;
    [self.navigationController pushViewController:vc animated:YES];
}

// 跳转消息页面
- (void)goToMessage
{
    BOOL isLogin = [AppSettings checkIsLogin];
    if (!isLogin) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
            
        }];
        return;
    }
    WMMessageViewController *vc = [[WMMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ToolsViewDelegate
- (void)goToScanView
{
    BOOL isLogin = [AppSettings checkIsLogin];
    if (!isLogin) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
            
        }];
        return;
    }
    ZFScanViewController * vc = [[ZFScanViewController alloc] init];
    vc.isPower = YES;
    vc.returnScanBarCodeValue = ^(NSString * barCodeString){
        //扫描完成后，在此进行后续操作
        NSLog(@"扫描结果======%@",barCodeString);
        NSArray * strings = [barCodeString componentsSeparatedByString:@"?"];
        NSArray * strings1 = [strings[1] componentsSeparatedByString:@"&"];
        NSArray * uuids = [strings1[0] componentsSeparatedByString:@"="];
        //        NSArray * macs = [strings1[1] componentsSeparatedByString:@"="];
        NSString * uuid = [uuids objectAtIndex:1];
        //        NSString * mac = [macs objectAtIndex:1];
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:uuid options:0];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", decodedString);
        // 开启充电宝充电接口
        [WMRequestHelper openToPowerWithUuid:decodedString longitude:[NSString stringWithFormat:@"%lf", _leftVC.nowLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", _leftVC.nowLocation.coordinate.longitude] address:_leftVC.nowAddress withCompletionHandle:^(BOOL success, id dataDic) {
            if (success) {
                if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                    [[PhoneNotification sharedInstance] autoHideWithText:@"开启充电成功"];
                }
            }
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openShare:(UIButton *)button
{
    
    BOOL isLogin = [AppSettings checkIsLogin];
    if (!isLogin) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
            
        }];
        return;
    }
    
    if (button.selected) {
        if (_rightVC.isReceiveOrder) {
            [[PhoneNotification sharedInstance] autoHideWithText:@"您有正在进行的订单"];
            return;
        } else {
            _index = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"closeshare" object:nil];
            if (_leftVC.sendDemandView) {
                _leftVC.sendDemandView.hidden = NO;
            }
            if (_rightVC.isScopeView) {
                _rightVC.scopeView.hidden = YES;
            }
            if (_leftVC.sendOrderView) {
                _leftVC.sendOrderView.hidden = NO;
            }
            button.selected = NO;
            [_mainScrollview setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    } else {
        _index = 1;
        if (_leftVC.sendDemandView) {
            _leftVC.sendDemandView.hidden = YES;
        }
        if (_rightVC.isScopeView) {
            _rightVC.scopeView.hidden = NO;
        }
        if (_leftVC.sendOrderView) {
            _leftVC.sendOrderView.hidden = YES;
        }
        [_mainScrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        if (_rightVC.isReceiveOrder) {
            [[PhoneNotification sharedInstance] autoHideWithText:@"您有正在进行的订单"];
            button.selected = YES;
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"share" object:nil];
       
    }
}

// 解决被覆盖的定位按钮
- (void)location
{
    NSLog(@"location");
    if (_index == 0) {
        [_leftVC currentLocation];
    } else {
        [_rightVC currentLocation];
    }
}

- (void)hide:(UIButton *)btn
{
    if (!btn.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            _toolsView.frame = CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 122);
            _toolsView.scanButton.hidden = YES;
            _toolsView.shareButton.hidden = YES;
            
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _toolsView.frame = CGRectMake(0, SCREEN_HEIGHT - 122, SCREEN_WIDTH, 122);
            _toolsView.scanButton.hidden = NO;
            _toolsView.shareButton.hidden = NO;
        }];
    }
    btn.selected = !btn.selected;
}


#pragma mark -Getters and Setter

- (UIButton *)mineButton
{
    if (!_mineButton) {
        _mineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
        [_mineButton setImage:[UIImage imageNamed:@"mine.png"] forState:UIControlStateNormal];
        [_mineButton addTarget:self action:@selector(goToMine) forControlEvents:UIControlEventTouchUpInside];
        [_mineButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, -15)];
    }
    return _mineButton;
}

- (UIButton *)messageButton
{
    if (!_messageButton) {
        _messageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - 44, 20, 44, 44)];
        [_messageButton setImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
         [_messageButton addTarget:self action:@selector(goToMessage) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _messageButton;
}

- (UIScrollView *)mainScrollview
{
    if (!_mainScrollview) {
        _mainScrollview = [[UIScrollView alloc] init];
        _mainScrollview.userInteractionEnabled = YES;
        _mainScrollview.frame = CGRectMake(0, 64, SCREEN_WIDTH , SCREEN_HEIGHT-64);
        
        _mainScrollview.backgroundColor = ThemeColor;
    }
    return _mainScrollview;
}


@end
