//
//  DHCoverRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHCoverTransitionRenderer.h"
@interface DHCoverTransitionRenderer() {
    GLuint srcScreenHeightLoc, dstScreenHeightLoc;
}
@end

@implementation DHCoverTransitionRenderer
#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"CoverSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"CoverSourceFragment.glsl";
        self.dstVertexShaderFileName = @"CoverDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"CoverDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    [self setupDrawingContext];
    [self setupMvpMatrixWithView:view];
    
    if (self.percent < 0.5) {
        [self drawDestinationMesh];
        [self drawSourceMesh];
    } else {
        [self drawSourceMesh];
        [self drawDestinationMesh];
    }
}

- (void) drawDestinationMesh
{
    [self prepareToDrawDestinationFace];
    glUseProgram(dstProgram);
    glUniform1f(dstPercentLoc, self.percent);
    glUniform1i(dstDirectionLoc, self.direction);
    [self setupUniformsForDestinationProgram];
    [self.dstMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.dstMesh drawEntireMesh];
}

- (void) drawSourceMesh
{
    [self prepareToDrawSourceFace];
    glUseProgram(srcProgram);
    glUniform1f(srcPercentLoc, self.percent);
    glUniform1i(srcDirectionLoc, self.direction);
    [self setupUniformsForSourceProgram];
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
}

#pragma mark - Override
- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcScreenHeightLoc = glGetUniformLocation(srcProgram, "u_screenHeight");
    
    glUseProgram(dstProgram);
    dstScreenHeightLoc = glGetUniformLocation(dstProgram, "u_screenHeight");
}

- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.srcMesh = [DHSceneMeshFactory sceneMeshForView:fromView columnCount:1 rowCount:fromView.bounds.size.height splitTexturesOnEachGrid:NO columnMajored:NO rotateTexture:YES];
    [self.srcMesh generateMeshData];
    self.dstMesh = [DHSceneMeshFactory sceneMeshForView:toView columnCount:1 rowCount:fromView.bounds.size.height splitTexturesOnEachGrid:NO columnMajored:NO rotateTexture:YES];
    [self.dstMesh generateMeshData];
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcScreenHeightLoc, self.animationView.bounds.size.height);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstScreenHeightLoc, self.animationView.bounds.size.height);
}

- (void) prepareToDrawDestinationFace
{
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
}

- (void) prepareToDrawSourceFace
{
    glCullFace(GL_FRONT);
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionTop)];
}
@end
