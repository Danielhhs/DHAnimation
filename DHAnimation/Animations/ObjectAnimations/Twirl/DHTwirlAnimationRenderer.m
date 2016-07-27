//
//  DHTwirlAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/23/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTwirlAnimationRenderer.h"
#import "TextureHelper.h"

@interface DHTwirlAnimationRenderer() {
    GLuint centerLoc, resolutionLoc;
}

@end

@implementation DHTwirlAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectTwirlVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectTwirlFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
    centerLoc = glGetUniformLocation(program, "u_center");
    resolutionLoc = glGetUniformLocation(program, "u_resolution");
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform2f(centerLoc, CGRectGetMidX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMidY(self.targetView.frame));
    glUniform2f(resolutionLoc, self.targetView.frame.size.width, self.targetView.frame.size.height);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (void) setupMeshes
{
    self.mesh = [DHSceneMeshFactory sceneMeshForView:self.targetView containerView:self.containerView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
    [self.mesh generateMeshData];
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithView:self.targetView rotate:YES];
}


- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft)];
}
@end
