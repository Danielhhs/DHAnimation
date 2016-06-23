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
    GLuint timeLoc, offsetLoc, durationLoc;
}
@property (nonatomic) GLfloat offset;
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
    timeLoc = glGetUniformLocation(program, "u_time");
    offsetLoc = glGetUniformLocation(program, "u_offset");
    durationLoc = glGetUniformLocation(program, "u_duration");
    self.offset = self.origin.y + self.attributedString.size.height;
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
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(offsetLoc, self.offset);
    glUniform1f(durationLoc, self.duration);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
