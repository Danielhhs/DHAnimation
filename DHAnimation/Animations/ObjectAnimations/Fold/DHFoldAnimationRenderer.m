//
//  DHFoldAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/10/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFoldAnimationRenderer.h"
#import "DHFoldSceneMesh.h"

@interface DHFoldAnimationRenderer () {
    GLuint columnWidthLoc;
}

@end

@implementation DHFoldAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectFoldVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectFoldFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
    columnWidthLoc = glGetUniformLocation(program, "u_columnWidth");
}

- (void) setupMeshes
{
    DHFoldSceneMesh *mesh = [[DHFoldSceneMesh alloc] initWithView:self.targetView containerView:self.containerView columnCount:self.columnCount rowCount:self.rowCount splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:NO];
    self.mesh = mesh;
    [self.mesh generateMeshData];
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform1f(columnWidthLoc, self.targetView.frame.size.width / self.columnCount);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
