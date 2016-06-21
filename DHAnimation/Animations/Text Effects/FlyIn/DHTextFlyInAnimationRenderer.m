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
    GLuint offsetLoc, timeLoc, lifeTimeLoc;
}
@property (nonatomic) GLfloat offset;
@property (nonatomic) NSTimeInterval lifeTime;
@end

@implementation DHTextFlyInAnimationRenderer

- (void) setupExtraUniforms
{
    offsetLoc = glGetUniformLocation(program, "u_offset");
    timeLoc = glGetUniformLocation(program, "u_time");
    lifeTimeLoc = glGetUniformLocation(program, "u_lifeTime");
    self.offset = MAX(-self.attributedString.size.width * 0.618, -50);
    self.lifeTime = self.duration / ([self.attributedString length] + 1) * 2;
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
    self.mesh = [[DHTextFlyInMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView lifeTime:self.lifeTime];
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    glUniform1f(offsetLoc, self.offset);
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(lifeTimeLoc, self.lifeTime);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
