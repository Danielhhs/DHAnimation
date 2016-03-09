//
//  DHAnimationSettings.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationSettings.h"

@implementation DHAnimationSettings

+ (DHAnimationSettings *) defaultSettings
{
    DHAnimationSettings *settings = [[DHAnimationSettings alloc] init];
    settings.duration = 1.f;
    settings.timingFunction = DHTimingFunctionEaseInOutCubic;
    return settings;
}
@end
