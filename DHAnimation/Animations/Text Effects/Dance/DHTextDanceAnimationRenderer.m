//
//  DHTextDanceAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/23/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextDanceAnimationRenderer.h"
#import "DHTextDanceMesh.h"
@interface DHTextDanceAnimationRenderer() {
    GLuint offsetLoc, durationLoc, amplitudeLoc, cycleLoc, singleCycleDurationLoc, gravityLoc;
}
@property (nonatomic) GLfloat offset;
@property (nonatomic) GLfloat singleCycleDuration;
@property (nonatomic) GLfloat gravity;
@end

#define TIME_CYCLE_FOR_ONE_CHAR 0.7

@implementation DHTextDanceAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"TextDanceVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"TextDanceFragment.glsl";
}

- (void) setupExtraUniforms
{
    offsetLoc = glGetUniformLocation(program, "u_offset");
    durationLoc = glGetUniformLocation(program, "u_duration");
    amplitudeLoc = glGetUniformLocation(program, "u_amplitude");
    cycleLoc = glGetUniformLocation(program, "u_cycle");
    singleCycleDurationLoc = glGetUniformLocation(program, "u_singleCycleDuration");
    gravityLoc = glGetUniformLocation(program, "u_gravity");
    self.offset = -(self.origin.x + self.attributedString.size.width);
    int numberOfPasses = fabs(self.offset) / self.cycleLength;
    self.cycleLength = fabs(self.offset / numberOfPasses);
    self.amplitude = self.attributedString.size.height * 2;
    self.singleCycleDuration = self.duration * TIME_CYCLE_FOR_ONE_CHAR / numberOfPasses;
    GLfloat t = self.singleCycleDuration / 2;
    self.gravity = 2 * self.amplitude / t / t;
}

- (void) setupMeshes
{
    DHTextDanceMesh *mesh = [[DHTextDanceMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView];
    mesh.duration = self.duration;
    self.mesh = mesh;
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    glUniform1f(offsetLoc, self.offset);
    glUniform1f(amplitudeLoc, self.amplitude);
    glUniform1f(durationLoc, self.duration * TIME_CYCLE_FOR_ONE_CHAR);
    glUniform1f(cycleLoc, self.cycleLength);
    glUniform1f(singleCycleDurationLoc, self.singleCycleDuration);
    glUniform1f(gravityLoc, self.gravity);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (GLfloat) cycleLength
{
    if (!_cycleLength) {
        _cycleLength = 100;
    }
    return _cycleLength;
}

- (GLfloat) amplitude
{
    if (!_amplitude) {
        _amplitude = 75;
    }
    return _amplitude;
}
@end
