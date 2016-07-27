//
//  DHRotationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHRotationAnimationRenderer.h"
#import "DHSceneMesh.h"
#import "TextureHelper.h"
@interface DHRotationAnimationRenderer() {
    GLuint targetCenterLoc, rotationRadiusLoc, targetWidthLoc;
}
@end

@implementation DHRotationAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectRotationVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectRotationFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
    targetCenterLoc = glGetUniformLocation(program, "u_targetCenter");
    rotationRadiusLoc = glGetUniformLocation(program, "u_rotationRadius");
    targetWidthLoc = glGetUniformLocation(program, "u_targetWidth");
}

- (void) setupMeshes
{
    self.mesh = [DHSceneMeshFactory sceneMeshForView:self.targetView containerView:self.containerView columnCount:self.columnCount rowCount:self.rowCount splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
    [self.mesh generateMeshData];
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithView:self.targetView rotate:YES];
}

- (void) drawFrame
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform2f(targetCenterLoc, self.targetView.center.x, self.targetView.center.y);
    glUniform1f(rotationRadiusLoc, self.rotationRadius);
    glUniform1f(percentLoc, self.percent);
    glUniform1f(eventLoc, self.event);
    glUniform1f(directionLoc, self.direction);
    glUniform1f(targetWidthLoc, self.targetView.frame.size.width);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft), @(DHAllowedAnimationDirectionRight)];
}

- (CGFloat) rotationRadius
{
    if (!_rotationRadius) {
        _rotationRadius = 300;
    }
    return _rotationRadius;
}
@end
