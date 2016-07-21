//
//  DHDiffuseAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 7/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHDiffuseAnimationRenderer.h"
#import "DHDiffuseSceneMesh.h"
#import "TextureHelper.h"

@interface DHDiffuseAnimationRenderer() {
    GLuint crackTimeRatioLoc, durationLoc, timeLoc;
}

@end

@implementation DHDiffuseAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    crackTimeRatioLoc = glGetUniformLocation(program, "u_crackTimeRatio");
    durationLoc = glGetUniformLocation(program, "u_duration");
    timeLoc = glGetUniformLocation(program, "u_time");
}

- (NSString *) vertexShaderName
{
    return @"ObjectDiffuseVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectDiffuseFragment.glsl";
}

- (void) setupMeshes
{
    int columnCount = self.targetView.frame.size.width / 5;
    int rowCount = self.targetView.frame.size.height / 10;
    self.mesh = [[DHDiffuseSceneMesh alloc] initWithView:self.targetView containerView:self.containerView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithView:self.targetView rotate:YES];
}

- (void) drawFrame
{
    [super drawFrame];
    
    glUniform1f(crackTimeRatioLoc, 0.7);
    glUniform1f(durationLoc, self.duration);
    glUniform1f(timeLoc, self.elapsedTime);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}
@end
