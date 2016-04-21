//
//  DHDropAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHDropAnimationRenderer.h"
#import "SceneMesh.h"
@interface DHDropAnimationRenderer() {
    GLuint targetPositionLoc;
}
@property (nonatomic, strong) SceneMesh *mesh;
@end

@implementation DHDropAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    targetPositionLoc = glGetUniformLocation(program, "u_targetPosition");
}

- (NSString *) vertexShaderName
{
    return @"ObjectDropVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectDropFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform1f(targetPositionLoc, self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame));
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (void) setupMeshes
{
    self.mesh = [[SceneMesh alloc] initWithView:self.targetView containerView:self.containerView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES];
}

@end
