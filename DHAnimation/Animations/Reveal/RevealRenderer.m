//
//  RevealRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/18/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "RevealRenderer.h"
@interface RevealRenderer() {
    GLuint srcScreenWidthLoc;
}
@end

@implementation RevealRenderer

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
