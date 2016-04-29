//
//  Enums.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHConstans.h"
#import "DHShimmerAnimationRenderer.h"
#import "DHSparkleAnimationRenderer.h"
#import "DHRotationAnimationRenderer.h"
#import "DHConfettiAnimationRenderer.h"
#import "DHBlindsAnimationRenderer.h"
#import "DHFireworkAnimationRenderer.h"
#import "DHBlurAnimationRenderer.h"
#import "DHFlipAnimationRenderer.h"
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

#import "DHDoorWayTransitionRenderer.h"
#import "DHCubeTransitionRenderer.h"
#import "DHTwistTransitionRenderer.h"
#import "DHClothLineTransitionRenderer.h"
#import "DHShredderTransitionRenderer.h"
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

static NSArray *transitionsArray;
static NSArray *builtInAnimationsArray;
static NSArray *builtOutAnimationsArray;
@implementation DHConstans

+ (NSArray *) transitions
{
    if (transitionsArray == nil) {
        transitionsArray = @[@"DoorWay", @"Cube", @"Twist", @"ClothLine", @"Shredder", @"Switch", @"Grid", @"Confetti", @"Push", @"Reveal", @"Drop", @"Mosaic", @"Flop", @"Cover", @"Flip", @"Reflection", @"Rotate Dismiss", @"Ripple", @"Resolving Door"];
    }
    return transitionsArray;
}

+ (NSArray *) builtInAnimations
{
    if (builtInAnimationsArray == nil) {
        builtInAnimationsArray = @[@"Shimmer", @"Sparkle", @"Rotation", @"Confetti", @"Blinds", @"Blur", @"Flip", @"Drop", @"Pivot", @"Pop", @"Scale", @"Scale Big", @"Spin", @"Twirl", @"Dissolve", @"Skid", @"Flame", @"Anvil"];
    }
    return builtInAnimationsArray;
}

+ (NSArray *) builtOutAnimations
{
    if (builtOutAnimationsArray == nil) {
        builtOutAnimationsArray = @[@"Shimmer", @"Sparkle", @"Rotation", @"Confetti", @"Blinds", @"Blur", @"Flip", @"Pivot", @"Pop", @"Scale", @"Scale Big", @"Spin", @"Twirl", @"Dissolve"];
    }
    return builtOutAnimationsArray;
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
    } else if ([animationName isEqualToString:@"Flip"]) {
        return [[DHFlipAnimationRenderer alloc] init];
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
    } else if ([transitionName isEqualToString:@"ClothLine"]) {
        return [[DHClothLineTransitionRenderer alloc] init];
    } else if ([transitionName isEqualToString:@"Shredder"]) {
        return [[DHShredderTransitionRenderer alloc] init];
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
    }
    return nil;
}
@end
