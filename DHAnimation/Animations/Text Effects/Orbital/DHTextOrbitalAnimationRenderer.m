//
//  DHTextOrbitalAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextOrbitalAnimationRenderer.h"
#import "DHTextOrbitalMesh.h"
@interface DHTextOrbitalAnimationRenderer() {
    GLuint centerLoc, rotationLoc;
}
@end

@implementation DHTextOrbitalAnimationRenderer

- (void) setupExtraUniforms
{
    centerLoc = glGetUniformLocation(program, "u_center");
    rotationLoc = glGetUniformLocation(program, "u_rotation");
}

- (NSString *) vertexShaderName
{
    return @"TextOrbitalVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"TextOrbitalFragment.glsl";
}

- (void) setupMeshes
{
    self.mesh = [[DHTextOrbitalMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView];
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    glUniform2f(centerLoc, self.origin.x + self.attributedString.size.width / 2, self.containerView.frame.size.height - self.origin.y - self.attributedString.size.height / 2);
    glUniform1f(rotationLoc, M_PI * 6);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
