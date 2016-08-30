//
//  Enums.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHConstants.h"
#import "DHShimmerAnimationRenderer.h"
#import "DHSparkleAnimationRenderer.h"
#import "DHRotationAnimationRenderer.h"
#import "DHConfettiAnimationRenderer.h"
#import "DHBlindsAnimationRenderer.h"
#import "DHFireworkAnimationRenderer.h"
#import "DHBlurAnimationRenderer.h"
#import "DHDropAnimationRenderer.h"
#import "DHPivotAnimationRenderer.h"
#import "DHPopAnimationRenderer.h"
#import "DHScaleAnimationRenderer.h"
#import "DHScaleBigAnimationRenderer.h"
#import "DHSpinAnimationRenderer.h"
#import "DHTwirlAnimationRenderer.h"
#import "DHDissolveAnimationRenderer.h"
#import "DHSkidAnimationRenderer.h"
#import "DHFlameAnimationRenderer.h"
#import "DHAnvilAnimationRenderer.h"
#import "DHFaceExplosionAnimationRenderer.h"
#import "DHCompressAnimationRenderer.h"
#import "DHPointExplosionAnimationRenderer.h"
#import "DHWipeAnimationRenderer.h"
#import "DHDiffuseAnimationRenderer.h"
#import "DHBlowAnimationRenderer.h"
#import "DHShredderAnimationRenderer.h"
#import "DHFoldAnimationRenderer.h"
#import "DHCrumbleAnimationRenderer.h"

#import "DHDoorWayTransitionRenderer.h"
#import "DHCubeTransitionRenderer.h"
#import "DHTwistTransitionRenderer.h"
#import "DHClothLineTransitionRenderer.h"
#import "DHSwitchTransitionRenderer.h"
#import "DHGridTransitionRenderer.h"
#import "DHConfettiTransitionRenderer.h"
#import "DHPushTransitionRenderer.h"
#import "DHRevealTransitionRenderer.h"
#import "DHDropTransitionRenderer.h"
#import "DHMosaicTransitionRenderer.h"
#import "DHFlopTransitionRenderer.h"
#import "DHCoverTransitionRenderer.h"
#import "DHFlipTransitionRenderer.h"
#import "DHReflectionTransitionRenderer.h"
#import "DHSpinDismissTransitionRenderer.h"
#import "DHRippleTransitionRenderer.h"
#import "DHResolvingDoorTransitionRenderer.h"
#import "DHPageCurlTransitionRenderer.h"

#import "DHTextOrbitalAnimationRenderer.h"
#import "DHTextFlyInAnimationRenderer.h"
#import "DHTextSquishAnimationRenderer.h"
#import "DHTextDanceAnimationRenderer.h"
#import "DHTextFadeAnimationRenderer.h"
#import "DHTextTraceAnimationRenderer.h"

static NSArray *transitionsArray;
static NSArray *builtInAnimationsArray;
static NSArray *builtOutAnimationsArray;
static NSArray *allAnimationsArray;
static NSArray *textAnimationArray;

@implementation DHConstants

+ (NSArray *) transitions
{
    if (transitionsArray == nil) {
        transitionsArray = @[@"DoorWay", @"Cube", @"Twist", @"Cloth Line", @"Shredder", @"Switch", @"Grid", @"Confetti", @"Push", @"Reveal", @"Drop", @"Mosaic", @"Flop", @"Cover", @"Flip", @"Reflection", @"Rotate Dismiss", @"Ripple", @"Resolving Door", @"Page Curl"];
    }
    return transitionsArray;
}

+ (NSArray *) builtInAnimations
{
    if (builtInAnimationsArray == nil) {
        builtInAnimationsArray = @[@"Shimmer", @"Sparkle", @"Rotation", @"Confetti", @"Blinds", @"Firework", @"Blur", @"Drop", @"Pivot", @"Pop", @"Scale", @"Scale Big", @"Spin", @"Twirl", @"Dissolve", @"Skid", @"Flame", @"Anvil", @"Point Explosion", @"Fold"];
    }
    return builtInAnimationsArray;
}

+ (NSArray *) builtOutAnimations
{
    if (builtOutAnimationsArray == nil) {
        builtOutAnimationsArray = @[@"Shimmer", @"Sparkle", @"Rotation", @"Confetti", @"Blinds", @"Blur", @"Pivot", @"Pop", @"Scale", @"Scale Big", @"Spin", @"Twirl", @"Dissolve", @"Face Explosion", @"Compress", @"Skid", @"Wipe", @"Diffuse", @"Blow", @"Shredder", @"Fold"];
    }
    return builtOutAnimationsArray;
}

+ (NSArray *) allAnimations
{
    if (allAnimationsArray == nil) {
        allAnimationsArray = @[@"Shimmer", @"Sparkle", @"Rotation", @"Confetti", @"Blinds", @"Firework", @"Blur", @"Drop", @"Pivot", @"Pop", @"Scale", @"Scale Big", @"Spin", @"Twirl", @"Dissolve", @"Skid", @"Flame", @"Anvil", @"Face Explosion", @"Compress", @"Point Explosion", @"Wipe", @"Diffuse", @"Blow", @"Shredder", @"Fold", @"Crumble"];
    }
    return allAnimationsArray;
}

+ (NSArray *) textAnimations
{
    if (textAnimationArray == nil) {
        textAnimationArray = @[@"Orbital", @"Fly In", @"Squish", @"Dance", @"Fade", @"Trace"];
    }
    return textAnimationArray;
}

+ (DHObjectAnimationRenderer *) animationRendererForName:(NSString *)animationName
{
    if ([animationName isEqualToString:@"Shimmer"]) {
        return [[DHShimmerAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Sparkle"]) {
        return [[DHSparkleAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Rotation"]) {
        return [[DHRotationAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Confetti"]) {
        return [[DHConfettiAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Blinds"]) {
        return [[DHBlindsAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Blur"]) {
        return [[DHBlurAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Drop"]) {
        return [[DHDropAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Pivot"]) {
        return [[DHPivotAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Pop"]) {
        return [[DHPopAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Scale"]) {
        return [[DHScaleAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Scale Big"]) {
        return [[DHScaleBigAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Spin"]) {
        return [[DHSpinAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Twirl"]) {
        return [[DHTwirlAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Dissolve"]) {
        return [[DHDissolveAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Skid"]) {
        return [[DHSkidAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Flame"]) {
        return [[DHFlameAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Anvil"]) {
        return [[DHAnvilAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Face Explosion"]) {
        return [[DHFaceExplosionAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Compress"]) {
        return [[DHCompressAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Point Explosion"]) {
        return [[DHPointExplosionAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Firework"]) {
        return [[DHFireworkAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Wipe"]) {
        return [[DHWipeAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Diffuse"]) {
        return [[DHDiffuseAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Blow"]) {
        return [[DHBlowAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Shredder"]) {
        return [[DHShredderAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Fold"]) {
        return [[DHFoldAnimationRenderer alloc] init];
    } else if ([animationName isEqualToString:@"Crumble"]) {
        return [[DHCrumbleAnimationRenderer alloc] init];
    }
    return nil;
}

+ (DHTransitionRenderer *) transitionRendererForName:(NSString *)transitionName
{
    if ([transitionName isEqualToString:@"DoorWay"]) {
        return [[DHDoorWayTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Cube"]) {
        return [[DHCubeTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Twist"]) {
        return [[DHTwistTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Cloth Line"]) {
        return [[DHClothLineTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Switch"]) {
        return [[DHSwitchTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Grid"]) {
        return [[DHGridTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Confetti"]) {
        return [[DHConfettiTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Push"]) {
        return [[DHPushTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Reveal"]) {
        return [[DHRevealTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Drop"]) {
        return [[DHDropTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Mosaic"]) {
        return [[DHMosaicTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Flop"]) {
        return [[DHFlopTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Cover"]) {
        return [[DHCoverTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Flip"]) {
        return [[DHFlipTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Reflection"]) {
        return [[DHReflectionTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Rotate Dismiss"]) {
        return [[DHSpinDismissTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Ripple"]) {
        return [[DHRippleTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Resolving Door"]) {
        return [[DHResolvingDoorTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Page Curl"]) {
        return [[DHPageCurlTransitionRenderer alloc] init];
    }
    return nil;
}

+ (NSString *) animationNameForAnimationType:(DHObjectAnimationType)animationType
{
    switch (animationType) {
        case DHObjectAnimationTypePop:
            return @"Pop";
        case DHObjectAnimationTypeBlur:
            return @"Blur";
        case DHObjectAnimationTypeDrop:
            return @"Drop";
        case DHObjectAnimationTypeNone:
            return @"None";
        case DHObjectAnimationTypeSkid:
            return @"Skid";
        case DHObjectAnimationTypeSpin:
            return @"Spin";
        case DHObjectAnimationTypeAnvil:
            return @"Anvil";
        case DHObjectAnimationTypeFlame:
            return @"Flame";
        case DHObjectAnimationTypePivot:
            return @"Pivot";
        case DHObjectAnimationTypeScale:
            return @"Scale";
        case DHObjectAnimationTypeTwirl:
            return @"Twirl";
        case DHObjectAnimationTypeBlinds:
            return @"Blinds";
        case DHObjectAnimationTypeShimmer:
            return @"Shimmer";
        case DHObjectAnimationTypeSparkle:
            return @"Sparkle";
        case DHObjectAnimationTypeConfetti:
            return @"Confetti";
        case DHObjectAnimationTypeDissolve:
            return @"Dissolve";
        case DHObjectAnimationTypeFirework:
            return @"Firework";
        case DHObjectAnimationTypeRotation:
            return @"Rotation";
        case DHObjectAnimationTypeScaleBig:
            return @"Scale Big";
        case DHObjectAnimationTypeFaceExplosion:
            return @"Face Explosion";
        case DHObjectAnimationTypeCompress:
            return @"Compress";
        case DHObjectAnimationTypePointExplosion:
            return @"Point Explosion";
        case DHOBjectAnimationTypeWipe:
            return @"Wipe";
        case DHObjectAnimationTypeDiffuse:
            return @"Diffuse";
        case DHObjectAnimationTypeBlow:
            return @"Blow";
        case DHObjectAnimationTypeShredder:
            return @"Shredder";
        case DHObjectAnimationTypeFold:
            return @"Fold";
        case DHObjectAnimationTypeCrumble:
            return @"Crumble";
    }
    return @"None";
}

+ (DHTextEffectRenderer *) textRendererForType:(DHTextAnimationType)type
{
    switch (type) {
        case DHTextAnimationTypeOrbital:
            return [[DHTextOrbitalAnimationRenderer alloc] init];
        case DHTextAnimationTypeFlyIn:
            return [[DHTextFlyInAnimationRenderer alloc] init];
        case DHTextAnimationTypeSquish: {
            return [[DHTextSquishAnimationRenderer alloc] init];
        }
        case DHTextAnimationTypeDance:
            return [[DHTextDanceAnimationRenderer alloc] init];
        case DHTextAnimationTypeFade:
            return [[DHTextFadeAnimationRenderer alloc] init];
        case DHTextAnimationTypeTrace:
            return [[DHTextTraceAnimationRenderer alloc] init];
        default:
            break;
    }
}

+ (NSString *) transitionNameForTransitionType:(DHTransitionType)transitionType
{
    if (transitionType == DHTransitionTypeNone) {
        return @"None";
    } else {
        return [DHConstants transitions][transitionType];
    }
}

+ (DHObjectAnimationType) animationTypeFromAnimationName:(NSString *)animationName
{
    return [[DHConstants allAnimations] indexOfObject:animationName];
}

+ (NSString *) resourcePathForFile:(NSString *)fileName ofType:(NSString *)fileType
{
    NSBundle *bundle = [NSBundle mainBundle];
    if ([[[NSBundle mainBundle] infoDictionary][@"FrameworkTarget"] boolValue])  {
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"DHAnimationBundle" ofType:@"bundle"]];
    }
    return [bundle pathForResource:fileName ofType:fileType];
}

+ (DHTransitionType) transitionTypeForTransitionName:(NSString *)transitionName
{
    return [transitionsArray indexOfObject:transitionName];
}

+ (NSString *) animationDirectionNameForAnimationDirection:(DHAnimationDirection)direction
{
    switch (direction) {
        case DHAnimationDirectionLeftToRight:
            return @"Left";
        case DHAnimationDirectionRightToLeft:
            return @"Right";
        case DHAnimationDirectionBottomToTop:
            return @"Bottom";
        case DHAnimationDirectionTopToBottom:
            return @"Top";
    }
}
@end
