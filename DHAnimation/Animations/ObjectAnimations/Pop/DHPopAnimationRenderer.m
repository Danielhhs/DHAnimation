//
//  DHPopAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHPopAnimationRenderer.h"

@implementation DHPopAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectPopVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectPopFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    
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
