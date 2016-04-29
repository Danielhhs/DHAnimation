//
//  DHRotateDismissRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/23/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSpinDismissTransitionRenderer.h"

@interface DHSpinDismissTransitionRenderer () {
    GLuint screenWidthLoc, screenHeightLoc, spinRatioLoc;
}

@end

#define SPIN_RATIO 0.5

@implementation DHSpinDismissTransitionRenderer
#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"SpinDismissVertex.glsl";
        self.srcFragmentShaderFileName = @"SpinDismissFragment.glsl";
    }
    return self;
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    [self setupMvpMatrixWithView:view];
    
    [self prepareToDrawSourceFace];
    glUseProgram(srcProgram);
    glUniform1f(srcPercentLoc, self.percent);
    glUniform1i(srcDirectionLoc, self.direction);
    [self setupUniformsForSourceProgram];
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
}

#pragma mark - Override
- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    screenWidthLoc = glGetUniformLocation(srcProgram, "u_screenWidth");
    screenHeightLoc = glGetUniformLocation(srcProgram, "u_screenHeight");
    spinRatioLoc = glGetUniformLocation(srcProgram, "u_spinRatio");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(screenWidthLoc, self.animationView.bounds.size.width);
    glUniform1f(screenHeightLoc, self.animationView.bounds.size.height);
    glUniform1f(spinRatioLoc, SPIN_RATIO);
}

- (void) populatePercent
{
    if (self.elapsedTime < self.duration * SPIN_RATIO) {
        self.percent = self.elapsedTime / self.duration;
    } else {
        self.percent = SPIN_RATIO + NSBKeyframeAnimationFunctionEaseOutCubic((self.elapsedTime - self.duration * SPIN_RATIO) * 1000, 0, self.duration * (1 - SPIN_RATIO), self.duration * (1 - SPIN_RATIO) * 1000);
    }
}

- (NSArray *) allowedDirections
{
    return nil;
}
@end
