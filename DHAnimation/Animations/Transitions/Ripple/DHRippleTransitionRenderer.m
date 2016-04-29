//
//  DHRippleRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/24/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHRippleTransitionRenderer.h"
#import "TextureHelper.h"
@interface DHRippleTransitionRenderer() {
    GLuint srcResolutionLoc, srcTimeLoc;
}
@end

@implementation DHRippleTransitionRenderer
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"RippleSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"RippleSourceFragment.glsl";
        self.dstVertexShaderFileName = @"RippleDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"RippleDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Override
- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcResolutionLoc = glGetUniformLocation(srcProgram, "u_resolution");
    srcTimeLoc = glGetUniformLocation(srcProgram, "u_time");
}

- (void) setupTextureWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    srcTexture = [TextureHelper setupTextureWithView:fromView flipHorizontal:NO flipVertical:YES];
    dstTexture = [TextureHelper setupTextureWithView:toView];
}

- (void) setupUniformsForSourceProgram
{
    glUniform2f(srcResolutionLoc, self.animationView.bounds.size.width * 2, self.animationView.bounds.size.height * 2);
    glUniform1f(srcTimeLoc, self.percent * self.duration);
}

- (void) setupDrawingContext
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (NSArray *) allowedDirections
{
    return nil;
}
@end
