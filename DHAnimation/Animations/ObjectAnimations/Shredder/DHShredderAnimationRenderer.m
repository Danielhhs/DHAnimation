//
//  DHShredderAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 7/31/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShredderAnimationRenderer.h"
#import "DHShredderAnimationSceneMesh.h"
@interface DHShredderAnimationRenderer () {
    GLuint shredderPositionLoc, timeLoc, durationLoc, columnWidthLoc, screenScaleLoc;
}
@end

@implementation DHShredderAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectShredderVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectShredderFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
    shredderPositionLoc = glGetUniformLocation(program, "u_shredderPosition");
    timeLoc = glGetUniformLocation(program, "u_time");
    durationLoc = glGetUniformLocation(program, "u_duration");
    columnWidthLoc = glGetUniformLocation(program, "u_columnWidth");
    screenScaleLoc = glGetUniformLocation(program, "u_screenScale");
    self.animationView.drawableMultisample = GLKViewDrawableMultisample4X;
}

- (void) setupMeshes
{
    self.mesh = [[DHShredderAnimationSceneMesh alloc] initWithTargetView:self.targetView containerView:self.containerView columnCount:7];
    [self.mesh generateMeshData];
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform1f(shredderPositionLoc, self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame) + self.percent * self.targetView.frame.size.height);
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(durationLoc, self.duration);
    glUniform1f(columnWidthLoc, self.targetView.frame.size.width / self.columnCount);
    glUniform1f(screenScaleLoc, [UIScreen mainScreen].scale);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1f(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
