//
//  DHObjectAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationRenderer.h"

@implementation DHObjectAnimationRenderer

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration
{
    [self startAnimationForAnimateInView:animateInView animateOutView:animateOutView inContainerView:containerView duration:duration completion:nil];
}

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
    [self startAnimationForAnimateInView:animateInView animateOutView:animateOutView inContainerView:containerView duration:duration timingFunction:NSBKeyframeAnimationFunctionLinear completion:completion];
}

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction
{
    [self startAnimationForAnimateInView:animateInView animateOutView:animateOutView inContainerView:containerView duration:duration event:AnimationEventBuiltIn direction:direction];
}

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event
{
    [self startAnimationForAnimateInView:animateInView animateOutView:animateOutView inContainerView:containerView duration:duration event:event direction:AnimationDirectionLeftToRight];
}

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction
{
    [self startAnimationForAnimateInView:animateInView animateOutView:animateOutView inContainerView:containerView duration:duration event:event direction:direction timingFunction:NSBKeyframeAnimationFunctionLinear];
}

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction
{
    [self startAnimationForAnimateInView:animateInView animateOutView:animateOutView inContainerView:containerView duration:duration event:event direction:direction timingFunction:timingFunction completion:nil];
}

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction
{
    [self startAnimationForAnimateInView:animateInView animateOutView:animateOutView inContainerView:containerView duration:duration timingFunction:timingFunction completion:nil];
}

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion
{
    [self startAnimationForAnimateInView:animateInView animateOutView:animateOutView inContainerView:containerView duration:duration event:AnimationEventBuiltIn direction:AnimationDirectionLeftToRight timingFunction:timingFunction completion:completion];
}

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    self.animateInView = animateInView;
    self.animateOutView = animateOutView;
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
    [self startAnimationForAnimateInView:settings.animateInView animateOutView:settings.animateOutView inContainerView:settings.containerView duration:settings.duration event:settings.event direction:settings.direction timingFunction:settings.timingFunction completion:settings.completion];
}

@end
