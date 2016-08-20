//
//  DHTextAnimationSettings.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextAnimationSettings.h"

@implementation DHTextAnimationSettings

+ (DHTextAnimationSettings *) defaultSettings
{
    DHTextAnimationSettings *settings = [[DHTextAnimationSettings alloc] init];
    settings.duration = 2.f;
    settings.timingFunction = DHTimingFunctionLinear;
    settings.completion = nil;
    settings.attributedText = nil;
    settings.event = DHAnimationEventBuiltIn;
    settings.direction = DHAnimationDirectionLeftToRight;
    settings.origin = CGPointZero;
    settings.containerView = nil;
    settings.textContainerView = nil;
    settings.beforeAnimationAction = nil;
    return settings;
}

+ (DHTextAnimationSettings *) defaultSettingForAnimationType:(DHTextAnimationType)animationType
{
    DHTextAnimationSettings *settings = [DHTextAnimationSettings defaultSettings];
    switch (animationType) {
        case DHTextAnimationTypeOrbital:{
            settings.timingFunction = DHTimingFunctionEaseInOutCubic;
            settings.event = DHAnimationEventBuiltOut;
            break;
        }
        case DHTextAnimationTypeFlyIn:{
            settings.timingFunction = DHTimingFunctionEaseInOutCubic;
            settings.direction = DHAnimationDirectionRightToLeft;
            settings.event = DHAnimationEventBuiltOut;
            break;
        }
        case DHTextAnimationTypeSquish: {
            settings.timingFunction = DHTimingFunctionLinear;
            settings.duration = 5.f;
            break;
        }
        case DHTextAnimationTypeDance: {
            settings.timingFunction = DHTimingFunctionEaseInOutCubic;
            break;
        }
        case DHTextAnimationTypeFade: {
            settings.duration = 3;
            settings.event = DHAnimationEventBuiltOut;
            break;
        }
        case DHTextAnimationTypeTrace: {
            settings.duration = 3.f;
        }
        default:
            break;
    }
    return settings;
}

@end
