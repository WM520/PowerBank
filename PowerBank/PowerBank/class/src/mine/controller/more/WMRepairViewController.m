//
//  WMRepairViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/13.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMRepairViewController.h"
#import <ActionSheetCustomPicker.h>
#import <ActionSheetDatePicker.h>
#import <MJExtension.h>
#import "WMTextView.h"
#import "WMRepairTableViewCell.h"
#import "ZFScanViewController.h"

static NSString * repairCell = @"cell";

@interface WMRepairViewController ()
<ActionSheetCustomPickerDelegate,
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
WMRepairTableViewCellDelegate>

@property (nonatomic,strong) NSArray *addressArr; // 解析出来的最外层数组
@property (nonatomic,strong) NSArray *provinceArr; // 省
@property (nonatomic,strong) NSArray *countryArr; // 市
@property (nonatomic,strong) NSArray *districtArr; // 区
@property (nonatomic,assign) NSInteger index1; // 省下标
@property (nonatomic,assign) NSInteger index2; // 市下标
@property (nonatomic,assign) NSInteger index3; // 区下标
@property (nonatomic,strong) ActionSheetCustomPicker *adressPicker; // 选择器
@property (nonatomic, strong) ActionSheetDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) WMTextView * commitQuestionView;
@property (weak, nonatomic) IBOutlet UITableView *selectedTabelView;
@property (strong, nonatomic) UILabel * addressLabel;
@property (strong, nonatomic) UILabel * timeLabel;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *selectedTime;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (copy, nonatomic) NSString * deviceId;
@property (copy, nonatomic) NSString * provinceString;
@property (copy, nonatomic) NSString * countryString;
@property (copy, nonatomic) NSString * districtString;
@property (copy, nonatomic) NSString * detailAddress;
@property (copy, nonatomic) NSString * selectTimeString;
@property (assign, nonatomic) NSInteger dateType;

@end

@implementation WMRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self calculateFirstData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selected:(id)sender {
    UIButton * button = sender;
    button.selected = !button.selected;
    
}


#pragma mark -initUI
- (void)initUI
{
    self.title = @"报修";
    self.view.backgroundColor = ThemeColor;
    self.selectedTabelView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    (void)self.commitQuestionView;
    _selectedTabelView.delegate = self;
    _selectedTabelView.dataSource = self;
    // _selectedTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // [_selectedTabelView registerClass:[WMRepairTableViewCell class] forCellReuseIdentifier:repairCell];
    _selectedTabelView.scrollEnabled = NO;
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:ThemeBarTextColor forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitQuestion) forControlEvents:UIControlEventTouchUpInside];
    commitButton.frame = CGRectMake(0, 0, 40, 20);
    UIBarButtonItem *commitNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    commitNagetiveSpacer.width = -10;
    UIBarButtonItem *commitBarItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    self.navigationItem.rightBarButtonItems = @[ commitNagetiveSpacer, commitBarItem];
    
    self.commitButton.layer.cornerRadius = 10;
    self.commitButton.clipsToBounds = YES;
}

- (IBAction)pick {
    
    self.adressPicker = [[ActionSheetCustomPicker alloc]initWithTitle:@"选择地区" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(self.index1),@(self.index2),@(self.index3)]];
    self.adressPicker.tapDismissAction  = TapActionSuccess;
    // 可以自定义左边和右边的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithHexString:@"#414141"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitleColor:[UIColor colorWithHexString:@"#414141"] forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 44, 44);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [self.adressPicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:button]];
    [self.adressPicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:button1]];
    [self.adressPicker showActionSheetPicker];
}

- (void)timeSelected
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2000];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate dateWithTimeInterval:24*60*60*30 sinceDate:[NSDate date]];;
    
    _timePicker =  [[ActionSheetDatePicker alloc] initWithTitle:@"选择报修日期" datePickerMode:UIDatePickerModeDate selectedDate: _selectedDate                                                  minimumDate:minDate
                                                    maximumDate:maxDate
                                                         target:self action:@selector(dateWasSelected:element:) origin:self.selectedTabelView];
    
    [_timePicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    _timePicker.hideCancel = YES;
    [_timePicker showActionSheetPicker];

}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    _selectedDate = selectedDate;
    NSIndexPath * path = [NSIndexPath indexPathForRow:2 inSection:0];
    WMRepairTableViewCell * cell = [self.selectedTabelView cellForRowAtIndexPath:path];
    [cell.selectDate setTitle:[[selectedDate description] substringToIndex:10] forState:UIControlStateNormal];
    _selectTimeString = [[selectedDate description] substringToIndex:10];
}


- (void)selectATime
{
    NSInteger minuteInterval = 5;
    //clamp date
    NSInteger referenceTimeInterval = (NSInteger)[self.selectedTime timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceTimeInterval % (minuteInterval *60);
    NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if(remainingSeconds>((minuteInterval*60)/2)) {/// round up
        timeRoundedTo5Minutes = referenceTimeInterval +((minuteInterval*60)-remainingSeconds);
    }
    
    self.selectedTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择保修时间" datePickerMode:UIDatePickerModeTime selectedDate:self.selectedTime target:self action:@selector(timeWasSelected:element:) origin:self.selectedTabelView];
    datePicker.minuteInterval = minuteInterval;
    [datePicker showActionSheetPicker];
}
-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    NSIndexPath * path = [NSIndexPath indexPathForRow:2 inSection:0];
    WMRepairTableViewCell * cell = [self.selectedTabelView cellForRowAtIndexPath:path];
    [cell.selectTime setTitle:[dateFormatter stringFromDate:selectedTime] forState:UIControlStateNormal];
    NSString * count = [[dateFormatter stringFromDate:selectedTime] substringToIndex:2];
    // 默认为0
    _dateType = 0;
    
    if ([count integerValue] > 12) {
        _dateType = 2;
    } else {
        _dateType = 1;
    }
}


#pragma mark -methods
- (void)loadFirstData
{
    // 注意JSON后缀的东西和Plist不同，Plist可以直接通过contentOfFile抓取，Json要先打成字符串，然后用工具转换
    NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
    NSLog(@"%@",path);
    NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    self.addressArr = [jsonStr mj_JSONObject];
    
    NSMutableArray *firstName = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.addressArr)
    {
        NSString *name = dict.allKeys.firstObject;
        [firstName addObject:name];
    }
    // 第一层是省份 分解出整个省份数组
    self.provinceArr = firstName;
}

// 根据传进来的下标数组计算对应的三个数组
- (void)calculateFirstData
{
    _selectedDate = [NSDate date];
    // 拿出省的数组
    [self loadFirstData];
    
    NSMutableArray *cityNameArr = [[NSMutableArray alloc] init];
    // 根据省的index1，默认是0，拿出对应省下面的市
    for (NSDictionary *cityName in [self.addressArr[self.index1] allValues].firstObject) {
        
        NSString *name1 = cityName.allKeys.firstObject;
        [cityNameArr addObject:name1];
    }
    // 组装对应省下面的市
    self.countryArr = cityNameArr;
    //                             index1对应省的字典         市的数组 index2市的字典   对应市的数组
    // 这里的allValue是取出来的大数组，取第0个就是需要的内容
    self.districtArr = [[self.addressArr[self.index1] allValues][0][self.index2] allValues][0];
}

- (IBAction)commitQuestion
{
    NSLog(@"提交服务器");
    [WMRequestHelper warrantyWithUuid:_deviceId question:@"设备故障" provice:_provinceString == nil ? @"" : _provinceString  city:_countryString == nil ? @"" : _countryString town:_districtString == nil ? @"" : _districtString address:_detailAddress == nil ? @"" : _detailAddress date:_selectTimeString == nil ? @"" : _selectTimeString dateType:[NSString stringWithFormat:@"%ld", _dateType] withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                [[PhoneNotification sharedInstance] autoHideWithText:@"报修成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    
}

- (IBAction)scan:(id)sender {
    ZFScanViewController * zfScanVC = [[ZFScanViewController alloc] init];
    zfScanVC.returnScanBarCodeValue = ^(NSString * barCodeString){
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
        _deviceId = decodedString;
    };
    [self.navigationController pushViewController:zfScanVC animated:YES];
}


#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component)
    {
        case 0: return self.provinceArr.count;
        case 1: return self.countryArr.count;
        case 2:return self.districtArr.count;
        default:break;
    }
    return 0;
}

#pragma mark UIPickerViewDelegate Implementation
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0: return self.provinceArr[row];break;
        case 1: return self.countryArr[row];break;
        case 2:return self.districtArr[row];break;
        default:break;
    }
    return nil;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if (!label)
    {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14]];
    }
    
    NSString * title = @"";
    switch (component)
    {
        case 0: title =   self.provinceArr[row];break;
        case 1: title =   self.countryArr[row];break;
        case 2: title =   self.districtArr[row];break;
        default:break;
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.text=title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            self.index1 = row;
            self.index2 = 0;
            self.index3 = 0;
            //            [self calculateData];
            // 滚动的时候都要进行一次数组的刷新
            [self calculateFirstData];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
            
        case 1:
        {
            self.index2 = row;
            self.index3 = 0;
            //            [self calculateData];
            [self calculateFirstData];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
            break;
        case 2:
            self.index3 = row;
            break;
        default:break;
    }
}
- (void)configurePickerView:(UIPickerView *)pickerView
{
    pickerView.showsSelectionIndicator = NO;
}
// 点击done的时候回调
- (void)actionSheetPickerDidSucceed:(ActionSheetCustomPicker *)actionSheetPicker origin:(id)origin
{
    NSMutableString *detailAddress = [[NSMutableString alloc] init];
    if (self.index1 < self.provinceArr.count) {
        NSString *firstAddress = self.provinceArr[self.index1];
        _provinceString = firstAddress;
        [detailAddress appendString:firstAddress];
    }
    if (self.index2 < self.countryArr.count) {
        NSString *secondAddress = self.countryArr[self.index2];
        _countryString = secondAddress;
        [detailAddress appendString:secondAddress];
    }
    if (self.index3 < self.districtArr.count) {
        NSString *thirfAddress = self.districtArr[self.index3];
        _districtString = thirfAddress;
        [detailAddress appendString:thirfAddress];
    }
    NSLog(@"%@", detailAddress);
    _addressLabel.text = detailAddress;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section, (long)indexPath.row];
    WMRepairTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WMRepairTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (!_addressLabel) {
            WMRepairTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            _addressLabel = cell.selectedMessage;
        }
        [self pick];
    }
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, -150,self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark -WMRepairTableViewCellDelegate
- (void)keyBoradDidHide:(UITextField *)textField
{
    _detailAddress = textField.text;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)keyBoradDidShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, -200,self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)selectDate:(WMRepairTableViewCell *)cell
{
    [self timeSelected];
}
- (void)selectTime:(WMRepairTableViewCell *)cell
{
    [self selectATime];
}


#pragma mark -lazy
- (NSArray *)provinceArr
{
    if (_provinceArr == nil) {
        _provinceArr = [[NSArray alloc] init];
    }
    return _provinceArr;
}
-(NSArray *)countryArr
{
    if(_countryArr == nil)
    {
        _countryArr = [[NSArray alloc] init];
    }
    return _countryArr;
}

- (NSArray *)districtArr
{
    if (_districtArr == nil) {
        _districtArr = [[NSArray alloc] init];
    }
    return _districtArr;
}

-(NSArray *)addressArr
{
    if (_addressArr == nil) {
        _addressArr = [[NSArray alloc] init];
    }
    return _addressArr;
}
- (WMTextView *)commitQuestionView
{
    if (!_commitQuestionView) {
        WMTextView *customTextView = [[WMTextView alloc] init];
        customTextView.delegate = self;
        customTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.questionView.height);
        customTextView.placehoder = @"  请输入详细问题";
        customTextView.isHiddenCountLabel = YES;
        customTextView.placehoderColor = [UIColor colorWithHexString:@"#414141"];
        [self.questionView addSubview:customTextView];
        _commitQuestionView = customTextView;
    }
    return _commitQuestionView;
}


@end
