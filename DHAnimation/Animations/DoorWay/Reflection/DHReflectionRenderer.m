//
//  DHReflectionRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/23/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHReflectionRenderer.h"

#define MAX_ROTATION M_PI_4

@interface DHReflectionRenderer () {
    GLuint srcScreenWidthLoc, dstScreenWidthLoc;
    GLuint srcMaxRotationLoc, dstMaxRotationLoc;
}

@end

@implementation DHReflectionRenderer
#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"ReflectionSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"ReflectionSourceFragment.glsl";
        self.dstVertexShaderFileName = @"ReflectionDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"ReflectionDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Override
- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcScreenWidthLoc = glGetUniformLocation(srcProgram, "u_screenWidth");
    srcMaxRotationLoc = glGetUniformLocation(srcProgram, "u_maxRotation");
    
    glUseProgram(dstProgram);
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
    dstMaxRotationLoc = glGetUniformLocation(dstProgram, "u_maxRotation");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcScreenWidthLoc, self.animationView.bounds.size.width);
    glUniform1f(srcMaxRotationLoc, MAX_ROTATION);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstScreenWidthLoc, self.animationView.bounds.size.width);
    glUniform1f(dstMaxRotationLoc, MAX_ROTATION);
}

@end
