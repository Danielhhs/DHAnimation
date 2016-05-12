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
typedef NS_ENUM(NSInteger, DHTransitionType) {
    DHTransitionTypeNone = -1,
    DHTransitionTypeDoorWay = 0,
    DHTransitionTypeCube = 1,
    DHTransitionTypeTwist = 2,
    DHTransitionTypeClothLine = 3,
    DHTransitionTypeShredder = 4,
    DHTransitionTypeSwitch = 5,
    DHTransitionTypeGrid = 6,
    DHTransitionTypeConfetti = 7,
    DHTransitionTypePush = 8,
    DHTransitionTypeReveal = 9,
    DHTransitionTypeDrop = 10,
    DHTransitionTypeMosaic = 11,
    DHTransitionTypeFlop = 12,
    DHTransitionTypeCover = 13,
    DHTransitionTypeFlip = 14,
    DHTransitionTypeReflection = 15,
    DHTransitionTypeRotateDismiss = 16,
    DHTransitionTypeRipple = 17,
    DHTransitionTypeResolvingDoor = 18,
};

typedef NS_ENUM(NSInteger, DHObjectAnimationType) {
    DHObjectAnimationTypeNone = -1,
    DHObjectAnimationTypeShimmer = 0,
    DHObjectAnimationTypeSparkle = 1,
    DHObjectAnimationTypeRotation = 2,
    DHObjectAnimationTypeConfetti = 3,
    DHObjectAnimationTypeBlinds = 4,
    DHObjectAnimationTypeFirework = 5,
    DHObjectAnimationTypeBlur = 6,
    DHObjectAnimationTypeFlip = 7,
    DHObjectAnimationTypeDrop = 8,
    DHObjectAnimationTypePivot = 9,
    DHObjectAnimationTypePop = 10,
    DHObjectAnimationTypeScale = 11,
    DHObjectAnimationTypeScaleBig = 12,
    DHObjectAnimationTypeSpin = 13,
    DHObjectAnimationTypeTwirl = 14,
    DHObjectAnimationTypeDissolve = 15,
    DHObjectAnimationTypeSkid = 16,
    DHObjectAnimationTypeFlame = 17,
    DHObjectAnimationTypeAnvil = 18,
    DHObjectAnimationTypeFaceExplosion = 19,
};

typedef NS_ENUM(NSInteger, DHAnimationDirection) {
    DHAnimationDirectionLeftToRight = 0,
    DHAnimationDirectionRightToLeft = 1,
    DHAnimationDirectionTopToBottom = 2,
    DHAnimationDirectionBottomToTop = 3,
};

typedef NS_ENUM(NSInteger, DHAnimationEvent) {
    DHAnimationEventBuiltIn = 0,
    DHAnimationEventBuiltOut = 1,
};

typedef NS_ENUM(NSInteger, DHAllowedAnimationDirection) {
    DHAllowedAnimationDirectionLeft = 1,
    DHAllowedAnimationDirectionRight = 1 << 1,
    DHAllowedAnimationDirectionTop = 1 << 2,
    DHAllowedAnimationDirectionBottom = 1 << 3,
};

@interface DHConstants : NSObject

+ (NSArray *) transitions;
+ (NSArray *) builtInAnimations;
+ (NSArray *) builtOutAnimations;
+ (NSArray *) allAnimations;

+ (DHTransitionRenderer *)transitionRendererForName:(NSString *)transitionName;
+ (DHObjectAnimationRenderer *) animationRendererForName:(NSString *)animationName;
+ (NSString *) animationNameForAnimationType:(DHObjectAnimationType) animationType;
+ (NSString *) transitionNameForTransitionType:(DHTransitionType) transitionType;
+ (DHObjectAnimationType) animationTypeFromAnimationName:(NSString *)animationName;

+ (NSString *) resourcePathForFile:(NSString *)fileName ofType:(NSString *)fileType;
@end
