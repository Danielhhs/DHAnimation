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
    settings.timingFunction = DHTimingFunctionLinear;
    settings.completion = nil;
    settings.rowCount = 1;
    settings.columnCount = 1;
    return settings;
}

@end
