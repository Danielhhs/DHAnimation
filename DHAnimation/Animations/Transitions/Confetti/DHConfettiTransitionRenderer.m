//
//  ConfettiRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/16/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHConfettiTransitionRenderer.h"
#import "DHConfettiSourceMesh.h"

#define GRIDS_PER_ROW 60

@interface DHConfettiTransitionRenderer() {
    GLuint srcColumnWidthLoc, srcColumnHeightLoc;
    GLuint dstDepthLoc;
}
@end

@implementation DHConfettiTransitionRenderer

#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"ConfettiSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"ConfettiSourceFragment.glsl";
        self.dstVertexShaderFileName = @"ConfettiDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"ConfettiDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Override
- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.srcMesh = [[DHConfettiSourceMesh alloc] initWithView:fromView columnCount:GRIDS_PER_ROW rowCount:fromView.bounds.size.height / fromView.bounds.size.width * GRIDS_PER_ROW splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
    [self.srcMesh generateMeshData];
    self.dstMesh = [DHSceneMeshFactory sceneMeshForView:toView columnCount:1 rowCount:1 splitTexturesOnEachGrid:NO columnMajored:NO rotateTexture:YES];
    [self.dstMesh generateMeshData];
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcColumnWidthLoc = glGetUniformLocation(srcProgram, "u_columnWidth");
    srcColumnHeightLoc = glGetUniformLocation(srcProgram, "u_columnHeight");
    
    glUseProgram(dstProgram);
    dstDepthLoc = glGetUniformLocation(dstProgram, "u_depth");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcColumnWidthLoc, self.animationView.bounds.size.width / GRIDS_PER_ROW);
    glUniform1f(srcColumnHeightLoc, self.animationView.bounds.size.width / GRIDS_PER_ROW);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstDepthLoc, CONFETTI_DEPTH);
}

- (void) setupDrawingContext
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (NSArray *) allowedDirections
{
    return nil;
}
@end
