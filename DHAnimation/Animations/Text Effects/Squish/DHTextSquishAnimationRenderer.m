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
    GLuint offsetLoc, durationLoc, numberOfCyclesLoc, coeffcientLoc, cycleLoc, gravityLoc, squishLoc;
}
@property (nonatomic) GLfloat offset;
@property (nonatomic) NSInteger numberOfCycles;
@property (nonatomic) GLfloat coeffient;
@property (nonatomic) NSTimeInterval cycle;
@property (nonatomic) GLfloat gravity;
@end

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
    numberOfCyclesLoc = glGetUniformLocation(program, "u_numberOfCycles");
    coeffcientLoc = glGetUniformLocation(program, "u_coefficient");
    gravityLoc = glGetUniformLocation(program, "u_gravity");
    cycleLoc = glGetUniformLocation(program, "u_cycle");
    squishLoc = glGetUniformLocation(program, "u_squish");
    self.offset = self.origin.y + self.attributedString.size.height;
    self.cycle = 0.618;
    self.gravity = 2 * self.offset / ((self.cycle / 2) * (self.cycle / 2));
    self.numberOfCycles = ceil(self.duration / self.cycle * 2) + 1;
    self.coeffient = 1.f;
    for (int i = 1; i <= 20; i++) {
        self.coeffient -= 0.05;
        if (pow(self.coeffient, self.numberOfCycles - 1) < 0.05) {
            break;
        }
    }
}

- (void) setupMeshes
{
    DHTextSquishMesh *mesh = [[DHTextSquishMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView];
    mesh.duration = self.duration;
    self.mesh = mesh;
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    glUniform1f(offsetLoc, self.offset);
    glUniform1f(durationLoc, self.duration);
    glUniform1f(numberOfCyclesLoc, self.numberOfCycles);
    glUniform1f(coeffcientLoc, self.coeffient);
    glUniform1f(cycleLoc, self.cycle);
    glUniform1f(gravityLoc, self.gravity);
    glUniform1f(squishLoc, self.squish);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
