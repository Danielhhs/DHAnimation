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
    
    glUseProgram(dstProgram);
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcScreenWidthLoc, self.animationView.bounds.size.width);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstScreenWidthLoc, self.animationView.bounds.size.width);
}
@end
