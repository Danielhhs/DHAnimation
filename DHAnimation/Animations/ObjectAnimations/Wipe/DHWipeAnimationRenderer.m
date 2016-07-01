//
//  DHWipeAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 7/1/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHWipeAnimationRenderer.h"
@interface DHWipeAnimationRenderer() {
    GLuint centerLoc, wiperWidthLoc, singleWipeDurationLoc, wipeRangeLoc, wiperRadiusLoc, percentInCycleLoc, wipeDirectionLoc;
}

@property (nonatomic) GLKVector2 center;
@property (nonatomic) GLfloat wiperWidth;
@property (nonatomic) NSTimeInterval singleWipeDuration;
@property (nonatomic) GLfloat wiperRadius;
@property (nonatomic) GLfloat percentInCycle;
@property (nonatomic) GLfloat wipeDirection;    //0.f --> Left to Right; 1.f --> Right to Left

@property (nonatomic) GLfloat largestDistance;
@property (nonatomic) GLfloat smallestDistance;
@property (nonatomic) GLfloat largestAngle;
@property (nonatomic) GLfloat smallestAngle;
@property (nonatomic) GLKVector2 yAxis;
@end

#define MIN_X_SPACE 30

@implementation DHWipeAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectWipeVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectWipeFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
    centerLoc = glGetUniformLocation(program, "u_center");
    wiperWidthLoc = glGetUniformLocation(program, "u_wiperWidth");
    singleWipeDurationLoc = glGetUniformLocation(program, "u_singleWipeDuration");
    wipeRangeLoc = glGetUniformLocation(program, "u_wiperRange");
    wiperRadiusLoc = glGetUniformLocation(program, "u_wiperRadius");
    percentInCycleLoc = glGetUniformLocation(program, "u_percentInCycle");
    wipeDirectionLoc = glGetUniformLocation(program, "u_wipeDirection");
    self.center = [self randomCenter];
    self.singleWipeDuration = self.duration / self.numberOfWipes;
    [self generateWiper];
}

- (void) generateWiper
{
    GLfloat originY = self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame);
    GLKVector2 bottomLeft = GLKVector2Make(self.targetView.frame.origin.x, originY);
    GLKVector2 bottomRight = GLKVector2Make(CGRectGetMaxX(self.targetView.frame), originY);
    GLKVector2 topLeft = GLKVector2Make(self.targetView.frame.origin.x, originY + self.targetView.frame.size.height);
    GLKVector2 topRight = GLKVector2Make(CGRectGetMaxX(self.targetView.frame), originY + self.targetView.frame.size.height);
    self.largestDistance = GLKVector2Distance(self.center, bottomLeft);
    self.smallestDistance = self.largestDistance;
    self.largestAngle = [self angleForVertex:bottomLeft];
    self.smallestAngle = self.largestAngle;
    
    [self updateWiperForVertex:bottomRight];
    [self updateWiperForVertex:topLeft];
    [self updateWiperForVertex:topRight];
    
    [self findSmallestDistance];
    
    self.wiperWidth = (self.largestDistance - self.smallestDistance) / self.numberOfWipes;
}

- (void) findSmallestDistance
{
    GLfloat originY = self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame);
    GLKVector2 bottomLeft = GLKVector2Make(self.targetView.frame.origin.x, originY);
    GLKVector2 bottomRight = GLKVector2Make(CGRectGetMaxX(self.targetView.frame), originY);
    GLKVector2 topLeft = GLKVector2Make(self.targetView.frame.origin.x, originY + self.targetView.frame.size.height);
    GLKVector2 topRight = GLKVector2Make(CGRectGetMaxX(self.targetView.frame), originY + self.targetView.frame.size.height);
    if (self.center.x > bottomLeft.x && self.center.x < bottomRight.x) {
        if (self.center.y < bottomLeft.y) {
            self.smallestDistance = bottomLeft.y - self.center.y;
        } else {
            self.smallestDistance = self.center.y - topLeft.y;
        }
    } else if (self.center.y > bottomLeft.y && self.center.y < topLeft.y) {
        if (self.center.x < bottomLeft.x) {
            self.smallestDistance = bottomLeft.x - self.center.x;
        } else {
            self.smallestDistance = self.center.x - topRight.x;
        }
    }
}

- (void) updateWiperForVertex:(GLKVector2)vertex
{
    GLfloat distance = GLKVector2Distance(self.center, vertex);
    if (self.smallestDistance > distance) {
        self.smallestDistance = distance;
    }
    if (self.largestDistance < distance) {
        self.largestDistance = distance;
    }
    GLfloat angle = [self angleForVertex:vertex];
    if (self.smallestAngle > angle) {
        self.smallestAngle = angle;
    }
    if (self.largestAngle < angle) {
        self.largestAngle = angle;
    }
}

- (GLfloat) angleForVertex:(GLKVector2)vertex
{
    GLKVector2 vector = GLKVector2Subtract(vertex, self.center);
    GLfloat dotProduct = GLKVector2DotProduct(self.yAxis, vector);
    GLfloat length = GLKVector2Length(self.yAxis) * GLKVector2Length(vector);
    return acosf(dotProduct / length);
}

- (GLKVector2) randomCenter
{
    GLfloat x, y;
    
    if (self.direction == DHAnimationDirectionRightToLeft) {
        x = CGRectGetMaxX(self.targetView.frame) + [self randomPercent] * (self.containerView.frame.size.width - CGRectGetMaxX(self.targetView.frame));
        y = [self randomPercent] * (self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame));
    } else if (self.direction == DHAnimationDirectionLeftToRight) {
        x = [self randomPercent] * self.targetView.frame.origin.x;
        y = [self randomPercent] * (self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame));
    }
    return GLKVector2Make(x, y);
}

- (GLfloat) randomPercent
{
    return arc4random() % 1000 / 1000.f;
}

- (void) drawFrame
{
    [super drawFrame];
    
    glUniform2f(centerLoc, self.center.x, self.center.y);
    glUniform1f(wiperWidthLoc, self.wiperWidth);
    glUniform1f(singleWipeDurationLoc, self.singleWipeDuration);
    glUniform2f(wipeRangeLoc, self.smallestAngle, self.largestAngle);
    glUniform1f(wiperRadiusLoc, self.wiperRadius);
    glUniform1f(percentInCycleLoc, self.percentInCycle);
    glUniform1f(wipeDirectionLoc, self.wipeDirection);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}


- (GLuint) numberOfWipes
{
    if (!_numberOfWipes) {
        _numberOfWipes = 3;
    }
    return _numberOfWipes;
}

- (GLKVector2) yAxis
{
    return GLKVector2Make(0, 1);
}

- (void) updateAdditionalComponents
{
    int cycle = floor(self.percent * self.numberOfWipes);
    if (cycle % 2 == 0) {
        self.wipeDirection = 0.f;
    } else {
        self.wipeDirection = 1.f;
    }
    self.wiperRadius = self.smallestDistance + (self.largestDistance - self.smallestDistance) / self.numberOfWipes * cycle;
    self.percentInCycle = (self.elapsedTime - cycle * self.singleWipeDuration) / self.singleWipeDuration;
}
@end
