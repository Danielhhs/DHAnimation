//
//  DHBlowAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 7/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBlowAnimationRenderer.h"
#import "DHBlowSceneMesh.h"
#import "TextureHelper.h"

@interface DHBlowAnimationRenderer() {
    GLuint minStartTimeLoc, startTimeRangeLoc, blowingTimeRatioLoc, durationLoc, timeLoc;
}

@end

@implementation DHBlowAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectBlowVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectBlowFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
    
    minStartTimeLoc = glGetUniformLocation(program, "u_minStartTime");
    startTimeRangeLoc = glGetUniformLocation(program, "u_startTimeRange");
    blowingTimeRatioLoc = glGetUniformLocation(program, "u_blowingTimeRatio");
    durationLoc = glGetUniformLocation(program, "u_duration");
    timeLoc = glGetUniformLocation(program, "u_time");
}

- (void) setupMeshes
{
    self.mesh = [[DHBlowSceneMesh alloc] initWithView:self.targetView containerView:self.containerView columnCount:self.targetView.bounds.size.width rowCount:self.targetView.bounds.size.height splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:NO];
    [self.mesh generateMeshData];
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithView:self.targetView];
}

- (void) drawFrame
{
    [super drawFrame];
    
    DHBlowSceneMesh *mesh = (DHBlowSceneMesh *)self.mesh;
    glUniform1f(minStartTimeLoc, mesh.minStartTime);
    glUniform1f(startTimeRangeLoc, mesh.maxStartTime - mesh.minStartTime);
    glUniform1f(blowingTimeRatioLoc, 0.3);
    glUniform1f(durationLoc, self.duration);
    glUniform1f(timeLoc, self.elapsedTime);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
