//
//  DHFlameAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/24/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFlameAnimationRenderer.h"
#import "OpenGLHelper.h"

@interface DHFlameAnimationRenderer() {
    GLuint resolutionLoc, timeLoc, rectLoc;
    GLuint backgroundProgram;
    GLuint backgroundMVPLoc, backgroundSamplerLoc, backgroundPercentLoc;
}
@property (nonatomic, strong) DHSceneMesh *backgroundMesh;
@end

@implementation DHFlameAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    resolutionLoc = glGetUniformLocation(program, "u_resolution");
    timeLoc = glGetUniformLocation(program, "uTime");
    rectLoc = glGetUniformLocation(program, "u_rect");
    
    backgroundProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"FlameBackgroundVertex.glsl" fragmentShaderSrc:@"FlameBackgroundFragment.glsl"];
    glUseProgram(backgroundProgram);
    backgroundMVPLoc = glGetUniformLocation(backgroundProgram, "u_mvpMatrix");
    backgroundPercentLoc = glGetUniformLocation(backgroundProgram, "u_percent");
    backgroundSamplerLoc = glGetUniformLocation(backgroundSamplerLoc, "s_tex");
}

- (NSString *) vertexShaderName
{
    return @"ObjectFlameVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectFlameFragment.glsl";
}

- (void) drawFrame
{
    glUseProgram(backgroundProgram);
    glUniformMatrix4fv(backgroundMVPLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(backgroundPercentLoc, self.percent);
    [self.backgroundMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(backgroundSamplerLoc, 0);
    [self.backgroundMesh drawEntireMesh];
    
    [super drawFrame];
    glUniform2f(resolutionLoc, self.targetView.frame.size.width * 2.5, self.targetView.frame.size.height * 2.5);
    glUniform4f(rectLoc, (CGRectGetMinX(self.targetView.frame) - self.targetView.frame.size.width * 0.1) * 2, (self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame)) * 2, (CGRectGetMaxX(self.targetView.frame) + self.targetView.frame.size.width * 0.1) * 2, (self.containerView.frame.size.height - CGRectGetMinY(self.targetView.frame) + self.targetView.frame.size.height * 0.2) * 2);
    glUniform1f(timeLoc, self.elapsedTime);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (void) setupMeshes
{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectInset(self.targetView.frame, -self.targetView.frame.size.width * 0.2, -self.targetView.frame.size.height * 0.2)];
    self.mesh = [DHSceneMeshFactory sceneMeshForView:tmpView containerView:self.containerView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
    self.backgroundMesh = [DHSceneMeshFactory sceneMeshForView:self.targetView containerView:self.containerView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionBottom)];
}
@end
