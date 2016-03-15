//
//  ClothLineRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "ClothLineRenderer.h"

@interface ClothLineRenderer() {
    GLuint srcScreenWidthLoc, dstScreenWidthLoc;
    GLuint srcScreenHeightLoc, dstScreenHeightLoc;
    GLuint srcDirectionLoc, dstDirectionLoc;
    GLuint dstDurationLoc;
}
@end

@implementation ClothLineRenderer

#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"ClothLineSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"ClothLineSourceFragment.glsl";
        self.dstVertexShaderFileName = @"ClothLineDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"ClothLineDestinationFragment.glsl";
    }
    return self;
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcScreenWidthLoc = glGetUniformLocation(srcProgram, "u_screenWidth");
    srcScreenHeightLoc = glGetUniformLocation(srcProgram, "u_screenHeight");
    srcDirectionLoc = glGetUniformLocation(srcProgram, "u_direction");
    
    glUseProgram(dstProgram);
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
    dstScreenHeightLoc = glGetUniformLocation(dstProgram, "u_screenHeight");
    dstDurationLoc = glGetUniformLocation(dstProgram, "u_duration");
    dstDirectionLoc = glGetUniformLocation(dstProgram, "u_direction");
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    glEnable(GL_CULL_FACE);
    GLKMatrix4 modelView = GLKMatrix4Translate(GLKMatrix4Identity, -view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    GLfloat aspect = view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(projection, modelView);
    
    glCullFace(GL_FRONT);
    glUseProgram(dstProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(dstPercentLoc, self.percent);
    glUniform1f(dstScreenWidthLoc, view.bounds.size.width);
    glUniform1f(dstScreenHeightLoc, view.bounds.size.height);
    glUniform1i(dstDirectionLoc, self.direction);
    glUniform1f(dstDurationLoc, self.duration);
    [self.dstMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.dstMesh drawEntireMesh];
    
    glCullFace(GL_FRONT);
    glUseProgram(srcProgram);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(srcPercentLoc, self.percent);
    glUniform1f(srcScreenWidthLoc, view.bounds.size.width);
    glUniform1f(srcScreenHeightLoc, view.bounds.size.height);
    glUniform1i(srcDirectionLoc, self.direction);
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
}
@end
