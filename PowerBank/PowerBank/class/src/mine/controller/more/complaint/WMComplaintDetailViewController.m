//
//  WMComplaintDetailViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMComplaintDetailViewController.h"
#import "WMTextView.h"

@interface WMComplaintDetailViewController ()
<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (strong, nonatomic) WMTextView * customTextView;

@end

@implementation WMComplaintDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = ThemeColor;
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    self.title = @"申诉";
    WMTextView *customTextView = [[WMTextView alloc] init];
    customTextView.delegate = self;
    customTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _textView.height);
    customTextView.isHiddenCountLabel = NO;
    customTextView.placehoder = @"申诉原因";
    customTextView.placehoderColor = [UIColor colorWithHexString:@"#414141"];
    [_textView addSubview:customTextView];
    _commitButton.clipsToBounds = YES;
    _commitButton.layer.cornerRadius = 15;
    if (SCREEN_WIDTH == 320) {
//        _orderHeight.constant = 120;
        _textViewHeight.constant = 120;
    }
    _customTextView = customTextView;
}



#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, -200,self.view.frame.size.width, self.view.frame.size.height);
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

@end
