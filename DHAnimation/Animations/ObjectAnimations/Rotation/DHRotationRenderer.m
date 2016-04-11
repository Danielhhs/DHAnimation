//
//  DHRotationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHRotationRenderer.h"
#import "SceneMesh.h"
@interface DHRotationRenderer()
@property (nonatomic, strong) SceneMesh *mesh;
@end

@implementation DHRotationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectRotationVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectRotationFragment.glsl";
}

- (void) setupMeshes
{
    self.mesh = [[SceneMesh alloc] initWithView:self.targetView containerView:self.containerView columnCount:self.columnCount rowCount:self.rowCount splitTexturesOnEachGrid:YES columnMajored:YES];
}

- (void) drawFrame
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, mvpMatrix.m);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}
@end
