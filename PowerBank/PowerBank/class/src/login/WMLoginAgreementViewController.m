//
//  WMLoginAgreementViewController.m
//  PowerBank
//
//  Created by baiju on 2017/8/9.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMLoginAgreementViewController.h"

@interface WMLoginAgreementViewController ()
@property (weak, nonatomic) IBOutlet UITextView *userServiceAgreement;

@end

@implementation WMLoginAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.userServiceAgreement.scrollEnabled = YES;
    self.userServiceAgreement.editable = NO;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
