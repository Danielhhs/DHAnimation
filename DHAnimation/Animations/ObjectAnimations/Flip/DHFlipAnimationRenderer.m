//
//  DHFlipAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFlipAnimationRenderer.h"
#import "SceneMesh.h"
#import "TextureHelper.h"

@interface DHFlipAnimationRenderer() {
    GLuint centerLoc, columnWidthLoc;
}
@property (nonatomic, strong) SceneMesh *mesh;
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

- (void) setupMeshes
{
    self.mesh = [[SceneMesh alloc] initWithView:self.targetView containerView:self.containerView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES];
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
    if (self.event == AnimationEventBuiltIn) {
        texture = [TextureHelper setupTextureWithView:self.targetView flipHorizontal:YES];
    } else {
        texture = [TextureHelper setupTextureWithView:self.targetView];
    }
}

@end
