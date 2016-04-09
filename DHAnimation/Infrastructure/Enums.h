//
//  Enums.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

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

typedef NS_ENUM(NSInteger, ParticleAnimationType) {
    ParticleAnimationTypeShimmer = 0,
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
    AnimationEventBuiltInOut = 2,
};

@interface Enums : NSObject

@end
