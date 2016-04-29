//
//  DHAnvilAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/26/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnvilAnimationRenderer.h"
#import "TextureHelper.h"
#import "DHDustEffect.h"
@interface DHAnvilAnimationRenderer () {
    GLuint yOffsetLoc, timeLoc, resolutionLoc;
}
@property (nonatomic, strong) DHDustEffect *effect;
@property (nonatomic) NSTimeInterval fallTime;
@end

@implementation DHAnvilAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    yOffsetLoc = glGetUniformLocation(program, "u_yOffset");
    timeLoc = glGetUniformLocation(program, "u_time");
    resolutionLoc = glGetUniformLocation(program, "u_resolution");
    self.fallTime = 0.3;
}

- (NSString *) vertexShaderName
{
    return @"ObjectAnvilVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectAnvilFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform2f(resolutionLoc, self.containerView.frame.size.width, self.containerView.frame.size.height);
    glUniform1f(yOffsetLoc, self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame));
    glUniform1f(timeLoc, self.elapsedTime);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    
    [self.mesh drawEntireMesh];
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    [self.effect draw];
}

- (void) setupEffects
{
    self.effect = [[DHDustEffect alloc] initWithContext:self.context];
    self.effect.emitPosition = GLKVector3Make(CGRectGetMinX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame), self.containerView.frame.size.height / 2);
    self.effect.emissionWidth = self.targetView.frame.size.width;
    self.effect.numberOfEmissions = 10;
    self.effect.direction = DHDustEmissionDirectionHorizontal;
    self.effect.dustWidth = self.targetView.frame.size.width * 1.5 / 2;
    self.effect.emissionRadius = self.targetView.frame.size.width * 1.5;
    self.effect.timingFuntion = DHTimingFunctionEaseOutExpo;
    self.effect.mvpMatrix = mvpMatrix;
    self.effect.startTime = self.fallTime;
    self.effect.duration = self.duration - self.fallTime;
    [self.effect generateParticlesData];
}

- (void) updateAdditionalComponents
{
    [self.effect updateWithElapsedTime:self.elapsedTime percent:self.percent];
}
@end
