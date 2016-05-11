//
//  CubeRenderer.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHCubeTransitionRenderer.h"
#import "OpenGLHelper.h"
#import "DHCubeSourceMesh.h"
#import "DHCubeDestinationMesh.h"
#import "TextureHelper.h"
#import "DHTimingFunctionHelper.h"
@interface DHCubeTransitionRenderer ()<GLKViewDelegate> {
    GLuint srcFaceEdgeWidthLoc;
    GLuint dstFaceEdgeWidthLoc;
}
@property (nonatomic, strong) DHCubeSourceMesh *sourceMesh;
@property (nonatomic, strong) DHCubeDestinationMesh *destinationMesh;
@property (nonatomic) GLfloat edgeWidth;
@end

@implementation DHCubeTransitionRenderer
#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"CubeSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"CubeSourceFragment.glsl";
        self.dstVertexShaderFileName = @"CubeDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"CubeDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);

    [self setupMvpMatrixWithView:view];
    
    glUseProgram(dstProgram);
    glUniform1f(dstPercentLoc, self.percent);
    glUniform1f(dstFaceEdgeWidthLoc, self.edgeWidth);
    glUniform1i(dstDirectionLoc, self.direction);
    
    glUseProgram(srcProgram);
    glUniform1f(srcPercentLoc, self.percent);
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
    glUseProgram(dstProgram);
    [self.destinationMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.destinationMesh drawColumnAtIndex:column];
}

- (void) drawSourceFaceColumn:(NSInteger)column inView:(GLKView *)view {
    glUseProgram(srcProgram);
    [self.sourceMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.sourceMesh drawColumnAtIndex:column];
}

#pragma mark - Override
- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcFaceEdgeWidthLoc = glGetUniformLocation(srcProgram, "u_edgeWidth");
    
    glUseProgram(dstProgram);
    dstFaceEdgeWidthLoc = glGetUniformLocation(dstProgram, "u_edgeWidth");
}

- (DHSceneMesh *) srcMesh
{
    return self.sourceMesh;
}

- (DHSceneMesh *) dstMesh
{
    return self.destinationMesh;
}

- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.sourceMesh = [[DHCubeSourceMesh alloc] initWithView:fromView columnCount:self.columnCount transitionDirection:self.direction];
    self.destinationMesh = [[DHCubeDestinationMesh alloc] initWithView:toView columnCount:self.columnCount transitionDirection:self.direction];
}

- (void) initializeAnimationContext
{
    switch (self.direction) {
        case DHAnimationDirectionTopToBottom:
        case DHAnimationDirectionBottomToTop:
            self.edgeWidth = self.fromView.frame.size.height / self.columnCount;
            break;
        case DHAnimationDirectionLeftToRight:
        case DHAnimationDirectionRightToLeft:
            self.edgeWidth = self.fromView.frame.size.width / self.columnCount;
            break;
        default:
            break;
    }
}


- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft), @(DHAllowedAnimationDirectionRight), @(DHAllowedAnimationDirectionTop), @(DHAllowedAnimationDirectionBottom)];
}
@end
