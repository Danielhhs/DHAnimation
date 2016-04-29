//
//  Enums.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHTransitionRenderer;
@class DHObjectAnimationRenderer;
typedef NS_ENUM(NSInteger, TransitionType) {
    TransitionTypeDoorWay = 0,
    TransitionTypeCube = 1,
    TransitionTypeTwist = 2,
    TransitionTypeClothLine = 3,
    TransitionTypeShredder = 4,
    TransitionTypeSwitch = 5,
    TransitionTypeGrid = 6,
    TransitionTypeConfetti = 7,
    TransitionTypePush = 8,
    TransitionTypeReveal = 9,
    TransitionTypeDrop = 10,
    TransitionTypeMosaic = 11,
    TransitionTypeFlop = 12,
    TransitionTypeCover = 13,
    TransitionTypeFlip = 14,
    TransitionTypeReflection = 15,
    TransitionTypeRotateDismiss = 16,
    TransitionTypeRipple = 17,
    TransitionTypeResolvingDoor = 18,
};

typedef NS_ENUM(NSInteger, ObjectAnimationType) {
    ObjectAnimationTypeShimmer = 0,
    ObjectAnimationTypeSparkle = 1,
    ObjectAnimationTypeRotation = 2,
    ObjectAnimationTypeConfetti = 3,
    ObjectAnimationTypeBlinds = 4,
    ObjectAnimationTypeFirework = 5,
    ObjectAnimationTypeBlur = 6,
    ObjectAnimationTypeFlip = 7,
    ObjectAnimationTypeDrop = 8,
    ObjectAnimationTypePivot = 9,
    ObjectAnimationTypePop = 10,
    ObjectAnimationTypeScale = 11,
    ObjectAnimationTypeScaleBig = 12,
    ObjectAnimationTypeSpin = 13,
    ObjectAnimationTypeTwirl = 14,
    ObjectAnimationTypeDissolve = 15,
    ObjectAnimationTypeSkid = 16,
    ObjectAnimationTypeFlame = 17,
    ObjectAnimationAnvil = 18,
};

typedef NS_ENUM(NSInteger, AnimationDirection) {
    AnimationDirectionLeftToRight = 0,
    AnimationDirectionRightToLeft = 1,
    AnimationDirectionTopToBottom = 2,
    AnimationDirectionBottomToTop = 3,
};

typedef NS_ENUM(NSInteger, AnimationEvent) {
    AnimationEventBuiltIn = 0,
    AnimationEventBuiltOut = 1,
};

typedef NS_ENUM(NSInteger, AllowedAnimationDirection) {
    AllowedAnimationDirectionLeft = 1,
    AllowedAnimationDirectionRight = 1 << 1,
    AllowedAnimationDirectionTop = 1 << 2,
    AllowedAnimationDirectionBottom = 1 << 3,
};

@interface DHConstans : NSObject

+ (NSArray *) transitions;
+ (NSArray *) builtInAnimations;
+ (NSArray *) builtOutAnimations;

+ (DHTransitionRenderer *)transitionRendererForName:(NSString *)transitionName;
+ (DHObjectAnimationRenderer *) animationRendererForName:(NSString *)animationName;

@end
