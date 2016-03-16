//
//  GridRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/15/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "GridRenderer.h"
@interface GridRenderer() {
    GLuint srcScreenWidthLoc, dstScreenWidthLoc;
    GLuint srcDirectionLoc, dstDirectionLoc;
}
@end

@implementation GridRenderer
#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"GridSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"GridSourceFragment.glsl";
        self.dstVertexShaderFileName = @"GridDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"GridDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Override
- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcScreenWidthLoc = glGetUniformLocation(srcProgram, "u_screenWidth");
    srcDirectionLoc = glGetUniformLocation(srcProgram, "u_direction");
    
    glUseProgram(dstProgram);
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
    dstDirectionLoc = glGetUniformLocation(dstProgram, "u_direction");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcScreenWidthLoc, self.animationView.bounds.size.width);
    glUniform1i(srcDirectionLoc, self.direction);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstScreenWidthLoc, self.animationView.bounds.size.width);
    glUniform1i(dstDirectionLoc, self.direction);
}
@end
