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
    settings.beforeAnimation = nil;
    settings.rowCount = 1;
    settings.columnCount = 1;
    return settings;
}

+ (DHObjectAnimationSettings *) defaultSettingsForAnimationType:(DHObjectAnimationType)animationType event:(DHAnimationEvent)event forView:(UIView *)view
{
    DHObjectAnimationSettings *settings = [DHObjectAnimationSettings defaultSettings];
    settings.targetView = view;
        switch (animationType) {
            case DHObjectAnimationTypeShimmer: {
                settings.rowCount = 15;
                settings.columnCount = 10;
            }
                break;
            case DHObjectAnimationTypeRotation:{
                settings.duration = 1.f;
                settings.timingFunction = DHTimingFunctionEaseInOutBack;
            }
                break;
            case DHObjectAnimationTypeConfetti: {
                settings.duration = 1.5;
                settings.columnCount = settings.targetView.frame.size.width / 10;
                settings.rowCount = settings.columnCount * settings.targetView.frame.size.width / settings.targetView.frame.size.height;
                settings.timingFunction = DHTimingFunctionEaseOutCubic;
            }
                break;
            case DHObjectAnimationTypeBlinds: {
                settings.columnCount = 5;
                settings.rowCount = 1;
                if (event == DHAnimationEventBuiltIn) {
                    settings.timingFunction = DHTimingFunctionEaseOutBack;
                } else {
                    settings.timingFunction = DHTimingFunctionEaseInBack;
                }
            }
                break;
            case DHObjectAnimationTypeFirework: {
                settings.duration = 5.f;
            }
                break;
            case DHObjectAnimationTypeDiffuse: {
                settings.duration = 3.5;
            }
                break;
            case DHObjectAnimationTypeDrop: {
                settings.timingFunction = DHTimingFunctionEaseOutBounce;
            }
                break;
            case DHObjectAnimationTypePivot: {
                settings.duration = 1.f;
                settings.timingFunction = DHTimingFunctionEaseOutCubic;
            }
                break;
            case DHObjectAnimationTypePop: {
                settings.timingFunction = DHTimingFunctionEaseOutBounce;
            }
                break;
            case DHObjectAnimationTypeScale: {
                settings.timingFunction = DHTimingFunctionEaseOutBack;
            }
                break;
            case DHObjectAnimationTypeScaleBig: {
                settings.timingFunction = DHTimingFunctionEaseOutBack;
            }
                break;
            case DHObjectAnimationTypeSpin: {
                settings.timingFunction = DHTimingFunctionEaseInOutBack;
            }
                break;
            case DHObjectAnimationTypeTwirl: {
                settings.timingFunction = DHTimingFunctionEaseInOutCubic;
            }
                break;
            case DHObjectAnimationTypeSparkle:
            case DHObjectAnimationTypeBlur:
            case DHObjectAnimationTypeDissolve:
            case DHObjectAnimationTypeSkid:
            case DHOBjectAnimationTypeWipe:
            case DHObjectAnimationTypeCrumble: {
            }
                break;
            case DHObjectAnimationTypeFlame: {
                settings.timingFunction = DHTimingFunctionEaseOutCubic;
            }
                break;
            case DHObjectAnimationTypeAnvil: {
                settings.timingFunction = DHTimingFunctionEaseOutExpo;
            }
                break;
            case DHObjectAnimationTypeFaceExplosion: {
                settings.timingFunction = DHTimingFunctionEaseOutCubic;
            }
                break;
            case DHObjectAnimationTypeCompress: {
                settings.timingFunction = DHTimingFunctionEaseOutCubic;
            }
            break;
            case DHObjectAnimationTypePointExplosion: {
                settings.timingFunction = DHTimingFunctionEaseOutCubic;
            }
            break;
            case DHObjectAnimationTypeShredder: {
                settings.columnCount = 7;
            }
            break;
            case DHObjectAnimationTypeFold: {
                settings.columnCount = 3;
                settings.rowCount = 3;
            }
            break;
            default:
                break;
        }
    return settings;
}

+ (NSArray *) allowedDirectionsForAnimation:(DHObjectAnimationType)animation
{
    switch (animation) {
        case DHObjectAnimationTypePop:
        case DHObjectAnimationTypeBlur:
        case DHObjectAnimationTypeSpin:
        case DHObjectAnimationTypeScale:
        case DHObjectAnimationTypeTwirl:
        case DHObjectAnimationTypeShimmer:
        case DHObjectAnimationTypeFlame:
        case DHObjectAnimationTypeConfetti:
        case DHObjectAnimationTypeDissolve:
        case DHObjectAnimationTypeFirework:
        case DHObjectAnimationTypeScaleBig:
        case DHObjectAnimationTypeFaceExplosion:
        case DHObjectAnimationTypeNone:
            return nil;
        case DHObjectAnimationTypeDrop:
        case DHObjectAnimationTypeAnvil:
            return @[@(DHAnimationDirectionTopToBottom)];
        case DHObjectAnimationTypeSkid:
        case DHObjectAnimationTypeRotation:
        case DHObjectAnimationTypeSparkle:
            return [DHObjectAnimationSettings allowedDirectionHorizontal];
        case DHObjectAnimationTypePivot:
        case DHObjectAnimationTypeBlinds:
            return [DHObjectAnimationSettings allowedDirectionAll];
        default:
            break;
    }
    return nil;
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
