//
//  MineViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/6/19.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeadView.h"
#import "MineTableViewCell.h"
#import "MineCellModel.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import "XBSettingCell.h"
#import "SharedRecordViewController.h"
#import "IntroduceViewController.h"
#import "FeedBackViewController.h"
#import "WMMoreViewController.h"
#import "WMMineDetailViewController.h"
#import "WMMineWalletViewController.h"
#import "WMRealNameAuthenticationViewController.h"
#import "WMMessageViewController.h"
#import "WMCreditValueViewController.h"
#import "WMUserModel.h"
//#import "WXPayModel.h"
//#import "WXPayTool.h"
#import "WMAliyunTokenModel.h"
#import <AliyunOSSiOS/OSSService.h>
OSSClient * client;
NSString * const endPoint = @"http://himage.ool.vc";
static NSString *cellID = @"minecell";

@interface MineViewController ()
<UITableViewDelegate,
UITableViewDataSource,
MineHeadViewDelegate>
/** 头部视图 */
@property (nonatomic, strong) MineHeadView *headView;
/** 主体列表 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 列表数组 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MineViewController

#pragma mark -lifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // configNav
    /** 初始化section */
    [self setupSections];
    /** 初始化UI */
    [self configBaseUI];
    /** 初始化导航栏 */
    [self congfigNav];
    // 初始化usermodel
    [self initData];
    // 登录成功的回调
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginsuccess" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    // 设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark -setUpData
// 获取个人数据
- (void)initData
{
    self.headView.model = self.userModel;
    NSString *path_document = NSHomeDirectory();
    NSString *imagePath = [path_document stringByAppendingString:[NSString stringWithFormat:@"/Documents/pic%@.png",self.userModel.userID]];
    UIImage * headimage = [UIImage imageWithContentsOfFile:imagePath];
    if (headimage) {
        _headView.iconImageView.image = headimage;
    } else {
        [WMRequestHelper acquiringAliyunToken:Login_Token withCompletionHandle:^(BOOL success, id dataDic) {
            if (success) {
                if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                    WMAliyunTokenModel * model = [WMAliyunTokenModel modelWithDictionary:[dataDic objectForKey:@"data"]];
                    // 获取个人头像接口
                    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:model.keyId   secretKeyId:model.secret securityToken:model.token];
                    OSSClientConfiguration * conf = [OSSClientConfiguration new];
                    conf.maxRetryCount = 2;
                    conf.timeoutIntervalForRequest = 30;
                    conf.timeoutIntervalForResource = 24 * 60 * 60;
                    client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
                    
                    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
                    request.bucketName = @"chargerbaby-userheadimage";
                    request.xOssProcess = @"image/resize,m_lfit,w_100,h_100";
                    request.objectKey = _userModel.userHeadImage;
                    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
                    };
                    OSSTask * getTask = [client getObject:request];
                    [getTask continueWithBlock:^id(OSSTask *task) {
                        if (!task.error) {
                            NSLog(@"download object success!");
                            OSSGetObjectResult * getResult = task.result;
                            NSString *path_document = NSHomeDirectory();
                            //设置一个图片的存储路径
                            NSString *imagePath = [path_document stringByAppendingString:[NSString stringWithFormat:@"/Documents/pic%@.png",self.userModel.userID]];
                            [getResult.downloadedData writeToFile:imagePath atomically:YES];
                            // 这边回调有点延迟
                            _headView.iconImageView.image = [UIImage imageWithData:getResult.downloadedData];
                            NSLog(@"download result: %@", getResult.downloadedData);
                        } else {
                            NSLog(@"download object failed, error: %@" ,task.error);
                        }
                        return nil;
                    }];
                }
            }
        }];
    }
    
    
    

}
// 初始化参数
- (void)setupSections
{
    //************************************section1
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"共享记录";
    item1.executeCode = ^{
        NSLog(@"共享记录");
        SharedRecordViewController *vc = [[SharedRecordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    item1.img = [UIImage imageNamed:@"SharedRecord"];
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[item1];
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"使用指南";
    item2.img = [UIImage imageNamed:@"GuideToUse"];
    item2.executeCode = ^{
        IntroduceViewController *vc = [[IntroduceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"客服";
    item3.img = [UIImage imageNamed:@"CustomerService"];
    item3.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item3.executeCode = ^() {
      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://10010"]];
    };
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"意见反馈";
    item4.img = [UIImage imageNamed:@"FeedBack"];
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item4.executeCode = ^{
        FeedBackViewController * vc = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
 
    
    XBSettingItemModel *item5 = [[XBSettingItemModel alloc]init];
    item5.funcName = @"更多";
    item5.img = [UIImage imageNamed:@"more"];
    item5.executeCode = ^{
        NSLog(@"更多");
        WMMoreViewController * vc = [[WMMoreViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    item5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 18;
    section2.itemArray = @[item2, item3, item4, item5];
    
    [self.dataArray addObject:section1];
    [self.dataArray addObject:section2];
}

- (void)setTitle:(NSString *)title
{
    UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text             = title;
    titleLabel.font             = [UIFont boldSystemFontOfSize:20.f];
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.textColor        = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark -congfigNav
- (void)congfigNav
{
    self.title = @"个人中心";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"black-back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callback) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, barItem];
    /*******************************************************************************/
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"message-white.png"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(goToMessage) forControlEvents:UIControlEventTouchUpInside];
    messageButton.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *messageNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    messageNagetiveSpacer.width = -10;
    UIBarButtonItem *messageBarItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    self.navigationItem.rightBarButtonItems = @[ messageNagetiveSpacer, messageBarItem];
}

#pragma mark -configBaseUI
- (void)configBaseUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mainTableView.contentInset = UIEdgeInsetsMake(264, 0, 0, 0);
    [self.mainTableView addSubview:self.headView];
    [self.view addSubview:self.mainTableView];
    [self wr_setNavBarBackgroundAlpha: 0];
}


#pragma mark -MineHeadViewDelegate
/** 跳转个人中心详情页 */
- (void)goToMineDetail
{
    WMMineDetailViewController * vc = [[WMMineDetailViewController alloc] init];
    vc.model = _userModel;
    __weak typeof(self) weakself = self;
    vc.returnImageBlock = ^(UIImage *iconImage) {
        weakself.headView.iconImageView.image = iconImage;
    };
    vc.returnUserNameBlock = ^(NSString *name) {
        // 修改存储在本地的个人信息数据
        [WMRequestHelper acquiringInformation:[[AppSettings sharedInstance] stringForKey:@"token"] withCompletionHandle:^(BOOL success, id dataDic) {
            if (success) {
                if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * dic = [dataDic objectForKey:@"data"];
                    WMUserModel * model = [WMUserModel modelWithDictionary:dic];
                    [[AppSettings sharedInstance] loginsaveCache:model];
                    
                    weakself.userModel = model;
                    weakself.headView.model = weakself.userModel;
                }
            }
        }];
    };
    vc.returnUserSex = ^(NSString *sex) {
        // 修改存储在本地的个人信息数据
        [WMRequestHelper acquiringInformation:[[AppSettings sharedInstance] stringForKey:@"token"] withCompletionHandle:^(BOOL success, id dataDic) {
            if (success) {
                if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * dic = [dataDic objectForKey:@"data"];
                    WMUserModel * model = [WMUserModel modelWithDictionary:dic];
                    [[AppSettings sharedInstance] loginsaveCache:model];
                    weakself.userModel = model;
                    weakself.headView.model = weakself.userModel;
                }
            }
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
/** 跳转个人钱包 */
- (void)goToMineWallet
{
    WMMineWalletViewController * vc = [[WMMineWalletViewController alloc] init];
    vc.userModel = _userModel;
    [self.navigationController pushViewController:vc animated:YES];
}
/** 跳转实名认证页 */
- (void)goToAuthenticationController
{
    if ([[NSString stringWithFormat:@"%@", _userModel.userIdentifyStatus] isEqualToString:@"1"]) {
        WMRealNameAuthenticationViewController * realNameVc = [[WMRealNameAuthenticationViewController alloc] init];
        realNameVc.isCertification = YES;
        [self.navigationController pushViewController:realNameVc animated:YES];
        return;
    }
    WMRealNameAuthenticationViewController * realNameVc = [[WMRealNameAuthenticationViewController alloc] init];
    kWeakSelf(self);
    // 认证返回的回调
    realNameVc.block = ^{
        weakself.userModel.userIdentifyStatus = @"1";
        weakself.headView.model = weakself.userModel;

    };
    [self.navigationController pushViewController:realNameVc animated:YES];
}
/** 跳转信用值 */
- (void)goToCreditController
{
    WMCreditValueViewController * creditVc = [[WMCreditValueViewController alloc] init];
    creditVc.model = _userModel;
    [self.navigationController pushViewController:creditVc animated:YES];
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XBSettingSectionModel *sectionModel = self.dataArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    XBSettingSectionModel *sectionModel = self.dataArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (!cell) {
        cell = [[XBSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.item = itemModel;

    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
      return 18;
    } else {
        return 0;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBSettingSectionModel *sectionModel = self.dataArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}

#pragma mark -protectFunction
/** 返回主页 */
- (void)callback
{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 消息页面 */
- (void)goToMessage
{
    WMMessageViewController * messageVC = [[WMMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}


#pragma mark -lazyLoading
- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        [_mainTableView registerClass:[XBSettingCell class] forCellReuseIdentifier:cellID];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.scrollEnabled = YES;
    }
    return _mainTableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (MineHeadView *)headView
{
    if (!_headView) {
        _headView = [[MineHeadView alloc] initWithFrame:CGRectMake(0, -264, SCREEN_WIDTH, 264)];
        _headView.delegate = self;
    }
    return _headView;
}

@end
