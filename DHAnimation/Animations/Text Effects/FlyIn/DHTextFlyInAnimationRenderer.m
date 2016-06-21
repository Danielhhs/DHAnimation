//
//  DHTextFlyInAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextFlyInAnimationRenderer.h"

@implementation DHTextFlyInAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"TextFlyInVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"TextFlyInFragment.glsl";
}

- (void) setupMeshes
{
    
}

@end
