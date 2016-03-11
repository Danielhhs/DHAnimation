//
//  CubeRenderer.h
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHAnimationRenderer.h"
#import "NSBKeyframeAnimationFunctions.h"
#import "CubeMesh.h"
@interface CubeRenderer : DHAnimationRenderer

- (void) startCubeTransitionFromView:(UIView *)fromView toView:(UIView *)toView columnCount:(NSInteger)columnCount inContainerView:(UIView *)containerView direction:(AnimationDirection)direction duration:(NSTimeInterval)duration;

- (void) startCubeTransitionFromView:(UIView *)fromView toView:(UIView *)toView columnCount:(NSInteger)columnCount inContainerView:(UIView *)containerView direction:(AnimationDirection)direction duration:(NSTimeInterval)duration completion:(void (^)(void))completion;

- (void) startCubeTransitionFromView:(UIView *)fromView toView:(UIView *)toView columnCount:(NSInteger)columnCount inContainerView:(UIView *)containerView direction:(AnimationDirection)direction duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion;
@end
