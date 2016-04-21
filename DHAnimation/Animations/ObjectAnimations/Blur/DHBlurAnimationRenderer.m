//
//  DHBlurAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBlurAnimationRenderer.h"
#import "SceneMesh.h"
#import "TextureHelper.h"
@interface DHBlurAnimationRenderer() {
    GLuint scaleLoc, resolutionLoc, elapsedTimeLoc;
}
@property (nonatomic, strong) SceneMesh *mesh;
@end

@implementation DHBlurAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    scaleLoc = glGetUniformLocation(program, "u_scale");
    resolutionLoc = glGetUniformLocation(program, "u_resolution");
    elapsedTimeLoc = glGetUniformLocation(program, "u_elapsedTime");
}

- (void) setupMeshes
{
    self.mesh = [[SceneMesh alloc] initWithView:self.targetView containerView:self.containerView columnCount:self.targetView.frame.size.width rowCount:self.targetView.frame.size.height splitTexturesOnEachGrid:YES columnMajored:YES];
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform2f(scaleLoc, 0, 1.f / self.targetView.frame.size.height);
    glUniform2f(resolutionLoc, self.targetView.frame.size.width, self.targetView.frame.size.height);
    glUniform1f(elapsedTimeLoc, self.elapsedTime);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (NSString *) vertexShaderName
{
    return @"BlurAnimationVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"BlurAnimationFragment.glsl";
}

@end
