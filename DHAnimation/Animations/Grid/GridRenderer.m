//
//  GridRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/15/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "GridRenderer.h"
@interface GridRenderer() {
    GLuint srcScreenWidthLoc, dstScreenWidthLoc;
    GLuint srcDirectionLoc, dstDirectionLoc;
}
@end

@implementation GridRenderer
#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"GridSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"GridSourceFragment.glsl";
        self.dstVertexShaderFileName = @"GridDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"GridDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    [self setupMvpMatrixWithView:view];
    
    glUseProgram(srcProgram);
    glUniform1f(srcPercentLoc, self.percent);
    glUniform1f(srcScreenWidthLoc, view.bounds.size.width);
    glUniform1i(srcDirectionLoc, self.direction);
    
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
    
    glUseProgram(dstProgram);
    glUniform1f(dstPercentLoc, self.percent);
    glUniform1f(dstScreenWidthLoc, view.bounds.size.width);
    glUniform1i(dstDirectionLoc, self.direction);
    [self.dstMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.dstMesh drawEntireMesh];
}

#pragma mark - Override
- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcScreenWidthLoc = glGetUniformLocation(srcProgram, "u_screenWidth");
    srcDirectionLoc = glGetUniformLocation(srcProgram, "u_direction");
    
    glUseProgram(dstProgram);
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
    dstDirectionLoc = glGetUniformLocation(dstProgram, "u_direction");
}
@end
