//
//  IntroduceViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/12.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "IntroduceViewController.h"
#import "SharedRecordTableViewCell.h"
#import "WMGuideTableViewCell.h"
#import "WMGuideModel.h"
static NSString *cellId = @"guidecell";

@interface IntroduceViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    (void)self.mainTableView;
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"使用指南";
}

- (void)initData
{
    NSArray * questions = @[@"OOL是什么？",@"OOL哪里可以下载？",@"OOL首次使用有哪些条件？",@"OOL服务需要注册吗",@"OOL首次使用还需要支付充电费用吗?", @"OOL服务可以带走使用吗？", @"OOL报修问题？有损坏怎么维修？", @"OOL特殊场所服务指南？"];
    NSArray * answers = @[@"OOL是一款基于位置的充电宝共享服务，能够让用户通通过发送需求，找到附近的充电宝，给手机充电。", @"可以在应用市场下载，目前支持苹果手机用户和安卓用户下载。", @"当首次下载使用OOL时，可以浏览OOL的地图功能，查看附近是否有立柜机，通过扫码领取后，即可正常使用充电服务。", @"OOL用户通过手机验证码，免密登录。", @"OOL目前暂不需支付押金和充电费用。", @"OOL的全线产品支持带走使用，只要在正常使用并爱护即可。", @"OOL用户发现有损坏的情况，可在APP上进行报修，本公司对损坏的充电宝进行维修。", @"机场、高铁设立的OOL服务网点，因特殊性，无法进入安检区域，请谨慎携带。"];
    for (int i = 0; i < questions.count; i++) {
        WMGuideModel * model = [[WMGuideModel alloc] init];
        model.question = questions[i];
        model.answer = answers[i];
        [self.dataArray addObject:model];
    }
    [self.mainTableView reloadData];
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMGuideTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 100;
    WMGuideModel *model = self.dataArray[indexPath.row];
    Class currentClass = [WMGuideTableViewCell class];
    NSLog(@"%f", [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]]);
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -lazy
- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mainTableView.backgroundColor = ThemeColor;
        [mainTableView registerClass:[WMGuideTableViewCell class] forCellReuseIdentifier:cellId];
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
