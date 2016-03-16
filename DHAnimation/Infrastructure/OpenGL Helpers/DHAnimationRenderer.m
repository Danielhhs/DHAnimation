//
//  DHAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
#import "DHTimingFunctionHelper.h"

@implementation DHAnimationRenderer

#pragma mark - Public Animation APIs
- (void) performAnimationWithSettings:(DHAnimationSettings *)settings
{
    [self startAnimationFromView:settings.fromView toView:settings.toView inContainerView:settings.containerView columnCount:settings.columnCount duration:settings.duration direction:settings.animationDirection timingFunction:[DHTimingFunctionHelper functionForTimingFunction:settings.timingFunction] completion:settings.completion];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration
{
    [self startAnimationFromView:fromView toView:toView inContainerView:containerView duration:duration direction:AnimationDirectionLeftToRight];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction
{
    [self startAnimationFromView:fromView toView:toView inContainerView:containerView duration:duration direction:direction completion:nil];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction completion:(void (^)(void))completion
{
    [self startAnimationFromView:fromView toView:toView inContainerView:containerView duration:duration direction:direction timingFunction:NSBKeyframeAnimationFunctionLinear completion:completion];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction
{
    [self startAnimationFromView:fromView toView:toView inContainerView:containerView duration:duration direction:direction timingFunction:timingFunction completion:nil];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    [self startAnimationFromView:fromView toView:toView inContainerView:containerView columnCount:1 duration:duration direction:direction timingFunction:timingFunction completion:completion];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView columnCount:(NSInteger)columnCount duration:(NSTimeInterval)duration direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    self.duration = duration;
    self.elapsedTime = 0.f;
    self.percent = 0.f;
    self.timingFunction = timingFunction;
    self.completion = completion;
    self.direction = direction;
    self.fromView = fromView;
    self.toView = toView;
    self.columnCount = columnCount;
    
    [self initializeAnimationContext];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [self setupGL];
    [self setupMeshWithFromView:fromView toView:toView];
    [self setupTextureWithFromView:fromView toView:toView];
    self.animationView = [[GLKView alloc] initWithFrame:fromView.frame context:self.context];
    self.animationView.delegate = self;
    [containerView addSubview:self.animationView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    [self setupMvpMatrixWithView:view];
    
    glUseProgram(dstProgram);
    glUniform1f(dstPercentLoc, self.percent);
    [self setupUniformsForDestinationProgram];
    [self.dstMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.dstMesh drawEntireMesh];
    
    glUseProgram(srcProgram);
    glUniform1f(srcPercentLoc, self.percent);
    [self setupUniformsForSourceProgram];
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        GLfloat populatedTime = self.timingFunction(self.elapsedTime * 1000, 0, self.duration, self.duration * 1000);
        self.percent = populatedTime / self.duration;
        [self.animationView display];
    } else {
        self.percent = 1;
        [self.animationView display];
        [displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        if (self.completion) {
            self.completion();
        }
        [self tearDownGL];
    }
}

#pragma mark - OpenGL
- (void) tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    [self.srcMesh tearDown];
    [self.dstMesh tearDown];
    if (srcTexture) {
        glDeleteTextures(1, &srcTexture);
        srcTexture = 0;
    }
    if (dstTexture) {
        glDeleteTextures(1, &dstTexture);
        dstTexture = 0;
    }
    if (srcProgram) {
        glDeleteProgram(srcProgram);
        srcProgram = 0;
    }
    if (dstProgram) {
        glDeleteProgram(dstProgram);
        dstProgram = 0;
    }
    self.animationView = nil;
    [EAGLContext setCurrentContext:nil];
    self.context = nil;
}

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    if (self.srcVertexShaderFileName && self.srcFragmentShaderFileName) {
        srcProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:self.srcVertexShaderFileName fragmentShaderSrc:self.srcFragmentShaderFileName];
        glUseProgram(srcProgram);
        srcMvpLoc = glGetUniformLocation(srcProgram, "u_mvpMatrix");
        srcSamplerLoc = glGetUniformLocation(srcProgram, "s_tex");
        srcPercentLoc = glGetUniformLocation(srcProgram, "u_percent");
    }
    if (self.dstVertexShaderFileName && self.dstFragmentShaderFileName) {
        dstProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:self.dstVertexShaderFileName fragmentShaderSrc:self.dstFragmentShaderFileName];
        glUseProgram(dstProgram);
        dstMvpLoc = glGetUniformLocation(dstProgram, "u_mvpMatrix");
        dstSamplerLoc = glGetUniformLocation(dstProgram, "s_tex");
        dstPercentLoc = glGetUniformLocation(dstProgram, "u_percent");
    }
    glClearColor(0, 0, 0, 1);
}

- (void) initializeAnimationContext
{
    
}

- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.srcMesh = [[SceneMesh alloc] initWithView:fromView columnCount:1 rowCount:1 splitTexturesOnEachGrid:NO columnMajored:YES];
    self.dstMesh = [[SceneMesh alloc] initWithView:toView columnCount:1 rowCount:1 splitTexturesOnEachGrid:NO columnMajored:YES];
}

- (void) setupTextureWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    srcTexture = [TextureHelper setupTextureWithView:fromView];
    dstTexture = [TextureHelper setupTextureWithView:toView];
}

- (void) setupMvpMatrixWithView:(UIView *)view
{
    GLKMatrix4 modelView = GLKMatrix4MakeTranslation(-view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    GLfloat aspect = view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 projectioin = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(projectioin, modelView);
    
    glUseProgram(srcProgram);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    
    glUseProgram(dstProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
}

- (void) setupUniformsForSourceProgram
{
    
}

- (void) setupUniformsForDestinationProgram
{
    
}
@end