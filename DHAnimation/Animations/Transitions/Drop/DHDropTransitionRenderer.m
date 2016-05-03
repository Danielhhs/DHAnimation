//
//  DropRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/18/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHDropTransitionRenderer.h"

@interface DHDropTransitionRenderer () {
    GLuint dstScreenHeightLoc;
    GLuint dstDurationLoc;
}

@end

@implementation DHDropTransitionRenderer

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"DropSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"DropSourceFragment.glsl";
        self.dstVertexShaderFileName = @"DropDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"DropDestinationFragment.glsl";
    }
    return self;
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(dstProgram);
    dstScreenHeightLoc = glGetUniformLocation(dstProgram, "u_screenHeight");
    dstDurationLoc = glGetUniformLocation(dstProgram, "u_duration");
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstScreenHeightLoc, self.animationView.bounds.size.height);
    glUniform1f(dstDurationLoc, self.duration);
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    [self setupDrawingContext];
    [self setupMvpMatrixWithView:view];
    
    glUseProgram(srcProgram);
    glUniform1f(srcPercentLoc, self.percent);
    glUniform1i(srcDirectionLoc, self.direction);
    [self setupUniformsForSourceProgram];
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
    
    glUseProgram(dstProgram);
    glUniform1f(dstPercentLoc, self.percent);
    glUniform1i(dstDirectionLoc, self.direction);
    [self setupUniformsForDestinationProgram];
    [self.dstMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.dstMesh drawEntireMesh];
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionTop)];
}
@end
