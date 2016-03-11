//
//  CubeRenderer.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "CubeRenderer.h"
#import "OpenGLHelper.h"
#import "CubeSourceMesh.h"
#import "CubeDestinationMesh.h"
#import "TextureHelper.h"
#import "DHTimingFunctionHelper.h"
@interface CubeRenderer ()<GLKViewDelegate> {
    GLuint srcFaceProgram, srcFacePercentLoc, srcMvpLoc, srcFaceSamplerLoc, srcFaceEdgeWidthLoc, srcDirectionLoc;
    GLuint dstFaceProgram, dstFacePercentLoc, dstMvpLoc, dstFaceSamplerLoc, dstFaceEdgeWidthLoc, dstDirectionLoc;
    GLuint srcTexture;
    GLuint dstTexture;
    GLKMatrix4 mvpMatrix;
}
@property (nonatomic, strong) CubeSourceMesh *sourceMesh;
@property (nonatomic, strong) CubeDestinationMesh *destinationMesh;
@property (nonatomic) GLfloat edgeWidth;
@property (nonatomic) NSInteger columnCount;
@end

@implementation CubeRenderer

- (void) performAnimationWithSettings:(DHAnimationSettings *)settings
{
    [self startCubeTransitionFromView:settings.fromView toView:settings.toView columnCount:settings.columnCount inContainerView:settings.containerView direction:settings.animationDirection duration:settings.duration timingFunction:[DHTimingFunctionHelper functionForTimingFunction:settings.timingFunction] completion:settings.completion];
}

- (void) startCubeTransitionFromView:(UIView *)fromView toView:(UIView *)toView columnCount:(NSInteger)columnCount inContainerView:(UIView *)containerView direction:(AnimationDirection)direction duration:(NSTimeInterval)duration
{
    [self startCubeTransitionFromView:fromView toView:toView columnCount:columnCount inContainerView:containerView direction:direction duration:duration completion:nil];
}

- (void) startCubeTransitionFromView:(UIView *)fromView toView:(UIView *)toView columnCount:(NSInteger)columnCount inContainerView:(UIView *)containerView direction:(AnimationDirection)direction duration:(NSTimeInterval)duration  completion:(void (^)(void))completion
{
    [self startCubeTransitionFromView:fromView toView:toView columnCount:columnCount inContainerView:containerView direction:direction duration:duration timingFunction:NSBKeyframeAnimationFunctionEaseInCubic completion:completion];
}

- (void) startCubeTransitionFromView:(UIView *)fromView toView:(UIView *)toView columnCount:(NSInteger)columnCount inContainerView:(UIView *)containerView direction:(AnimationDirection)direction duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    self.duration = duration;
    self.completion = completion;
    self.timingFunction = timingFunction;
    self.elapsedTime = 0;
    self.direction = direction;
    self.columnCount = columnCount;
    
    self.percent = 0;
    [self generateEdgeWidthForView:fromView columnCount:columnCount];
    [self setupOpenGL];
    [self setupTexturesWithSource:fromView destination:toView];
    self.animationView = [[GLKView alloc] initWithFrame:fromView.frame context:self.context];
    self.animationView.delegate = self;
    self.sourceMesh = [[CubeSourceMesh alloc] initWithView:fromView columnCount:columnCount transitionDirection:direction];
    self.destinationMesh = [[CubeDestinationMesh alloc] initWithView:toView columnCount:columnCount transitionDirection:direction];
    [containerView addSubview:self.animationView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) generateEdgeWidthForView:(UIView *)view columnCount:(NSInteger)columnCount
{
    switch (self.direction) {
        case AnimationDirectionTopToBottom:
        case AnimationDirectionBottomToTop:
            self.edgeWidth = view.frame.size.height / columnCount;
            break;
        case AnimationDirectionLeftToRight:
        case AnimationDirectionRightToLeft:
            self.edgeWidth = view.frame.size.width / columnCount;
            break;
        default:
            break;
    }
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    GLfloat aspect = (GLfloat)view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 modelView = GLKMatrix4Translate(GLKMatrix4Identity, -view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
        GLKMatrix4 perspective = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    mvpMatrix = GLKMatrix4Multiply(perspective, modelView);
    
    glUseProgram(dstFaceProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(dstFacePercentLoc, self.percent);
    glUniform1f(dstFaceEdgeWidthLoc, self.edgeWidth);
    glUniform1i(dstDirectionLoc, self.direction);
    
    glUseProgram(srcFaceProgram);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(srcFacePercentLoc, self.percent);
    glUniform1f(srcFaceEdgeWidthLoc, self.edgeWidth);
    glUniform1i(srcDirectionLoc, self.direction);
    
    for (int i = 0; i < self.columnCount / 2; i++) {
        if (self.percent < .5) {
            [self drawDestinationFaceColumn:i inView:self.animationView];
            [self drawSourceFaceColumn:i inView:self.animationView];
        } else {
            [self drawSourceFaceColumn:i inView:self.animationView];
            [self drawDestinationFaceColumn:i inView:self.animationView];
        }
    }
    
    for (NSInteger i = self.columnCount; i >= self.columnCount / 2; i--) {
        if (self.percent < .5) {
            [self drawDestinationFaceColumn:i inView:self.animationView];
            [self drawSourceFaceColumn:i inView:self.animationView];
        } else {
            [self drawSourceFaceColumn:i inView:self.animationView];
            [self drawDestinationFaceColumn:i inView:self.animationView];
        }
    }
}

- (void) drawDestinationFaceColumn:(NSInteger)column inView:(GLKView *)view;
{
    glUseProgram(dstFaceProgram);
    [self.destinationMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstFaceSamplerLoc, 0);
    [self.destinationMesh drawColumnAtIndex:column];
}

- (void) drawSourceFaceColumn:(NSInteger)column inView:(GLKView *)view {
    glUseProgram(srcFaceProgram);
    [self.sourceMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcFaceSamplerLoc, 0);
    [self.sourceMesh drawColumnAtIndex:column];
}

#pragma mark - OpenGL
- (void) setupOpenGL
{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:self.context];
    srcFaceProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"CubeSourceVertex.glsl" fragmentShaderSrc:@"CubeSourceFragment.glsl"];
    dstFaceProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"CubeDestinationVertex.glsl" fragmentShaderSrc:@"CubeDestinationFragment.glsl"];
    glUseProgram(srcFaceProgram);
    srcMvpLoc = glGetUniformLocation(srcFaceProgram, "u_mvpMatrix");
    srcFacePercentLoc = glGetUniformLocation(srcFaceProgram, "u_percent");
    srcFaceEdgeWidthLoc = glGetUniformLocation(srcFaceProgram, "u_edgeWidth");
    srcFaceSamplerLoc = glGetUniformLocation(srcFaceSamplerLoc, "s_tex");
    srcDirectionLoc = glGetUniformLocation(srcFaceProgram, "u_direction");
    glUseProgram(dstFaceProgram);
    dstMvpLoc = glGetUniformLocation(dstFaceProgram, "u_mvpMatrix");
    dstFacePercentLoc = glGetUniformLocation(dstFaceProgram, "u_percent");
    dstFaceSamplerLoc = glGetUniformLocation(dstFaceProgram, "s_tex");
    dstFaceEdgeWidthLoc = glGetUniformLocation(dstFaceProgram, "u_edgeWidth");
    dstDirectionLoc = glGetUniformLocation(dstFaceProgram, "u_direction");
    glClearColor(0, 0, 0, 1);
}

- (void) tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    [self.sourceMesh destroyGL];
    [self.destinationMesh destroyGL];
    glDeleteTextures(1, &srcTexture);
    srcTexture = 0;
    glDeleteTextures(1, &dstTexture);
    dstTexture = 0;
    glDeleteProgram(srcFaceProgram);
    srcFaceProgram = 0;
    glDeleteProgram(dstFaceProgram);
    dstFaceProgram = 0;
    [EAGLContext setCurrentContext:nil];
    self.context = nil;
    self.animationView = nil;
}

- (void) setupTexturesWithSource:(UIView *)source destination:(UIView *)destination
{
    srcTexture = [TextureHelper setupTextureWithView:source];
    dstTexture = [TextureHelper setupTextureWithView:destination];
}

@end
