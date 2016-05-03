//
//  DHFlipRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFlipTransitionRenderer.h"
#import "TextureHelper.h"
@interface DHFlipTransitionRenderer () {
    GLuint srcScreenWidthLoc, srcScreenHeightLoc;
    GLuint dstScreenHeightLoc, dstScreenWidthLoc;
}

@end

@implementation DHFlipTransitionRenderer

#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"FlipSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"FlipSourceFragment.glsl";
        self.dstVertexShaderFileName = @"FlipDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"FlipDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Override
- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcScreenWidthLoc = glGetUniformLocation(srcProgram, "u_screenWidth");
    srcScreenHeightLoc = glGetUniformLocation(srcProgram, "u_screenHeight");
    
    glUseProgram(dstProgram);
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
    dstScreenHeightLoc = glGetUniformLocation(dstProgram, "u_screenHeight");
}

- (void) setupTextureWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    srcTexture = [TextureHelper setupTextureWithView:fromView];
    dstTexture = [TextureHelper setupTextureWithView:toView flipHorizontal:YES];
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
}

- (void) prepareToDrawDestinationFace
{
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
}

- (void) prepareToDrawSourceFace
{
    glCullFace(GL_FRONT);
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionTop)];
}
@end
