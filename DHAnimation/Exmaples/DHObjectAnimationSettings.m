//
//  DHObjectAnimationSettings.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationSettings.h"

@implementation DHObjectAnimationSettings

+ (DHObjectAnimationSettings *)defaultSettings
{
    DHObjectAnimationSettings *settings = [[DHObjectAnimationSettings alloc] init];
    settings.duration = 2.f;
    settings.event = AnimationEventBuiltIn;
    settings.direction = AnimationDirectionLeftToRight;
    settings.timingFunction = NSBKeyframeAnimationFunctionLinear;
    settings.completion = nil;
    return settings;
}

@end