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
    GLuint offsetLoc;
}
@property (nonatomic) GLfloat offset;
@end

@implementation DHTextFlyInAnimationRenderer

- (void) setupExtraUniforms
{
    offsetLoc = glGetUniformLocation(program, "u_offset");
    self.offset = MIN(self.attributedString.size.width * 0.618, 50);
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
    self.mesh = [[DHTextFlyInMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView];
}

- (void) drawFrame
{
    glUniform1f(offsetLoc, self.offset);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
