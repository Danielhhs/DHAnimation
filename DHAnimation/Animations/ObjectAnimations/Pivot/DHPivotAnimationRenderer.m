//
//  DHPivotAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHPivotAnimationRenderer.h"
@interface DHPivotAnimationRenderer() {
    GLuint anchorPointLoc, yOffsetLoc;
}

@end

@implementation DHPivotAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    anchorPointLoc = glGetUniformLocation(program, "u_anchorPoint");
    yOffsetLoc = glGetUniformLocation(program, "u_yOffset");
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
    GLfloat yOffset = [self yOffset];
    glUniform1f(yOffsetLoc, yOffset);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (GLKVector3) anchorPoint
{
    switch (self.direction) {
        case AnimationDirectionLeftToRight:
        case AnimationDirectionTopToBottom:
            return GLKVector3Make(self.targetView.frame.origin.x, self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame), 0);
        case AnimationDirectionBottomToTop:
        case AnimationDirectionRightToLeft:
            return GLKVector3Make(CGRectGetMaxX(self.targetView.frame), self.containerView.frame.size.height - self.targetView.frame.origin.y, 0);
    }
}

- (GLfloat) yOffset
{
    switch (self.direction) {
        case AnimationDirectionLeftToRight:
        case AnimationDirectionTopToBottom:
            return self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame);
        case AnimationDirectionBottomToTop:
        case AnimationDirectionRightToLeft:
            return -self.containerView.frame.size.height + self.targetView.frame.origin.y;
    }

}

- (NSArray *) allowedDirections
{
    return @[@(AllowedAnimationDirectionLeft), @(AllowedAnimationDirectionRight)];
}
@end
