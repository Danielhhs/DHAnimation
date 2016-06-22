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
    GLuint timeLoc;
}
@property (nonatomic) GLfloat offset;
@end

@implementation DHTextFlyInAnimationRenderer

- (void) setupExtraUniforms
{
    timeLoc = glGetUniformLocation(program, "u_time");
    self.offset = MAX(-self.attributedString.size.width * 0.618, -50);
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
    self.mesh = [[DHTextFlyInMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView duration:self.duration];
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    glUniform1f(timeLoc, self.elapsedTime);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
