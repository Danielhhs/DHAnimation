//
//  DHBlurAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBlurAnimationRenderer.h"
#import "TextureHelper.h"
@interface DHBlurAnimationRenderer() {
    GLuint radiusLoc, resolutionLoc, elapsedTimeLoc, directionLoc;
}
@end

@implementation DHBlurAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    radiusLoc = glGetUniformLocation(program, "u_radius");
    resolutionLoc = glGetUniformLocation(program, "u_resolution");
    elapsedTimeLoc = glGetUniformLocation(program, "u_elapsedTime");
    directionLoc = glGetUniformLocation(program, "u_dir");
}

- (void) setupMeshes
{
    self.mesh = [DHSceneMeshFactory sceneMeshForView:self.targetView containerView:self.containerView columnCount:self.targetView.frame.size.width rowCount:self.targetView.frame.size.height splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:NO];
    [self.mesh generateMeshData];
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform1f(radiusLoc, 7.f);
    glUniform1f(resolutionLoc, 3.f);
    glUniform2f(directionLoc, 1.f, 0.f);
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


- (NSArray *) allowedDirections
{
    return nil;
}
@end
