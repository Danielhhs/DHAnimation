//
//  RevealRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/18/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHRevealRenderer.h"
@interface DHRevealRenderer() {
    GLuint srcScreenWidthLoc;
}
@end

@implementation DHRevealRenderer

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"RevealSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"RevealSourceFragment.glsl";
        self.dstVertexShaderFileName = @"RevealDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"RevealDestinationFragment.glsl";
    }
    return self;
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcScreenWidthLoc = glGetUniformLocation(srcProgram, "u_screenWidth");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcScreenWidthLoc, self.animationView.bounds.size.width);
}

@end
