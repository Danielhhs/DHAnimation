//
//  DoorWayRenderer.m
//  DoorWayAnimation
//
//  Created by Huang Hongsen on 3/4/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DoorWayRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
#import "DoorWaySourceMesh.h"
#import "DHTimingFunctionHelper.h"

@interface DoorWayRenderer() {
    GLuint srcProgram, dstProgram;
    GLuint srcTexture, dstTexture;
    GLuint srcMvpLoc, srcSamplerLoc, srcPercentLoc, srcColumnWidthLoc;
    GLuint dstMvpLoc, dstSamplerLoc, dstPercentLoc;
}
@property (nonatomic, strong) DoorWaySourceMesh *sourceMesh;
@property (nonatomic, strong) SceneMesh *destinamtionMesh;
@end

@implementation DoorWayRenderer

- (void) performAnimationWithSettings:(DHAnimationSettings *)settings
{
    [self startDoorWayAnimationFromView:settings.fromView toView:settings.toView inView:settings.containerView duration:settings.duration timingFunction:[DHTimingFunctionHelper functionForTimingFunction:settings.timingFunction] completion:settings.completion];
}

- (void) startDoorWayAnimationFromView:(UIView *)fromView toView:(UIView *)toView inView:(UIView *)containerView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    self.duration = duration;
    self.elapsedTime = 0.f;
    self.percent = 0.f;
    self.completion = completion;
    self.timingFunction = timingFunction;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [self setupGL];
    self.sourceMesh = [[DoorWaySourceMesh alloc] initWithView:fromView columnCount:2 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES];
    self.destinamtionMesh = [[SceneMesh alloc] initWithView:toView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES];
    [self setupTextureWithSourceView:fromView destinationView:toView];
    self.animationView = [[GLKView alloc] initWithFrame:containerView.bounds context:self.context];
    self.animationView.delegate = self;
    [containerView addSubview:self.animationView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) startDoorWayAnimationFromView:(UIView *)fromView toView:(UIView *)toView inView:(UIView *)containerView duration:(NSTimeInterval)duration
{
    [self startDoorWayAnimationFromView:fromView toView:toView inView:containerView duration:duration completion:nil];
}

- (void) startDoorWayAnimationFromView:(UIView *)fromView toView:(UIView *)toView inView:(UIView *)containerView duration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
    [self startDoorWayAnimationFromView:fromView toView:toView inView:containerView duration:duration timingFunction:NSBKeyframeAnimationFunctionEaseInOutCubic completion:completion];
}

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    srcProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"DoorWaySourceVertex.glsl" fragmentShaderSrc:@"DoorWaySourceFragment.glsl"];
    glUseProgram(srcProgram);
    srcMvpLoc = glGetUniformLocation(srcProgram, "u_mvpMatrix");
    srcSamplerLoc = glGetUniformLocation(srcProgram, "s_tex");
    srcPercentLoc = glGetUniformLocation(srcProgram, "u_percent");
    srcColumnWidthLoc = glGetUniformLocation(srcProgram, "u_columnWidth");
    
    dstProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"DoorWayDestinationVertex.glsl" fragmentShaderSrc:@"DoorWayDestinationFragment.glsl"];
    glUseProgram(dstProgram);
    dstMvpLoc = glGetUniformLocation(dstProgram, "u_mvpMatrix");
    dstSamplerLoc = glGetUniformLocation(dstProgram, "s_tex");
    dstPercentLoc = glGetUniformLocation(dstProgram, "u_percent");
    
    glClearColor(0, 0, 0, 1);
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLKMatrix4 modelView = GLKMatrix4Translate(GLKMatrix4Identity, -view.bounds.size.width / 2, -view.bounds.size.height / 2, (-view.bounds.size.height / 2 - 500 * (1 - self.percent)) / tan(M_PI / 24));
    GLfloat aspect = view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(projection, modelView);
    
    glUseProgram(dstProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    
    [self.destinamtionMesh prepareToDraw];
    glUniform1f(dstPercentLoc, self.percent);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.destinamtionMesh drawEntireMesh];
    
    glUseProgram(srcProgram);
    modelView = GLKMatrix4Translate(GLKMatrix4Identity, -view.bounds.size.width / 2, -view.bounds.size.height / 2, (-view.bounds.size.height / 2) / tan(M_PI / 24));
    mvpMatrix = GLKMatrix4Multiply(projection, modelView);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    
    [self.sourceMesh prepareToDraw];
    glUniform1f(srcPercentLoc, self.percent);
    glUniform1f(srcColumnWidthLoc, view.bounds.size.width / 2);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.sourceMesh drawEntireMesh];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        GLfloat populatedTime = self.timingFunction(self.elapsedTime * 1000, 0, self.duration, self.duration * 1000);
        self.percent = populatedTime / self.duration;
        [self.animationView display];
    } else {
        self.percent = 1.f;
        [self.animationView display];
        [self.displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        [self tearDownGL];
        if (self.completion) {
            self.completion();
        }
    }
}

- (void) setupTextureWithSourceView:(UIView *)srcView destinationView:(UIView *)dstView
{
    srcTexture = [TextureHelper setupTextureWithView:srcView];
    dstTexture = [TextureHelper setupTextureWithView:dstView];
}

- (void) tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    [self.sourceMesh tearDown];
    [self.destinamtionMesh tearDown];
    glDeleteTextures(1, &srcTexture);
    srcTexture = 0;
    glDeleteTextures(1, &dstTexture);
    dstTexture = 0;
    glDeleteProgram(srcProgram);
    glDeleteProgram(dstProgram);
    [EAGLContext setCurrentContext:nil];
    self.context = nil;
}
@end
