//
//  DHObjectAnimationRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHObjectAnimationSettings.h"
@interface DHObjectAnimationRenderer : NSObject

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKView *animationView;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *animateInView;
@property (nonatomic, weak) UIView *animateOutView;
@property (nonatomic) CGFloat percent;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) void(^completion)(void);
@property (nonatomic) NSBKeyframeAnimationFunction timingFunction;
@property (nonatomic) AnimationEvent event;
@property (nonatomic) AnimationDirection direction;

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration;
- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration completion:(void(^)(void))completion;
- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event;
- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction;
- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction;
- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction;

- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion;
- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction;
- (void) startAnimationForAnimateInView:(UIView *)animateInView animateOutView:(UIView *)animateOutView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion;
- (void) performAnimationWithSettings:(DHObjectAnimationSettings *)settings;

@end
