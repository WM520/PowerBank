//
//  WMNavWalkViewController.m
//  PowerBank
//
//  Created by baiju on 2017/8/3.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMNavWalkViewController.h"
#import "SpeechSynthesizer.h"

@interface WMNavWalkViewController ()
<AMapNaviWalkViewDelegate,
AMapNaviWalkManagerDelegate>

@property (nonatomic, strong) AMapNaviWalkView *walkView; // 导航的view
@property (nonatomic, strong) AMapNaviWalkManager *walkManager; // 导航manager
@property (nonatomic, strong) AMapNaviPoint *startPoint; // 导航起始点
@property (nonatomic, strong) AMapNaviPoint *endPoint; // 导航终点

@end

@implementation WMNavWalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initProperties];
    
    [self initWalkView];
    
    [self initwalkManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self calculateRoute];
}

- (void)viewWillLayoutSubviews
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        interfaceOrientation = self.interfaceOrientation;
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        [self.walkView setIsLandscape:NO];
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        [self.walkView setIsLandscape:YES];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -init
- (void)initProperties
{
    //设置导航的起点和终点
    self.startPoint = [AMapNaviPoint locationWithLatitude:_currentUL.latitude longitude:_currentUL.longitude];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:_coor.latitude longitude:_coor.longitude];
}

- (void)initWalkView
{
    if (self.walkView == nil)
    {
        self.walkView = [[AMapNaviWalkView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
        self.walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.walkView setDelegate:self];
        
        [self.view addSubview:self.walkView];
    }
}

- (void)initwalkManager
{
    if (self.walkManager == nil)
    {
        self.walkManager = [[AMapNaviWalkManager alloc] init];
        [self.walkManager setDelegate:self];
        
        [self.walkManager setAllowsBackgroundLocationUpdates:YES];
        [self.walkManager setPausesLocationUpdatesAutomatically:NO];
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [self.walkManager addDataRepresentative:self.walkView];
    }
}

- (void)calculateRoute
{
    //进行路径规划
    [self.walkManager calculateWalkRouteWithStartPoints:@[self.startPoint]
                                              endPoints:@[self.endPoint]];
}

#pragma mark -AMapNaviWalkViewDelegate

/**
 * @brief 导航界面关闭按钮点击时的回调函数
 * @param walkView 步行导航界面
 */
- (void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView
{
    //停止导航
    [self.walkManager stopNavi];
    [self.walkManager removeDataRepresentative:self.walkView];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * @brief 导航界面更多按钮点击时的回调函数
 * @param walkView 步行导航界面
 */
- (void)walkViewMoreButtonClicked:(AMapNaviWalkView *)walkView
{
    NSLog(@"walkViewMoreButtonClicked");
}

/**
 * @brief 导航界面转向指示View点击时的回调函数
 * @param walkView 步行导航界面
 */
- (void)walkViewTrunIndicatorViewTapped:(AMapNaviWalkView *)walkView
{
    NSLog(@"TrunIndicatorViewTapped");
}

/**
 * @brief 导航界面显示模式改变后的回调函数
 * @param walkView 步行导航界面
 * @param showMode 显示模式
 */
- (void)walkView:(AMapNaviWalkView *)walkView didChangeShowMode:(AMapNaviWalkViewShowMode)showMode
{
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}



#pragma mark -AMapNaviWalkManagerDelegate
/**
 * @brief 发生错误时,会调用代理的此方法
 * @param walkManager 步行导航管理类
 * @param error 错误信息
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

/**
 * @brief 步行路径规划成功后的回调函数
 * @param walkManager 步行导航管理类
 */
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后开始GPS导航
    [self.walkManager startGPSNavi];
}

/**
 * @brief 步行路径规划失败后的回调函数
 * @param walkManager 步行导航管理类
 * @param error 错误信息,error.code参照AMapNaviCalcRouteState
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error
{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

/**
 * @brief 启动导航后回调函数
 * @param walkManager 步行导航管理类
 * @param naviMode 导航类型，参考AMapNaviMode
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

/**
 * @brief 出现偏航需要重新计算路径时的回调函数.偏航后将自动重新路径规划,该方法将在自动重新路径规划前通知您进行额外的处理.
 * @param walkManager 步行导航管理类
 */
- (void)walkManagerNeedRecalculateRouteForYaw:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

/**
 * @brief 导航播报信息回调函数
 * @param walkManager 步行导航管理类
 * @param soundString 播报文字
 * @param soundStringType 播报类型,参考AMapNaviSoundType
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

/**
 * @brief 模拟导航到达目的地停止导航后的回调函数
 * @param walkManager 步行导航管理类
 */
- (void)walkManagerDidEndEmulatorNavi:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"didEndEmulatorNavi");
}

/**
 * @brief 导航到达目的地后的回调函数
 * @param walkManager 步行导航管理类
 */
- (void)walkManagerOnArrivedDestination:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"onArrivedDestination");
}
@end
