//
//  WMMessageDetailViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/19.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMMessageDetailViewController.h"

@interface WMMessageDetailViewController ()
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation WMMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息详情";
    self.view.backgroundColor = [UIColor whiteColor];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.h5URL]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -lazy
- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

@end
