//
//  WMMineDetailViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMMineDetailViewController.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import "XBSettingCell.h"
#import <TZImagePickerController.h>
#import "ImagePicker.h"
#import "WMModifyNameViewController.h"
#import "WMModifySexViewController.h"
#import "WMUserModel.h"

static NSString *cellID = @"minecell";

@interface WMMineDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource,
TZImagePickerControllerDelegate,
WMModifyNameViewControllerDelegate,
WMModifySexViewControllerDelegate>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImage * userHeadImage;
@property (nonatomic, strong) XBSettingItemModel * item1;
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) ImagePicker *imagePicker;
@property (nonatomic, strong) UIButton * userHeadButton;

@end

@implementation WMMineDetailViewController

#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"个人信息";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -methods
- (void)initUI
{
    (void)self.mainTableView;
    
}

- (void)initData
{
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"用户名";
    item1.executeCode = ^{
        WMModifyNameViewController * vc = [[WMModifyNameViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    };
    item1.detailText = _model.userNickName;
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"性别";
//    item2.detailText = _model.userSex == @"UN" ? ;
    if ([_model.userSex isEqualToString:@"UN"]) {
        item2.detailText = @"未知";
    } else if ([_model.userSex isEqualToString:@"M"]) {
        item2.detailText = @"男";
    } else if ([_model.userSex isEqualToString:@"F"]) {
        item2.detailText = @"女";
    }
    item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item2.executeCode = ^{
        WMModifySexViewController * vc = [[WMModifySexViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"手机号";
    item3.detailText = _model.userMobilephone;
    
    
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[item1, item2, item3];
    
    [self.dataArray addObject:section1];
    _mainTableView.tableHeaderView = self.headView;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld", indexPath.row);
    XBSettingSectionModel *sectionModel = self.dataArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}

#pragma mark -TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    
    [_userHeadButton setBackgroundImage:photos.firstObject forState:UIControlStateNormal];
}

#pragma mark - WMModifyNameViewControllerDelegate
- (void)userNameModify:(NSString *)userName
{
    XBSettingSectionModel *sectionModel = self.dataArray[0];
    XBSettingItemModel *itemModel = sectionModel.itemArray[0];
    itemModel.detailText = userName;
    if (self.returnUserNameBlock) {
        self.returnUserNameBlock(userName);
    }
    [_mainTableView reloadData];
}
#pragma mark -WMModifySexViewControllerDelegate
- (void)userSexModify:(NSInteger)index
{
    XBSettingSectionModel *sectionModel = self.dataArray[0];
    XBSettingItemModel *itemModel = sectionModel.itemArray[1];
    if (index == 0) {
        itemModel.detailText = @"男";
    } else if (index == 1) {
        itemModel.detailText = @"女";
    }
    if (self.returnUserSex) {
        self.returnUserSex(itemModel.detailText);
    }
    
    [_mainTableView reloadData];
}

#pragma mark -methods
- (void)selectedImage
{
    _imagePicker = [ImagePicker sharedManager];
    __weak typeof(self) weakself = self;
     [_imagePicker dwSetPresentDelegateVC:self SheetShowInView:self.view InfoDictionaryKeys:(long)nil];
    //回调
    [_imagePicker dwGetpickerTypeStr:^(NSString *pickerTypeStr) {
        
        NSLog(@"%@",pickerTypeStr);
        
    } pickerImagePic:^(UIImage *pickerImagePic) {
        // 改变个人中心头像
        weakself.returnImageBlock(pickerImagePic);
        [_userHeadButton setBackgroundImage:pickerImagePic forState:UIControlStateNormal];
        [WMRequestHelper modifacationUserHeadImage:pickerImagePic withCompletionHandle:^(BOOL success, id dataDic) {
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                [[PhoneNotification sharedInstance] autoHideWithText:@"修改成功"];
            }
        }];
    }];
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

- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
        UILabel * label = [[UILabel alloc] init];
        label.text = @"头像";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGBA(51, 51, 51, 1);
        [_headView addSubview:label];
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedImage)];
        [_headView addGestureRecognizer:tapGesturRecognizer];
    
        UIButton * userHeadButton = [[UIButton alloc] init];
        userHeadButton.clipsToBounds = YES;
        userHeadButton.layer.cornerRadius = 25;
        NSString *path_document = NSHomeDirectory();
        NSString *imagePath = [path_document stringByAppendingString:[NSString stringWithFormat:@"/Documents/pic%@.png",self.model.userID]];
        [userHeadButton setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] == nil ? [UIImage imageNamed:@"iconuser"] : [UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
//        [userHeadButton addTarget:self action:@selector(selectedImage) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:userHeadButton];
        _userHeadButton = userHeadButton;
        
        UIImageView * indicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightlink"]];
        [_headView addSubview:indicator];
        
        UILabel * partLine = [[UILabel alloc] init];
        partLine.backgroundColor = RGB(234, 234, 234);
        [_headView addSubview:partLine];
        
        label.sd_layout
        .leftSpaceToView(_headView, 15)
        .topSpaceToView(_headView, 10)
        .bottomSpaceToView(_headView, 10)
        .widthIs(100);
        
        userHeadButton.sd_layout
        .rightSpaceToView(_headView, 40)
        .centerYEqualToView(_headView)
        .widthIs(50)
        .heightIs(50);
        
        indicator.sd_layout
        .rightSpaceToView(_headView, 15)
        .centerYEqualToView(_headView)
        .widthIs(indicator.width)
        .heightIs(indicator.height);
        
        partLine.sd_layout
        .rightEqualToView(_headView)
        .leftEqualToView(_headView)
        .bottomEqualToView(_headView)
        .heightIs(1);
    }
    return _headView;
}


@end
