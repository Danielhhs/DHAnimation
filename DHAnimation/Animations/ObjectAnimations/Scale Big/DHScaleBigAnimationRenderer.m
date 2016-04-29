//
//  DHScaleBigAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHScaleBigAnimationRenderer.h"

@interface DHScaleBigAnimationRenderer () {
    GLuint centerLoc;
}

@end
@implementation DHScaleBigAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectScaleBigVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectScaleBigFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
    centerLoc = glGetUniformLocation(program, "u_center");
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform2f(centerLoc, CGRectGetMidX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMidY(self.targetView.frame));
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
