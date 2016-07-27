//
//  DHPivotAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHPivotAnimationRenderer.h"
#import "TextureHelper.h"
@interface DHPivotAnimationRenderer() {
    GLuint anchorPointLoc, yOffsetLoc, centerLoc;
}

@end

@implementation DHPivotAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    anchorPointLoc = glGetUniformLocation(program, "u_anchorPoint");
    yOffsetLoc = glGetUniformLocation(program, "u_yOffset");
    centerLoc = glGetUniformLocation(program, "u_center");
}

- (NSString *) vertexShaderName
{
    return @"ObjectPivotVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectPivotFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    GLKVector3 anchorPoint = [self anchorPoint];
    glUniform3fv(anchorPointLoc, 1, anchorPoint.v);
    glUniform2f(centerLoc, CGRectGetMidX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMidY(self.targetView.frame));
    GLfloat yOffset = [self yOffset];
    glUniform1f(yOffsetLoc, yOffset);
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

- (GLKVector3) anchorPoint
{
    switch (self.direction) {
        case DHAnimationDirectionLeftToRight:
        case DHAnimationDirectionTopToBottom:
            return GLKVector3Make(self.targetView.frame.origin.x, self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame), 0);
        case DHAnimationDirectionBottomToTop:
        case DHAnimationDirectionRightToLeft:
            return GLKVector3Make(CGRectGetMaxX(self.targetView.frame), self.containerView.frame.size.height - self.targetView.frame.origin.y, 0);
    }
}

- (GLfloat) yOffset
{
    switch (self.direction) {
        case DHAnimationDirectionLeftToRight:
        case DHAnimationDirectionTopToBottom:
            return CGRectGetMaxY(self.targetView.frame);
        case DHAnimationDirectionBottomToTop:
        case DHAnimationDirectionRightToLeft:
            return -self.containerView.frame.size.height + self.targetView.frame.origin.y;
    }

}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft), @(DHAllowedAnimationDirectionRight)];
}
@end
