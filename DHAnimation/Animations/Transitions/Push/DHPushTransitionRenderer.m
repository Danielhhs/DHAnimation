//
//  PushRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/17/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHPushTransitionRenderer.h"

@interface DHPushTransitionRenderer () {
    GLuint srcScreenWidthLoc, dstScreenWidthLoc;
}

@end

@implementation DHPushTransitionRenderer

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

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft), @(DHAllowedAnimationDirectionRight)];
}
@end
