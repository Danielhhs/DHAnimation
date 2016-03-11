//
//  TwistRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "TwistRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
#import "TwistMesh.h"
#import "DHTimingFunctionHelper.h"

@interface TwistRenderer () {
    GLuint srcProgram, dstProgram;
    GLuint srcMvpLoc, srcSamplerLoc, srcCenterPositionLoc;
    GLuint dstMvpLoc, dstSamplerLoc, dstCenterPositionLoc;
    GLuint srcTexture, dstTexture;
}
@property (nonatomic, strong) TwistMesh *sourceMesh;
@property (nonatomic, strong) TwistMesh *destinationMesh;
@end

@implementation TwistRenderer

- (void) performAnimationWithSettings:(DHAnimationSettings *)settings
{
    [self startTwistFromView:settings.fromView toView:settings.toView inContainerView:settings.containerView duration:settings.duration direction:settings.animationDirection timingFunction:[DHTimingFunctionHelper functionForTimingFunction:settings.timingFunction] completion:settings.completion];
}

- (void) startTwistFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    self.duration = duration;
    self.elapsedTime = 0.f;
    self.percent = 0.f;
    self.timingFunction = timingFunction;
    self.completion = completion;
    self.direction = direction;
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

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    srcProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"TwistSourceVertex.glsl" fragmentShaderSrc:@"TwistSourceFragment.glsl"];
    glUseProgram(srcProgram);
    srcMvpLoc = glGetUniformLocation(srcProgram, "u_mvpMatrix");
    srcSamplerLoc = glGetUniformLocation(srcProgram, "s_tex");
    srcCenterPositionLoc = glGetUniformLocation(srcProgram, "u_centerPosition");
    
    dstProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"TwistDestinationVertex.glsl" fragmentShaderSrc:@"TwistDestinationFragment.glsl"];
    glUseProgram(dstProgram);
    dstMvpLoc = glGetUniformLocation(dstProgram, "u_mvpMatrix");
    dstSamplerLoc = glGetUniformLocation(dstProgram, "s_tex");
    dstCenterPositionLoc = glGetUniformLocation(dstProgram, "u_centerPosition");
    
    glClearColor(0, 0, 0, 1);
}

- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    BOOL columnMajored = YES;
    NSInteger columnCount = fromView.bounds.size.width;
    NSInteger rowCount = 1;
    if (self.direction == AnimationDirectionBottomToTop || self.direction == AnimationDirectionTopToBottom) {
        columnMajored = NO;
        columnCount = 1;
        rowCount = fromView.bounds.size.height;
    }
    self.sourceMesh = [[TwistMesh alloc] initWithView:fromView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:NO columnMajored:columnMajored];
    self.destinationMesh = [[TwistMesh alloc] initWithView:toView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:NO columnMajored:columnMajored];
}

- (void) setupTextureWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    srcTexture = [TextureHelper setupTextureWithView:fromView];
    dstTexture = [TextureHelper setupTextureWithView:toView flipHorizontal:YES flipVertical:YES];
}

- (void) tearDownGL
{
    
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    glEnable(GL_CULL_FACE);
    GLKMatrix4 modelView = GLKMatrix4Translate(GLKMatrix4Identity, -view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    GLfloat aspect = view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(projection, modelView);
    
    glCullFace(GL_BACK);
    glUseProgram(dstProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(srcCenterPositionLoc, view.bounds.size.height / 2);
    [self.destinationMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.destinationMesh drawEntireMesh];
    
    glCullFace(GL_FRONT);
    glUseProgram(srcProgram);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(srcCenterPositionLoc, view.bounds.size.height / 2);
    [self.sourceMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.sourceMesh drawEntireMesh];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        CGFloat rotation = displayLink.duration / (self.duration * 0.618) * M_PI;
        CGFloat transition = MIN(self.elapsedTime / (self.duration * 0.382), 1);
        [self.sourceMesh updateWithRotation:rotation transition:transition];
        [self.destinationMesh updateWithRotation:rotation transition:transition];
        [self.animationView display];
    } else {
        CGFloat rotation = displayLink.duration / self.duration * M_PI * 3;
        [self.sourceMesh updateWithRotation:rotation transition:1];
        [self.destinationMesh updateWithRotation:rotation transition:1];
        [self.animationView display];
        [displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        if (self.completion) {
            self.completion();
        }
    }
}

@end
