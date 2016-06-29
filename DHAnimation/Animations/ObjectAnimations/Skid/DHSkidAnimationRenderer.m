//
//  DHSkidAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/23/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSkidAnimationRenderer.h"
#import "DHDustEffect.h"

@interface DHSkidAnimationRenderer () {
    GLuint offsetLoc, centerLoc, resolutionLoc, slidingTimeLoc;
}
@property (nonatomic, strong) DHDustEffect *effect;
@property (nonatomic) GLfloat offset;
@end

#define SLIDING_TIME_RATIO 0.3

@implementation DHSkidAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    offsetLoc = glGetUniformLocation(program, "u_offset");
    centerLoc = glGetUniformLocation(program, "u_center");
    resolutionLoc = glGetUniformLocation(program, "u_resolution");
    slidingTimeLoc = glGetUniformLocation(program, "u_slidingTime");
    if (self.direction == DHAnimationDirectionLeftToRight) {
        self.offset = CGRectGetMaxX(self.targetView.frame);
    } else {
        self.offset = self.containerView.frame.size.width - CGRectGetMinX(self.targetView.frame);
    }
}

- (NSString *) vertexShaderName
{
    return @"ObjectSkidVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectSkidFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    
    glUniform1f(offsetLoc, self.offset);
    glUniform2f(centerLoc, CGRectGetMidX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMidY(self.targetView.frame));
    glUniform2f(resolutionLoc, self.targetView.frame.size.width, self.targetView.frame.size.height);
    glUniform1f(slidingTimeLoc, SLIDING_TIME_RATIO);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
    
    [self.effect draw];
}

- (void) setupEffects
{
    self.effect = [[DHDustEffect alloc] initWithContext:self.context];
    if (self.direction == DHAnimationDirectionLeftToRight) {
        self.effect.direction = DHDustEmissionDirectionRight;
        self.effect.emitPosition = GLKVector3Make(CGRectGetMaxX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame), self.targetView.frame.size.height / 2);
    } else {
        self.effect.direction = DHDustEmissionDirectionLeft;
        self.effect.emitPosition = GLKVector3Make(CGRectGetMinX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame), self.targetView.frame.size.height / 2);
    }
    self.effect.dustWidth = self.targetView.frame.size.width;
    self.effect.emissionRadius = self.targetView.frame.size.width * 1.5;
    self.effect.timingFuntion = DHTimingFunctionEaseOutCubic;
    self.effect.mvpMatrix = mvpMatrix;
    if (self.event == DHAnimationEventBuiltIn) {
        self.effect.startTime = self.duration * SLIDING_TIME_RATIO;
    } else {
        self.effect.startTime = 0.f;
    }
    self.effect.duration = self.duration;
    [self.effect generateParticlesData];
}

- (void) updateAdditionalComponents
{
    [self.effect updateWithElapsedTime:self.elapsedTime percent:self.percent];
}


- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft)];
}

- (void) tearDownSpecificGLResources
{
    [self.effect tearDownGL];
}
@end
