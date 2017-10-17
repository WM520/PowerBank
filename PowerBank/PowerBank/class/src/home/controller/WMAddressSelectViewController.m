//
//  WMAddressSelectViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/24.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMAddressSelectViewController.h"
#import "WMAdressListTableViewCell.h"
#import <AMapSearchKit/AMapSearchKit.h>

static NSString * cellID = @"adress";

@interface WMAddressSelectViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate,
UISearchControllerDelegate,
AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet UITableView *adressList;
//@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) AMapSearchAPI * search;
@property (assign, nonatomic) BOOL isSearch;
@end

@implementation WMAddressSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _searchBar.delegate = self;
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIColor colorWithHexString:@"#414141"] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setTextColor:[UIColor colorWithHexString:@"#414141"]];
    [_searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    

    _isSearch = NO;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    self.view.backgroundColor = ThemeColor;
    _adressList.backgroundColor = [UIColor whiteColor];
    _adressList.layer.masksToBounds = YES;
    _adressList.layer.cornerRadius = 20;
    _adressList.delegate = self;
    _adressList.dataSource = self;
    _adressList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_adressList registerNib:[UINib nibWithNibName:@"WMAdressListTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    _adressList.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}
- (IBAction)cancle:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMAdressListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (_isSearch) {
        AMapTip * model = self.addressArray[indexPath.row];
        cell.titleName.text =  model.name;
        cell.detailName.text = model.address;
    } else {
        AMapPOI * model = self.addressArray[indexPath.row];
        cell.titleName.text =  model.name;
        cell.detailName.text = model.address;
    }
    return cell;
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@", searchBar.text);
    
    //发起输入提示搜索
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    //关键字
    tipsRequest.keywords = searchBar.text;
    //城市
    tipsRequest.city = @"南京";
    
    //执行搜索
    [_search AMapInputTipsSearch: tipsRequest];
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        [self.addressArray removeAllObjects];
        [self.adressList reloadData];
        return;
    }
    
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    //先清空数组
    [self.addressArray removeAllObjects];
    for (AMapTip *p in response.tips) {
        //把搜索结果存在数组
        [self.addressArray addObject:p];
    }
    [self.adressList reloadData];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMAdressListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(callback:)]) {
        [self.delegate callback:cell.titleName.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}



@end
