//
//  DHResolvingDoorRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/24/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHResolvingDoorTransitionRenderer.h"
@interface DHResolvingDoorTransitionRenderer() {
    GLuint srcPrepareTimeRatio, dstPrepareTimeRatio;
    GLuint srcPauseRatio, dstPauseRatio;
}

@end

#define PREPARE_RATIO 0.15
#define PAUSE_RATIO 0.05
@implementation DHResolvingDoorTransitionRenderer

#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"ResolvingDoorSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"ResolvingDoorSourceFragment.glsl";
        self.dstVertexShaderFileName = @"ResolvingDoorDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"ResolvingDoorDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Override
- (void)setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcPrepareTimeRatio = glGetUniformLocation(srcProgram, "u_prepareRatio");
    srcPauseRatio = glGetUniformLocation(srcProgram, "u_pauseRatio");
    
    glUseProgram(dstProgram);
    dstPrepareTimeRatio = glGetUniformLocation(dstProgram, "u_prepareRatio");
    dstPauseRatio = glGetUniformLocation(dstProgram, "u_pauseRatio");
}


- (void) setupDrawingContext
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcPrepareTimeRatio, PREPARE_RATIO);
    glUniform1f(srcPauseRatio, PAUSE_RATIO);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstPrepareTimeRatio, PREPARE_RATIO);
    glUniform1f(dstPauseRatio, PAUSE_RATIO);
}

- (void) populatePercent
{
    self.percent = self.elapsedTime / self.duration;
    if (self.percent > PREPARE_RATIO + PAUSE_RATIO) {
        GLfloat elapsed = self.elapsedTime - self.duration * (PREPARE_RATIO + PAUSE_RATIO);
        GLfloat populatedTime = self.timingFunction(elapsed * 1000, 0.f, self.duration * (1 - PREPARE_RATIO - PAUSE_RATIO), self.duration * (1 - PREPARE_RATIO - PAUSE_RATIO) * 1000);
        self.percent = PREPARE_RATIO + PAUSE_RATIO + populatedTime / self.duration;
    }
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft)];
}
@end
