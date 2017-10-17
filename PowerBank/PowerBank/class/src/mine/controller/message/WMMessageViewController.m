//
//  WMMessageViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMMessageViewController.h"
#import "HotCell.h"
#import "HotNoImageCell.h"
#import "WMMessageModel.h"
#import "WMMessageDetailViewController.h"

static NSString *cellID = @"cell";
static NSString *cellNoImageID = @"cellNoImage";

@interface WMMessageViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic,strong) UITableView * mainTableView;
@property (nonatomic, strong) NSMutableArray<WMMessageModel *> *dataArray;

@end

@implementation WMMessageViewController

#pragma mark -lifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -methods
- (void)initUI
{
    self.title = @"消息";
    [self.view addSubview:self.mainTableView];
}
- (void)loadData
{
    for (int i = 0; i < 5; i++) {
        WMMessageModel * model = [[WMMessageModel alloc] init];
        model.name = @"青枝oof青枝oof青枝oof青枝oof";
        model.time = @"2017-07-09 19:59";
        model.info = @"你好青枝oof青枝oof青枝oof青枝oof青枝oof青枝oof青枝oof青枝oof青枝oof青枝oof青枝oof青枝oof";
        model.h5url = @"https://www.baidu.com";
        if (i % 2 == 0) {
            model.bannerimg = @"";
        } else {
            model.bannerimg = @"http://upload-images.jianshu.io/upload_images/1636509-5541ecf8c4e8078c.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
        }
        
        [self.dataArray addObject:model];
    }
//    [WMRequestHelper userMessageListWithList:@"10" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
//        if (success) {
//            // 后期定义字段
//        }
//    }];
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageModel *model = self.dataArray[indexPath.section];
    if (!([model.bannerimg isEqual:[NSNull null]] || [model.bannerimg isEqualToString:@""])) {
        HotCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.model = model;
        return cell;
    } else {
        HotNoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNoImageID];
        cell.model = model;
        return cell;
    }
    return nil;
}
#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageModel *model = self.dataArray[indexPath.section];
    if (!([model.bannerimg isEqual:[NSNull null]] || [model.bannerimg isEqualToString:@""])) {
        Class currentClass = [HotCell class];
        return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    } else {
        Class currentClass = [HotNoImageCell class];
        return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageDetailViewController * vc = [[WMMessageDetailViewController alloc] init];
    WMMessageModel *model = self.dataArray[indexPath.section];
    vc.h5URL = model.h5url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#414141"];
    WMMessageModel * model = self.dataArray[section];
    label.text = [model.time substringWithRange:NSMakeRange(0, 10)];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark setter and getter
- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = ThemeColor;
        [_mainTableView registerClass:[HotCell class] forCellReuseIdentifier:cellID];
        [_mainTableView registerClass:[HotNoImageCell class] forCellReuseIdentifier:cellNoImageID];
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
