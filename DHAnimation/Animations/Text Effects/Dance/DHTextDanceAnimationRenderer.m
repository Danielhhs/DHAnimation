//
//  DHTextDanceAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/23/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextDanceAnimationRenderer.h"
@interface DHTextDanceAnimationRenderer() {
    GLuint offsetLoc;
}
@end

@implementation DHTextDanceAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"TextDanceVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"TextDanceFragment.glsl";
}

- (void) setupExtraUniforms
{
    
}

@end
