//
//  PromptView.m
//  CloudMall
//
//  Created by YQ on 16/10/26.
//  Copyright © 2016年 DongHui. All rights reserved.
//

#import "PromptView.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@implementation PromptView

MBProgressHUD *HUD = nil;

+ (void)autoHideWithText:(NSString *)string{
    UIViewController *vc = [Utils CurrentViewController];
    MBProgressHUD *textHUD = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    textHUD.mode = MBProgressHUDModeText;
    textHUD.label.text = string;
    textHUD.removeFromSuperViewOnHide = YES;
    [textHUD hideAnimated:YES afterDelay:1];
}

+ (void)autoHide{
    if (HUD) {
        [HUD hideAnimated:NO];
        HUD = nil;
    }
    UIViewController *vc = [Utils CurrentViewController];
    HUD = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = YES;
    [HUD hideAnimated:YES afterDelay:60];
}
+ (void)hide{
    if (HUD) {
        [HUD hideAnimated:YES];
    }
}

@end
