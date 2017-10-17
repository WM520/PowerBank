//
//  PromptView.h
//  CloudMall
//
//  Created by YQ on 16/10/26.
//  Copyright © 2016年 DongHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromptView : NSObject

+ (void)autoHideWithText:(NSString *)string;
+ (void)autoHide;
+ (void)hide;

@end
