//
//  DHTextSquishAnimaitonRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextSquishAnimationRenderer.h"
#import "DHTextSquishMesh.h"

@interface DHTextSquishAnimationRenderer () {
    GLuint offsetLoc, durationLoc, coeffcientLoc, cycleLoc, gravityLoc, squishTimeLoc, squishFactorLoc, numberOfCyclesLoc;
}
@property (nonatomic) GLfloat offset;
@property (nonatomic) GLfloat coeffient;
@property (nonatomic) GLfloat gravity;
@property (nonatomic) NSTimeInterval lifeTime;

@end

#define SQUISH_TIME_RATIO 0.9

@implementation DHTextSquishAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"TextSquishVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"TextSquishFragment.glsl";
}

- (void) setupExtraUniforms
{
    offsetLoc = glGetUniformLocation(program, "u_offset");
    durationLoc = glGetUniformLocation(program, "u_duration");
    coeffcientLoc = glGetUniformLocation(program, "u_coefficient");
    gravityLoc = glGetUniformLocation(program, "u_gravity");
    cycleLoc = glGetUniformLocation(program, "u_cycle");
    squishFactorLoc = glGetUniformLocation(program, "u_squishFactor");
    squishTimeLoc = glGetUniformLocation(program, "u_squishTime");
    numberOfCyclesLoc = glGetUniformLocation(program, "u_numberOfCycles");
    self.offset = self.origin.y + self.attributedString.size.height + 5;
    GLfloat fallTime = (self.cycle) / 2 - self.squishTime;
    self.gravity = 2 * self.offset / fallTime / fallTime;
    self.coeffient = 1.f;
    for (int i = 1; i <= 20; i++) {
        self.coeffient -= 0.05;
        if (pow(self.coeffient, self.numberOfCycles - 1) < 0.05) {
            break;
        }
    }
    NSTimeInterval cycle = self.cycle;
    self.lifeTime = cycle;
    for (int i = 0; i < self.numberOfCycles / 2 - 1; i++) {
        cycle *= self.coeffient;
        self.lifeTime += cycle;
    }
}

- (void) setupMeshes
{
    DHTextSquishMesh *mesh = [[DHTextSquishMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView];
    mesh.duration = self.duration;
    mesh.squishTimeRatio = self.lifeTime / self.duration;
    self.mesh = mesh;
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    glUniform1f(offsetLoc, self.offset);
    glUniform1f(durationLoc, self.duration);
    glUniform1f(coeffcientLoc, self.coeffient);
    glUniform1f(cycleLoc, self.cycle);
    glUniform1f(gravityLoc, self.gravity);
    glUniform1f(squishTimeLoc, self.squishTime);
    glUniform1f(squishFactorLoc, self.squishFactor);
    glUniform1f(numberOfCyclesLoc, self.numberOfCycles);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (void) setDuration:(NSTimeInterval)duration
{
    [super setDuration:duration];
    if (self.squishFactor == 0) {
        self.squishFactor = 0.618;
    }
    if (self.cycle == 0) {
        self.cycle = duration * 0.3;
    }
    if (self.squishTime == 0) {
        self.squishTime = 0.15 * self.cycle;
    } if (self.numberOfCycles == 0) {
        self.numberOfCycles = 10;
    }
}

@end
