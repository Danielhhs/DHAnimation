//
//  DHSparkleEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSparkleEffect.h"
#import "OpenGLHelper.h"
@interface DHSparkleEffect() {
}

@end

@implementation DHSparkleEffect

- (NSString *) vertexShaderFileName
{
    return @"SparkleVertex.glsl";
}

- (NSString *) fragmentShaderFileName
{
    return @"SparkleFragment.glsl";
}

- (void) setupExtraUniforms
{
}

@end
