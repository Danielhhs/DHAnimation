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
    
    GLKMatrix4 modelView = GLKMatrix4MakeTranslation(-view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    GLfloat aspect = view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(projection, modelView);
    
    glUseProgram(srcProgram);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(srcPercentLoc, self.percent);
    glUniform1f(srcScreenWidthLoc, view.bounds.size.width);
    glUniform1i(srcDirectionLoc, self.direction);
    
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
    
    glUseProgram(dstProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
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
