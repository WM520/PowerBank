//
//  WMMoreViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/13.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMMoreViewController.h"
#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import "WMRepairViewController.h"
#import "WMComplaintViewController.h"
#import "WMUserAgreementViewController.h"
#import "WMAboutMineViewController.h"
#import "LoginViewController.h"
#import "WMRechargeListViewController.h"

static NSString *cellID = @"minecell";

@interface WMMoreViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton * quitButton;

@end

@implementation WMMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSections];
    [self initUI];
}



- (void)initUI
{
    (void)self.mainTableView;
    self.title = @"更多";
    _quitButton = [[UIButton alloc] init];
    _quitButton.layer.cornerRadius = 10;
    _quitButton.clipsToBounds = YES;
    [_quitButton setTitle:@"退出" forState:UIControlStateNormal];
    [_quitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_quitButton setBackgroundColor:[UIColor blackColor]];
    [_quitButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_quitButton];
    _quitButton.sd_layout
    .bottomSpaceToView(self.view, 40)
    .heightIs(35)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20);
}

- (void)setupSections
{
    //************************************section1
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"申诉";
    item1.executeCode = ^{
        NSLog(@"申诉");
        WMComplaintViewController * vc = [[WMComplaintViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"报修";
    item2.detailText = @"处理中";
    item2.executeCode = ^{
        WMRepairViewController * vc = [[WMRepairViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item6 = [[XBSettingItemModel alloc]init];
    item6.funcName = @"充电记录";
    item6.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item6.executeCode = ^{
        WMRechargeListViewController * vc = [[WMRechargeListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"检查更新";
    // item3.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item3.detailText = @"已是最新版本";
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"用户服务协议";
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item4.executeCode = ^{
        WMUserAgreementViewController * vc = [[WMUserAgreementViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    XBSettingItemModel *item5 = [[XBSettingItemModel alloc]init];
    item5.funcName = @"关于我们";
    item5.executeCode = ^{
        NSLog(@"关于我们");
        WMAboutMineViewController * vc = [[WMAboutMineViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    item5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[item1, item2, item6, item3, item4, item5];
    [self.dataArray addObject:section1];
}



#pragma mark -UITableViewDataSource
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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

#pragma mark -methods
- (void)quit
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSLog(@"退出登录");
    [[AppSettings sharedInstance] removeObjectForKey:@"login"];
    [[AppSettings sharedInstance] setString:@"" forKey:@"token"];
    NSString * pathLogin = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/data.login"];
    NSString * pathAliyun = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/data.alikey"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:pathLogin];
    if (!blHave) {
        NSLog(@"no  have");
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:pathLogin error:nil];
        [fileManager removeItemAtPath:pathAliyun error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"exit" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -lazy
- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        [mainTableView registerClass:[XBSettingCell class] forCellReuseIdentifier:cellID];
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mainTableView.dataSource = self;
        mainTableView.delegate = self;
        [self.view addSubview:mainTableView];
        _mainTableView = mainTableView;
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



@end
