//
//  ClothLineRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "ClothLineRenderer.h"

@interface ClothLineRenderer() {
    GLuint srcScreenWidthLoc, dstScreenWidthLoc;
    GLuint srcScreenHeightLoc, dstScreenHeightLoc;
    GLuint srcDirectionLoc, dstDirectionLoc;
    GLuint dstDurationLoc;
}
@end

@implementation ClothLineRenderer

#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"ClothLineSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"ClothLineSourceFragment.glsl";
        self.dstVertexShaderFileName = @"ClothLineDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"ClothLineDestinationFragment.glsl";
    }
    return self;
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcScreenWidthLoc = glGetUniformLocation(srcProgram, "u_screenWidth");
    srcScreenHeightLoc = glGetUniformLocation(srcProgram, "u_screenHeight");
    srcDirectionLoc = glGetUniformLocation(srcProgram, "u_direction");
    
    glUseProgram(dstProgram);
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
    dstScreenHeightLoc = glGetUniformLocation(dstProgram, "u_screenHeight");
    dstDurationLoc = glGetUniformLocation(dstProgram, "u_duration");
    dstDirectionLoc = glGetUniformLocation(dstProgram, "u_direction");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcScreenWidthLoc, self.animationView.bounds.size.width);
    glUniform1f(srcScreenHeightLoc, self.animationView.bounds.size.height);
    glUniform1i(srcDirectionLoc, self.direction);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstScreenWidthLoc, self.animationView.bounds.size.width);
    glUniform1f(dstScreenHeightLoc, self.animationView.bounds.size.height);
    glUniform1i(dstDirectionLoc, self.direction);
    glUniform1f(dstDurationLoc, self.duration);
}
@end
