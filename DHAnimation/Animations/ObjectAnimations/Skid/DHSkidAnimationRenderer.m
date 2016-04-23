//
//  DHSkidAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/23/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSkidAnimationRenderer.h"

@interface DHSkidAnimationRenderer () {
    GLuint offsetLoc, centerLoc, resolutionLoc;
}

@end

@implementation DHSkidAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    offsetLoc = glGetUniformLocation(program, "u_offset");
    centerLoc = glGetUniformLocation(program, "u_center");
    resolutionLoc = glGetUniformLocation(program, "u_resolution");
}

- (NSString *) vertexShaderName
{
    return @"ObjectSkidVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectSkidFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform1f(offsetLoc, CGRectGetMaxX(self.targetView.frame));
    glUniform2f(centerLoc, CGRectGetMidX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMidY(self.targetView.frame));
    glUniform2f(resolutionLoc, self.targetView.frame.size.width, self.targetView.frame.size.height);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
