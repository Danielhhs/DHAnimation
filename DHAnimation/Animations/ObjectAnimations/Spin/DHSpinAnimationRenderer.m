//
//  DHSpinAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSpinAnimationRenderer.h"
@interface DHSpinAnimationRenderer() {
    GLuint centerLoc;
}
@end

@implementation DHSpinAnimationRenderer


- (void) setupGL
{
    [super setupGL];
    centerLoc = glGetUniformLocation(program, "u_center");
}

- (NSString *)vertexShaderName
{
    return @"ObjectSpinVertex.glsl";
}

-(NSString *) fragmentShaderName
{
    return @"ObjectSpinFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform2f(centerLoc, CGRectGetMidX(self.targetView.frame), CGRectGetMidY(self.targetView.frame));
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft)];
}
@end
