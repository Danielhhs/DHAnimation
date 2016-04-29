//
//  DHScaleAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHScaleAnimationRenderer.h"
@interface DHScaleAnimationRenderer() {
    GLuint centerLoc, resolutionLoc;
}

@end

@implementation DHScaleAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    centerLoc = glGetUniformLocation(program, "u_center");
    resolutionLoc = glGetUniformLocation(program, "u_resolution");
}

- (NSString *) vertexShaderName
{
    return @"ObjectScaleVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectScaleFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform2f(centerLoc, CGRectGetMidX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMidY(self.targetView.frame));
    glUniform2f(resolutionLoc, self.targetView.frame.size.width, self.targetView.frame.size.height);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (NSArray *) allowedDirections
{
    return nil;
}
@end
