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
    GLuint offsetLoc, durationLoc, amplitudeLoc;
}
@property (nonatomic) GLfloat offset;

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
    self.offset = -(self.origin.x + self.attributedString.size.width);
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
    glUniform1f(durationLoc, self.duration * 0.9);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
