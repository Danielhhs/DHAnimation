//
//  DHObjectAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationRenderer.h"

@implementation DHObjectAnimationRenderer

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration
{
    [self startAnimationForView:targetView inContainerView:containerView duration:duration completion:nil];
}

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
    [self startAnimationForView:targetView inContainerView:containerView duration:duration timingFunction:NSBKeyframeAnimationFunctionLinear completion:completion];
}

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction
{
    [self startAnimationForView:targetView inContainerView:containerView duration:duration event:AnimationEventBuiltIn direction:direction];
}

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event
{
    [self startAnimationForView:targetView inContainerView:containerView duration:duration event:event direction:AnimationDirectionLeftToRight];
}

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction
{
    [self startAnimationForView:targetView inContainerView:containerView duration:duration event:event direction:direction timingFunction:NSBKeyframeAnimationFunctionLinear];
}

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction
{
    [self startAnimationForView:targetView inContainerView:containerView duration:duration event:event direction:direction timingFunction:timingFunction completion:nil];
}

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction
{
    [self startAnimationForView:targetView inContainerView:containerView duration:duration timingFunction:timingFunction completion:nil];
}

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion
{
    [self startAnimationForView:targetView inContainerView:containerView duration:duration event:AnimationEventBuiltIn direction:AnimationDirectionLeftToRight timingFunction:timingFunction completion:completion];
}

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    self.targetView = targetView;
    self.containerView = containerView;
    self.duration = duration;
    self.event = event;
    self.direction = direction;
    self.timingFunction = timingFunction;
    self.completion = completion;
    self.elapsedTime = 0.f;
    self.percent = 0.f;
}

- (void) performAnimationWithSettings:(DHObjectAnimationSettings *)settings
{
    [self startAnimationForView:settings.targetView inContainerView:settings.containerView duration:settings.duration event:settings.event direction:settings.direction timingFunction:[DHTimingFunctionHelper functionForTimingFunction:settings.timingFunction] completion:settings.completion];
}

@end
