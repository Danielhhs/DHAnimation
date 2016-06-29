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

+ (DHTransitionSettings *) defaultSettingsForTransitionType:(DHTransitionType)transitionType
{
    DHTransitionSettings *settings = [DHTransitionSettings defaultSettings];
    switch (transitionType) {
        case DHTransitionTypeCube: {
            settings.timingFunction = DHTimingFunctionEaseInOutBack;
            settings.allowedDirections = [DHTransitionSettings allowedDirectionAll];
        }
            break;
        case DHTransitionTypeDrop: {
            settings.timingFunction = DHTimingFunctionEaseOutBounce;
            settings.allowedDirections = @[@(DHAnimationDirectionTopToBottom)];
        }
            break;
        case DHTransitionTypeFlip: {
            settings.timingFunction = DHTimingFunctionEaseInOutBack;
            settings.allowedDirections = [DHTransitionSettings allowedDirectionHorizontal];
        }
            break;
        case DHTransitionTypeFlop: {
            settings.timingFunction = DHTimingFunctionLinear;
        }
            break;
        case DHTransitionTypeReflection:
        case DHTransitionTypePush:
        case DHTransitionTypeReveal:
        case DHTransitionTypeGrid: {
            settings.allowedDirections = [DHTransitionSettings allowedDirectionHorizontal];
        }
            break;
        case DHTransitionTypeClothLine: {
            settings.duration = 3;
            settings.allowedDirections = @[@(DHAnimationDirectionTopToBottom)];
        }
            break;
        case DHTransitionTypeRipple:
        case DHTransitionTypeMosaic:
        case DHTransitionTypeSwitch:
        case DHTransitionTypeCover: {
            settings.allowedDirections = @[@(DHAnimationDirectionTopToBottom)];
        }
            break;
        case DHTransitionTypeResolvingDoor: {
            settings.timingFunction = DHTimingFunctionEaseInOutBack;
            settings.allowedDirections = @[@(DHAnimationDirectionTopToBottom)];
        }
        case DHTransitionTypeTwist: {
            settings.allowedDirections = [DHTransitionSettings allowedDirectionAll];
        }
            break;
        case DHTransitionTypeConfetti:{
            settings.timingFunction = DHTimingFunctionEaseOutExpo;
            settings.duration = 2.f;
            settings.allowedDirections = @[@(DHAnimationDirectionTopToBottom)];
        }
            break;
        case DHTransitionTypeDoorWay: {
            settings.timingFunction = DHTimingFunctionEaseOutCubic;
            settings.allowedDirections = @[@(DHAnimationDirectionTopToBottom)];
        }
            break;
        case DHTransitionTypeShredder: {
            settings.columnCount = 12;
        }
        default:
            break;
    }
    return settings;
}

+ (NSArray *) allowedDirectionHorizontal
{
    return @[@(DHAnimationDirectionLeftToRight), @(DHAnimationDirectionRightToLeft)];
}

+ (NSArray *) allowedDirectionVertical
{
    return @[@(DHAnimationDirectionTopToBottom), @(DHAnimationDirectionBottomToTop)];
}

+ (NSArray *) allowedDirectionAll
{
    return @[@(DHAnimationDirectionLeftToRight), @(DHAnimationDirectionRightToLeft), @(DHAnimationDirectionTopToBottom), @(DHAnimationDirectionBottomToTop)];
}
@end
