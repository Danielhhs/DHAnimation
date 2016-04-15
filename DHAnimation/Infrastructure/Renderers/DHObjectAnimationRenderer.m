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
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [self setupGL];
    [self setupMvpMatrixWithView:containerView];
    [self additionalSetUp];
    [self setupMeshes];
    [self setupEffects];
    [self setupTextures];
    
    self.animationView = [[GLKView alloc] initWithFrame:containerView.frame context:self.context];
    self.animationView.delegate = self;
    
    [containerView addSubview:self.animationView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) performAnimationWithSettings:(DHObjectAnimationSettings *)settings
{
    [self startAnimationForView:settings.targetView inContainerView:settings.containerView duration:settings.duration columnCount:settings.columnCount rowCount:settings.rowCount event:settings.event direction:settings.direction timingFunction:[DHTimingFunctionHelper functionForTimingFunction:settings.timingFunction] completion:settings.completion];
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
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    [self drawFrame];
}

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    if (self.vertexShaderName != nil && self.fragmentShaderName != nil) {
        program = [OpenGLHelper loadProgramWithVertexShaderSrc:self.vertexShaderName fragmentShaderSrc:self.fragmentShaderName];
        glUseProgram(program);
        mvpLoc = glGetUniformLocation(program, "u_mvpMatrix");
        samplerLoc = glGetUniformLocation(program, "s_tex");
        percentLoc = glGetUniformLocation(program, "u_percent");
        eventLoc = glGetUniformLocation(program, "u_event");
        directionLoc = glGetUniformLocation(program, "u_direction");
    }
    
    glClearColor(0, 0, 0, 1);
}

- (void) additionalSetUp
{
    
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        NSTimeInterval populatedTime = self.timingFunction(self.elapsedTime * 1000, 0, self.duration, self.duration * 1000);
        self.percent = populatedTime / self.duration;
        [self updateAdditionalComponents];
        [self.animationView display];
    } else {
        [self.animationView display];
        [self.displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        if (self.completion) {
            self.completion();
        }
    }
}

- (void) drawFrame
{
    glUseProgram(program);
    glUniform1f(eventLoc, self.event);
    glUniform1f(directionLoc, self.direction);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(percentLoc, self.percent);
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithView:self.targetView];
}

- (void) setupMeshes
{
    
}

- (void) setupEffects
{
    
}

- (void) updateAdditionalComponents
{
    
}
@end
