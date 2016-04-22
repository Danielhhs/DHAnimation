//
//  DHPivotAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHPivotAnimationRenderer.h"
@interface DHPivotAnimationRenderer() {
    GLuint anchorPointLoc, yOffsetLoc;
}

@end

@implementation DHPivotAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    anchorPointLoc = glGetUniformLocation(program, "u_anchorPoint");
    yOffsetLoc = glGetUniformLocation(program, "u_yOffset");
}

- (NSString *) vertexShaderName
{
    return @"ObjectPivotVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectPivotFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform3f(anchorPointLoc, self.targetView.frame.origin.x, self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame), 0);
    glUniform1f(yOffsetLoc, self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame));
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
