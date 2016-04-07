//
//  DHAnimationSettings.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTransitionSettings.h"

@implementation DHTransitionSettings

+ (DHTransitionSettings *) defaultSettings
{
    DHTransitionSettings *settings = [[DHTransitionSettings alloc] init];
    settings.duration = 1.f;
    settings.timingFunction = DHTimingFunctionLinear;
    settings.columnCount = 1;
    settings.rowCount = 1;
    return settings;
}
@end
