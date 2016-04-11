//
//  DHObjectAnimationRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHObjectAnimationSettings.h"
@interface DHObjectAnimationRenderer : NSObject <GLKViewDelegate> {
    GLKMatrix4 mvpMatrix;
    GLuint program;
    GLuint texture;
    GLuint mvpLoc, samplerLoc, percentLoc, eventLoc, directionLoc;
}

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKView *animationView;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic) CGFloat percent;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) void(^completion)(void);
@property (nonatomic) NSBKeyframeAnimationFunction timingFunction;
@property (nonatomic) AnimationEvent event;
@property (nonatomic) AnimationDirection direction;
@property (nonatomic) NSInteger rowCount;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic, strong) NSString *vertexShaderName;
@property (nonatomic, strong) NSString *fragmentShaderName;

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration;
- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration completion:(void(^)(void))completion;
- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event;
- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction;
- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction;
- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction;

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion;
- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction;
- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion;
- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion;
- (void) performAnimationWithSettings:(DHObjectAnimationSettings *)settings;

- (void) setupGL;
- (void) setupTextures;
- (void) setupMeshes;
- (void) setupEffects;
- (void) drawFrame;
- (void) updateAdditionalComponents;
- (void) additionalSetUp;   //Happens before set up effect and mesh

- (void) setupMvpMatrixWithView:(UIView *)view;
@end
