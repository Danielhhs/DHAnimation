//
//  DHCompressAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 5/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHCompressAnimationRenderer.h"
#import "TextureHelper.h"

@interface DHCompressAnimationRenderer () {
    GLuint showRangeLoc;
}

@end

@implementation DHCompressAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectCompressVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectCompressFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
    showRangeLoc = glGetUniformLocation(program, "u_showRange");
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

- (void) drawFrame
{
    [super drawFrame];
    
    GLfloat center = self.containerView.frame.size.height - CGRectGetMidY(self.targetView.frame);
    GLfloat lowerBounds = (center - (1.f - self.percent) * self.targetView.frame.size.height / 2 * 2) * 2;
    GLfloat upperBounds = (center + (1.f - self.percent) * self.targetView.frame.size.height / 2 * 2) * 2;
    glUniform2f(showRangeLoc, lowerBounds, upperBounds);
    
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
