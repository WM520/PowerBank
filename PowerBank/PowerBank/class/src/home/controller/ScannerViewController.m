//
//  ScannerViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/3.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "ScannerViewController.h"
 #import "ZFScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScannerViewController ()

@end

@implementation ScannerViewController

#pragma mark -lifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"扫码充电";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callback) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, barItem];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -protected
- (void)callback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)turnTorchOn: (BOOL)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass != nil)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash])
        {
            [device lockForConfiguration:nil];
            if (on && device.torchMode == AVCaptureTorchModeOff)
            {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            }
            if (!on && device.torchMode == AVCaptureTorchModeOn)
            {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}


@end
