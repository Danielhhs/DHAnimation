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
    GLuint srcPercentLoc, srcColumnWidthLoc;
    GLuint dstPercentLoc;
}
@property (nonatomic, strong) DoorWaySourceMesh *sourceMesh;
@property (nonatomic, strong) SceneMesh *destinamtionMesh;
@end

@implementation DoorWayRenderer

#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"DoorWaySourceVertex.glsl";
        self.srcFragmentShaderFileName = @"DoorWaySourceFragment.glsl";
        self.dstVertexShaderFileName = @"DoorWayDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"DoorWayDestinationFragment.glsl";
        
    }
    return self;
}

#pragma mark - Public Animation APIs
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
    [self setupMeshWithFromView:fromView toView:toView];
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

#pragma mark - Set Up
- (void) setupTextureWithSourceView:(UIView *)srcView destinationView:(UIView *)dstView
{
    srcTexture = [TextureHelper setupTextureWithView:srcView];
    dstTexture = [TextureHelper setupTextureWithView:dstView];
}

- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.sourceMesh = [[DoorWaySourceMesh alloc] initWithView:fromView columnCount:2 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES];
    self.destinamtionMesh = [[SceneMesh alloc] initWithView:toView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES];
}

#pragma mark - Drawing
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

#pragma mark - Override
- (SceneMesh *) srcMesh
{
    return self.sourceMesh;
}

- (SceneMesh *) dstMesh
{
    return self.destinamtionMesh;
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcPercentLoc = glGetUniformLocation(srcProgram, "u_percent");
    srcColumnWidthLoc = glGetUniformLocation(srcProgram, "u_columnWidth");
    
    glUseProgram(dstProgram);
    dstPercentLoc = glGetUniformLocation(dstProgram, "u_percent");
}
@end
