//
//  WMModifySexViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMModifySexViewController.h"


static NSString * cellID = @"cell";
@interface WMModifySexViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation WMModifySexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
- (void)initUI
{
    self.title = @"性别";
    self.view.backgroundColor = ThemeColor;
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"保存" forState:UIControlStateNormal];
    [commitButton setTitleColor:ThemeBarTextColor forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commitButton.frame = CGRectMake(0, 0, 40, 20);
    UIBarButtonItem *commitNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    commitNagetiveSpacer.width = -10;
    UIBarButtonItem *commitBarItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    self.navigationItem.rightBarButtonItems = @[ commitNagetiveSpacer, commitBarItem];
    _mainTableView.scrollEnabled = NO;
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (void)commit
{
    NSString * sexString = nil;
    if (_selectedIndex == 0) {
        sexString = @"M";
    } else if (_selectedIndex == 1) {
        sexString = @"F";
    }
    
    [WMRequestHelper modificationUserValue:sexString key:@"sex" withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([self.delegate respondsToSelector:@selector(userSexModify:)]) {
                [self.delegate userSexModify:_selectedIndex];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.tintColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"男";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"女";
    }
    if (_selectedIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [_mainTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
