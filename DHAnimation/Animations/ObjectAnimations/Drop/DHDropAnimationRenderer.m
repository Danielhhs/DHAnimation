//
//  DHDropAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHDropAnimationRenderer.h"
@interface DHDropAnimationRenderer() {
    GLuint targetPositionLoc;
}
@end

@implementation DHDropAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    targetPositionLoc = glGetUniformLocation(program, "u_targetPosition");
}

- (NSString *) vertexShaderName
{
    return @"ObjectDropVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectDropFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform1f(targetPositionLoc, CGRectGetMaxY(self.targetView.frame));
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}


- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionTop)];
}
@end
