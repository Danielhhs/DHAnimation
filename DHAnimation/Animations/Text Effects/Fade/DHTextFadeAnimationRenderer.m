//
//  DHTextFadeAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextFadeAnimationRenderer.h"
#import "DHTextFadeMesh.h"
@interface DHTextFadeAnimationRenderer() {
    GLuint timeLoc, durationLoc, singleCharacterFadeRatioLoc;
}

@end

@implementation DHTextFadeAnimationRenderer

- (void) setupExtraUniforms
{
    timeLoc = glGetUniformLocation(program, "u_time");
    durationLoc = glGetUniformLocation(program, "u_duration");
    singleCharacterFadeRatioLoc = glGetUniformLocation(program, "u_singleCharacterFadeRatio");
}

- (NSString *) vertexShaderName
{
    return @"TextFadeVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"TextFadeFragment.glsl";
}

- (void) setupMeshes
{
    DHTextFadeMesh *fadeMesh =  [[DHTextFadeMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView];
    fadeMesh.duration = self.duration;
    fadeMesh.singleCharacterFadingTimeRatio = 0.7;
    self.mesh = fadeMesh;
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(durationLoc, self.duration);
    glUniform1f(singleCharacterFadeRatioLoc, 0.7);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
