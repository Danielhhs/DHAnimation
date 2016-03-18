//
//  PushRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/17/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "PushRenderer.h"

@interface PushRenderer () {
    GLuint srcDirectionLoc, dstDirectionLoc;
    GLuint srcScreenWidthLoc, dstScreenWidthLoc;
}

@end

@implementation PushRenderer

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"PushSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"PushSourceFragment.glsl";
        self.dstVertexShaderFileName = @"PushDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"PushDestinationFragment.glsl";
    }
    return self;
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcDirectionLoc = glGetUniformLocation(srcProgram, "u_direction");
    srcScreenWidthLoc = glGetUniformLocation(srcProgram, "u_screenWidth");
    
    glUseProgram(dstProgram);
    dstDirectionLoc = glGetUniformLocation(dstProgram, "u_direction");
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1i(srcDirectionLoc, self.direction);
    glUniform1f(srcScreenWidthLoc, self.animationView.bounds.size.width);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1i(dstDirectionLoc, self.direction);
    glUniform1f(dstScreenWidthLoc, self.animationView.bounds.size.width);
}

@end
