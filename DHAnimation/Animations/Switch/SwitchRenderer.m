//
//  SwitchRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/15/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "SwitchRenderer.h"
@interface SwitchRenderer() {
    GLuint srcScreenWidthLoc, dstScreenWidthLoc;
    GLuint srcScreenHeightLoc, dstScreenHeightLoc;
}

@end

@implementation SwitchRenderer
#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"SwitchSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"SwitchSourceFragment.glsl";
        self.dstVertexShaderFileName = @"SwitchDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"SwitchDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLKMatrix4 modelView = GLKMatrix4MakeTranslation(-view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    GLfloat aspect = view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 perspective = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(perspective, modelView);
    
    glUseProgram(srcProgram);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(srcPercentLoc, self.percent);
    glUniform1f(srcScreenWidthLoc, view.bounds.size.width);
    glUniform1f(srcScreenHeightLoc, view.bounds.size.height);
    
    glUseProgram(dstProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(dstScreenWidthLoc, view.bounds.size.width);
    glUniform1f(dstScreenHeightLoc, view.bounds.size.height);
    
    if (self.percent < 0.5) {
        [self drawDestinationMesh];
        [self drawSourceMesh];
    } else {
        [self drawSourceMesh];
        [self drawDestinationMesh];
    }
}

- (void) drawSourceMesh
{
    glUseProgram(srcProgram);
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
}

- (void) drawDestinationMesh
{
    glUseProgram(dstProgram);
    glUniform1f(dstPercentLoc, self.percent);
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
    srcScreenHeightLoc = glGetUniformLocation(srcProgram, "u_screenHeight");
    
    glUseProgram(dstProgram);
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
    dstScreenHeightLoc = glGetUniformLocation(dstProgram, "u_screenHeight");
}

@end
