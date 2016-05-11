//
//  DHFlipAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFlipAnimationRenderer.h"
#import "TextureHelper.h"

@interface DHFlipAnimationRenderer() {
    GLuint centerLoc, columnWidthLoc;
}
@end

@implementation DHFlipAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    centerLoc = glGetUniformLocation(program, "u_center");
    columnWidthLoc = glGetUniformLocation(program, "u_columnWidth");
}

- (NSString *) vertexShaderName
{
    return @"ObjectFlipVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectFlipFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform2f(centerLoc, CGRectGetMidX(self.targetView.frame), CGRectGetMidY(self.targetView.frame));
    glUniform1f(columnWidthLoc, self.targetView.frame.size.width);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (void) setupTextures
{
    if (self.event == DHAnimationEventBuiltIn) {
        texture = [TextureHelper setupTextureWithView:self.targetView inRect:CGRectMake(0, 0, self.targetView.frame.size.width, self.targetView.frame.size.height) flipHorizontal:YES flipVertical:NO rotate:YES];
    } else {
        texture = [TextureHelper setupTextureWithView:self.targetView rotate:YES];
    }
}

- (void) setupMeshes
{
    self.mesh = [DHSceneMeshFactory sceneMeshForView:self.targetView containerView:self.containerView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
}


- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionTop)];
}
@end
