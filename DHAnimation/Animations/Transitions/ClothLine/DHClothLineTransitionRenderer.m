//
//  ClothLineRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHClothLineTransitionRenderer.h"

@interface DHClothLineTransitionRenderer() {
    GLuint srcScreenWidthLoc, dstScreenWidthLoc;
    GLuint srcScreenHeightLoc, dstScreenHeightLoc;
    GLuint dstDurationLoc;
}
@end

@implementation DHClothLineTransitionRenderer

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
    
    glUseProgram(dstProgram);
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
    dstScreenHeightLoc = glGetUniformLocation(dstProgram, "u_screenHeight");
    dstDurationLoc = glGetUniformLocation(dstProgram, "u_duration");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcScreenWidthLoc, self.animationView.bounds.size.width);
    glUniform1f(srcScreenHeightLoc, self.animationView.bounds.size.height);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstScreenWidthLoc, self.animationView.bounds.size.width);
    glUniform1f(dstScreenHeightLoc, self.animationView.bounds.size.height);
    glUniform1f(dstDurationLoc, self.duration);
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft), @(DHAllowedAnimationDirectionRight)];
}
@end
