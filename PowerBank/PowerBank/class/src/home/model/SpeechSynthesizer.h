//
//  SpeechSynthesizer.h
//  PowerBank
//
//  Created by foreverlove on 2017/8/2.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SpeechSynthesizer : NSObject

+ (instancetype)sharedSpeechSynthesizer;

- (void)speakString:(NSString *)string;

- (void)stopSpeak;

@end
