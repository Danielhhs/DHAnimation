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
    GLuint offsetLoc, durationLoc, amplitudeLoc, cycleLoc, singleCycleDurationLoc, gravityLoc, squishTimeLoc, squishFactorLoc, singleCharacterDurationLoc;
}
@property (nonatomic) GLfloat offset;
@property (nonatomic) GLfloat singleCycleDuration;
@property (nonatomic) GLfloat gravity;

@end


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
    squishTimeLoc = glGetUniformLocation(program, "u_squishTimeRatio");
    squishFactorLoc = glGetUniformLocation(program, "u_squishFactor");
    singleCharacterDurationLoc = glGetUniformLocation(program, "u_singleCharDuration");
    self.offset = -(self.origin.x + self.attributedString.size.width);
    if (self.direction == DHAnimationDirectionRightToLeft) {
        self.offset = self.containerView.frame.size.width - self.origin.x;
    }
    int numberOfPasses = fabs(self.offset) / self.cycleLength;
    self.cycleLength = fabs(self.offset / numberOfPasses);
    self.amplitude = self.attributedString.size.height * 2;
    self.singleCycleDuration = self.singleCharacterDuration / numberOfPasses;
    GLfloat t = self.singleCycleDuration / 2;
    self.gravity = 2 * self.amplitude / t / t;
}

- (void) setupMeshes
{
    DHTextDanceMesh *mesh = [[DHTextDanceMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView];
    mesh.duration = self.duration;
    mesh.direction = self.direction;
    mesh.singleCharacterDurationRatio = self.singleCharacterDuration / self.duration;
    self.mesh = mesh;
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    glUniform1f(offsetLoc, self.offset);
    glUniform1f(amplitudeLoc, self.amplitude);
    glUniform1f(durationLoc, self.duration);
    glUniform1f(cycleLoc, self.cycleLength);
    glUniform1f(singleCycleDurationLoc, self.singleCycleDuration);
    glUniform1f(gravityLoc, self.gravity);
    glUniform1f(squishTimeLoc, self.squishTimeRatio);
    glUniform1f(squishFactorLoc, self.squishFactor);
    glUniform1f(singleCharacterDurationLoc, self.singleCharacterDuration);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (GLfloat) cycleLength
{
    if (!_cycleLength) {
        _cycleLength = MAX(100, self.offset / 3);
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

- (NSTimeInterval) squishTimeRatio
{
    if (!_squishTimeRatio) {
        _squishTimeRatio = 0.15;
    }
    return _squishTimeRatio;
}

- (CGFloat) squishFactor
{
    if (!_squishFactor) {
        _squishFactor = 0.8;
    }
    return _squishFactor;
}

- (NSTimeInterval) singleCharacterDuration
{
    if (!_singleCharacterDuration) {
        _singleCharacterDuration = 0.8 * self.duration;
    }
    return _singleCharacterDuration;
}

- (GLKVector2) expandWithTime:(GLfloat)time
{
    GLKVector2 position = GLKVector2Make(100, 369);
    GLKVector2 center = GLKVector2Make(113.763, 336);
    float percent = time / (self.singleCycleDuration * self.squishTimeRatio);
    GLKVector2 centerToPosition = GLKVector2Subtract( position, center);
    float factor = (1.f - 0.618) * percent + 0.618;
    GLKVector2 offset = centerToPosition;
    offset.x = centerToPosition.x * (1.f / factor);
    if (position.y > center.y) {
        offset.y = centerToPosition.y * (factor - 1.f) * 2.f;
    }
    return offset;
}

- (GLKVector2) squishWithTime:(GLfloat)time
{
    GLKVector2 position = GLKVector2Make(100, 369);
    GLKVector2 center = GLKVector2Make(113.763, 336);
    float percent = time / (self.singleCycleDuration * self.squishTimeRatio);
    GLKVector2 centerToPosition = GLKVector2Subtract( position, center);
    float factor = -(1.f - 0.618) * percent + 1.f;
    GLKVector2 offset = centerToPosition;
    offset.x = centerToPosition.x * (1.f / factor);
    if (position.y > center.y) {
        offset.y = centerToPosition.y * (factor - 1.f) * 2.f;
    }

    return offset;
}


@end
