//
//  DoorWayRenderer.h
//  DoorWayAnimation
//
//  Created by Huang Hongsen on 3/4/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationRenderer.h"
#import "NSBKeyframeAnimationFunctions.h"

@interface DoorWayRenderer : DHAnimationRenderer

- (void) performAnimationWithSettings:(DHAnimationSettings *)settings;

- (void) startDoorWayAnimationFromView:(UIView *)fromView toView:(UIView *)toView inView:(UIView *)containerView duration:(NSTimeInterval)duration;

- (void) startDoorWayAnimationFromView:(UIView *)fromView toView:(UIView *)toView inView:(UIView *)containerView duration:(NSTimeInterval)duration completion:(void(^)(void))completion;

- (void) startDoorWayAnimationFromView:(UIView *)fromView toView:(UIView *)toView inView:(UIView *)containerView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion;

@end
