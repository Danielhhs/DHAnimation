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
    GLuint columnWidthLoc, headerHeightLoc, originLoc;
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
    self.headerLength = 64;
    columnWidthLoc = glGetUniformLocation(program, "u_columnWidth");
    headerHeightLoc = glGetUniformLocation(program, "u_headerHeight");
    originLoc = glGetUniformLocation(program, "u_origin");
}

- (void) setupMeshes
{
    DHFoldSceneMesh *mesh = [[DHFoldSceneMesh alloc] initWithView:self.targetView containerView:self.containerView headerHeight:self.headerLength animationDirection:self.direction columnCount:3 rowCount:3 columnMajored:YES];
    self.mesh = mesh;
    [self.mesh generateMeshData];
}

- (void) drawFrame
{
    [super drawFrame];
    if (self.event == DHAnimationEventBuiltIn) {
        glUniform1f(percentLoc, 1 - self.percent);
    }
    glUniform1f(columnWidthLoc, [self columnWidth]);
    glUniform1f(headerHeightLoc, self.headerLength);
    glUniform2f(originLoc, [self originPosition].x, [self originPosition].y);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (GLKVector2)originPosition
{
    if (self.direction == DHAnimationDirectionLeftToRight) {
        return GLKVector2Make(CGRectGetMaxX(self.targetView.frame), self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame));
    } else if (self.direction == DHAnimationDirectionRightToLeft) {
        return GLKVector2Make(self.targetView.frame.origin.x, self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame));
    } else if (self.direction == DHAnimationDirectionTopToBottom) {
        return GLKVector2Make(self.targetView.frame.origin.x, self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame));
    } else {
        return GLKVector2Make(self.targetView.frame.origin.x, self.containerView.bounds.size.height - self.targetView.frame.origin.y);
    }
}

- (GLfloat) columnWidth
{
    if (self.direction == DHAnimationDirectionLeftToRight || self.direction == DHAnimationDirectionRightToLeft) {
        return (self.targetView.frame.size.width - self.headerLength) / self.columnCount;
    } else {
        return (self.targetView.frame.size.height - self.headerLength) / self.rowCount;
    }
}
@end
