//
//  WMAboutMineViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMAboutMineViewController.h"

@interface WMAboutMineViewController ()
@property (weak, nonatomic) IBOutlet UILabel *viesonLable;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;

@end

@implementation WMAboutMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于我们";
    
    self.lable1.text = @"手机急需电源找OOL";
    self.lable2.text = @"       OOL所有权隶属南京白驹文化传播有限公司，是一款已解决用户及时充电需求的共享型充电宝。";
    self.lable3.text = @"       OOL适配多种机型，输出过压、过流保护、电池过充、过放保护，采用最先进的电压、电流、容量管理方案，实时监控电池容量变化。方便用户在共享过程中更安全，更实用。";
    if (SCREEN_WIDTH == 414) {
        self.lable1.font = [UIFont systemFontOfSize:21];
        self.lable2.font = [UIFont systemFontOfSize:21];
        self.lable3.font = [UIFont systemFontOfSize:21];
        
    }else if (SCREEN_WIDTH == 375){
    
        self.lable1.font = [UIFont systemFontOfSize:18];
        self.lable2.font = [UIFont systemFontOfSize:18];
        self.lable3.font = [UIFont systemFontOfSize:18];
    }else{
    
        self.lable1.font = [UIFont systemFontOfSize:15];
        self.lable2.font = [UIFont systemFontOfSize:15];
        self.lable3.font = [UIFont systemFontOfSize:15];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
