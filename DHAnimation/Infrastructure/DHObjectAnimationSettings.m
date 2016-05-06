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
    settings.duration = 1.f;
    settings.event = DHAnimationEventBuiltIn;
    settings.direction = DHAnimationDirectionLeftToRight;
    settings.timingFunction = DHTimingFunctionLinear;
    settings.completion = nil;
    settings.rowCount = 1;
    settings.columnCount = 1;
    return settings;
}

+ (DHObjectAnimationSettings *) defaultSettingsForAnimationType:(DHObjectAnimationType)animationType event:(DHAnimationEvent)event
{
    DHObjectAnimationSettings *settings = [DHObjectAnimationSettings defaultSettings];
    switch (animationType) {
        case DHObjectAnimationTypeScaleBig:
        case DHObjectAnimationTypeRotation:
        case DHObjectAnimationTypeBlinds:
        case DHObjectAnimationTypeTwirl:
        case DHObjectAnimationTypeScale:
        case DHObjectAnimationTypeFlame:
        case DHObjectAnimationTypeSpin:
        case DHObjectAnimationTypeFlip:
        case DHObjectAnimationTypePop: {
            if (event == DHAnimationEventBuiltIn) {
                settings.timingFunction = DHTimingFunctionEaseOutBack;
            } else {
                settings.timingFunction = DHTimingFunctionEaseInBack;
            }
        }
            break;
        case DHObjectAnimationTypeFirework:
        case DHObjectAnimationTypeDissolve:
        case DHObjectAnimationTypeShimmer:
        case DHObjectAnimationTypePivot:
        case DHObjectAnimationTypeSkid:
        case DHObjectAnimationTypeBlur:{
            if (event == DHAnimationEventBuiltIn) {
                settings.timingFunction = DHTimingFunctionEaseOutCubic;
            } else {
                settings.timingFunction = DHTimingFunctionEaseInCubic;
            }
        }
            break;
        case DHObjectAnimationTypeDrop: {
            settings.timingFunction = DHTimingFunctionEaseOutBounce;
        }
            break;
        case DHObjectAnimationTypeNone:
            return nil;
        case DHObjectAnimationTypeAnvil: {
            settings.timingFunction = DHTimingFunctionEaseOutExpo;
        }
        case DHObjectAnimationTypeSparkle: {
            settings.timingFunction = DHTimingFunctionLinear;
        }
            
        case DHObjectAnimationTypeConfetti: {
            if (event == DHAnimationEventBuiltIn) {
                settings.timingFunction = DHTimingFunctionEaseOutCubic;
            } else {
                settings.timingFunction = DHTimingFunctionEaseInCubic;
            }
            settings.columnCount = 30;
            settings.rowCount = 30;
        }
            break;
    }
    return settings;
}

@end
