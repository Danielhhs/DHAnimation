//
//  DHObjectAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"

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
    [self startAnimationForView:targetView inContainerView:containerView duration:duration columnCount:1 rowCount:1 event:event direction:direction timingFunction:timingFunction completion:completion];
}

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
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
    self.columnCount = columnCount;
    self.rowCount = rowCount;
}

- (void) performAnimationWithSettings:(DHObjectAnimationSettings *)settings
{
    [self startAnimationForView:settings.targetView inContainerView:settings.containerView duration:settings.duration event:settings.event direction:settings.direction timingFunction:[DHTimingFunctionHelper functionForTimingFunction:settings.timingFunction] completion:settings.completion];
}

- (void) setupMvpMatrixWithView:(UIView *)view
{
    GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(-view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 1, 0, 0, 0, 0, 1, 0);
    GLKMatrix4 modelView = GLKMatrix4Multiply(viewMatrix, modelMatrix);
    GLKMatrix4 projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), view.bounds.size.width / view.bounds.size.height, 0.1, 10000);
    
    mvpMatrix = GLKMatrix4Multiply(projection, modelView);
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
}

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    program = [OpenGLHelper loadProgramWithVertexShaderSrc:@"ShimmerBackgroundVertex.glsl" fragmentShaderSrc:@"ShimmerBackgroundFragment.glsl"];
    glUseProgram(program);
    mvpLoc = glGetUniformLocation(program, "u_mvpMatrix");
    samplerLoc = glGetUniformLocation(program, "s_tex");
    percentLoc = glGetUniformLocation(program, "u_percent");
    eventLoc = glGetUniformLocation(program, "u_animationEvent");
    directionLoc = glGetUniformLocation(program, "u_animationDirection");
    
    glClearColor(0, 0, 0, 1);
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithView:self.targetView];
}
@end
