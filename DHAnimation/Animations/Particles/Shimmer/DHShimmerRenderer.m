//
//  DHShimmerRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/30/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShimmerRenderer.h"
#import "TextureHelper.h"
@interface DHShimmerRenderer() {
    GLuint blurAmountLoc, blurStrengthLoc, blurScaleLoc;
    GLuint resolutionLoc, sampler2Loc;
    GLuint cellWidthLoc, cellHeightLoc;
}
@end

@implementation DHShimmerRenderer

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"ShimmerVertex.glsl";
        self.srcFragmentShaderFileName = @"ShimmerFragment.glsl";
        self.blurAmount = 5;
        self.blurScale = 0.02;
        self.blurStrength = 0.5;
    }
    return self;
}

- (void) setupTextureWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    srcTexture = [TextureHelper setupTextureWithView:fromView];
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    blurAmountLoc = glGetUniformLocation(srcProgram, "u_blurAmount");
    blurScaleLoc = glGetUniformLocation(srcProgram, "u_blurScale");
    blurStrengthLoc = glGetUniformLocation(srcProgram, "u_blurStrength");
    resolutionLoc = glGetUniformLocation(srcProgram, "u_resolution");
    sampler2Loc = glGetUniformLocation(srcProgram, "s_tex2");
    cellWidthLoc = glGetUniformLocation(srcProgram, "u_cellWidth");
    cellHeightLoc = glGetUniformLocation(srcProgram, "u_cellHeight");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1i(blurAmountLoc, self.blurAmount);
    glUniform1f(blurScaleLoc, self.blurScale);
    glUniform1f(blurStrengthLoc, self.blurStrength);
    glUniform2f(resolutionLoc, self.animationView.bounds.size.width, self.animationView.bounds.size.height);
    glUniform1i(sampler2Loc, 1);
    glUniform1f(cellWidthLoc, self.animationView.bounds.size.width);
    glUniform1f(cellHeightLoc, self.animationView.bounds.size.height);
}

- (void) updateMeshesAndUniforms
{
    self.blurScale = -1 * fabs(sinf(M_PI * 2 * self.percent) * 0.02);
    self.blurStrength = -1 * fabs(sinf(M_PI * 2 * self.percent));
}

@end
