//
//  ConfettiRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/16/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "ConfettiRenderer.h"
#import "ConfettiSourceMesh.h"

#define CONFETTI_EDGE 20

@interface ConfettiRenderer() {
    GLuint srcColumnWidthLoc, srcColumnHeightLoc;
}
@end

@implementation ConfettiRenderer

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
    self.srcMesh = [[ConfettiSourceMesh alloc] initWithView:fromView columnCount:fromView.bounds.size.width / CONFETTI_EDGE rowCount:fromView.bounds.size.height / CONFETTI_EDGE splitTexturesOnEachGrid:YES columnMajored:YES];
    self.dstMesh = [[SceneMesh alloc] initWithView:toView columnCount:1 rowCount:1 splitTexturesOnEachGrid:NO columnMajored:YES];
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcColumnWidthLoc = glGetUniformLocation(srcProgram, "u_columnWidth");
    srcColumnHeightLoc = glGetUniformLocation(srcProgram, "u_columnHeight");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcColumnWidthLoc, CONFETTI_EDGE);
    glUniform1f(srcColumnHeightLoc, CONFETTI_EDGE);
}

- (void) setupDrawingContext
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}
@end
