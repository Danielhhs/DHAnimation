//
//  DHTextFlyInAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextFlyInAnimationRenderer.h"
#import "DHTextFlyInMesh.h"

@interface DHTextFlyInAnimationRenderer () {
    GLuint durationLoc;
}
@end

@implementation DHTextFlyInAnimationRenderer

- (void) setupExtraUniforms
{
    durationLoc = glGetUniformLocation(program, "u_duration");
}

- (NSString *) vertexShaderName
{
    return @"TextFlyInVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"TextFlyInFragment.glsl";
}

- (void) setupMeshes
{
    DHTextFlyInMesh *mesh = [[DHTextFlyInMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView duration:self.duration];
    mesh.direction = self.direction;
    mesh.event = self.event;
    self.mesh = mesh;
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    glUniform1f(durationLoc, self.duration);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
