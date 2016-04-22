//
//  DHObjectAnimationRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHObjectAnimationSettings.h"
#import "SceneMesh.h"
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
@property (nonatomic, strong) SceneMesh *mesh;

//Override this method to set up more uniform locations; Default implementation will set up unfiorms: u_mvpMatrix, s_tex, u_percent, u_direction, u_event; If you need these uniforms, just call super's implementation;
- (void) setupGL;

//Happens before set up effect and mesh; Override this method to set up some common data for both effects and meshes;
- (void) additionalSetUp;

//Set up meshes; You MUST override this method if you need to draw with some meshes. Default implementation is empty;
- (void) setupMeshes;

//Set up effects; Default implementation is empty;
- (void) setupEffects;

//Set up textures; default implementation just set up a texture with targetView;
- (void) setupTextures;

//Update your own data on every display link duration; default update is to update the elapsedTime and percent;
- (void) updateAdditionalComponents;

//Any drawing code would have to be writtin here; Default implementation just set the default uniform values;
- (void) drawFrame;


- (void) setupMvpMatrixWithView:(UIView *)view;

#pragma mark - Animation APIs
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


@end
