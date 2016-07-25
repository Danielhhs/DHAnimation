//
//  DHBlowSceneMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 7/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBlowSceneMesh.h"

@interface DHBlowSceneMesh ()
@property (nonatomic) GLKVector3 blowingPosition;
@end

@implementation DHBlowSceneMesh

- (void) setupForVertexAtX:(NSInteger)x y:(NSInteger)y index:(NSInteger)index
{
    GLfloat stickness = [self randomStickness];
    
    vertices[index + 0].startTime = GLKVector3Distance(self.blowingPosition, vertices[index + 0].position) + stickness;
    vertices[index + 1].startTime = vertices[index + 0].startTime;
    vertices[index + 2].startTime = vertices[index + 0].startTime;
    vertices[index + 3].startTime = vertices[index + 0].startTime;
        
    if (vertices[index + 0].startTime < self.minStartTime) {
        self.minStartTime = vertices[index + 0].startTime;
    } else if (self.maxStartTime < vertices[index + 0].startTime) {
        self.maxStartTime = vertices[index + 0].startTime;
    }
    
    GLKVector3 direction = GLKVector3Normalize(GLKVector3Subtract(vertices[index + 0].position, self.blowingPosition));
    GLKVector3 offset = GLKVector3MultiplyScalar(direction, [self randomOffset]);
    
    vertices[index + 0].targetCenter = offset;
    vertices[index + 1].targetCenter = offset;
    vertices[index + 2].targetCenter = offset;
    vertices[index + 3].targetCenter = offset;
}

- (GLfloat) randomStickness
{
    return arc4random() % 150;
}

- (GLfloat) randomOffset
{
    int max = MAX(self.targetView.frame.size.width, self.targetView.frame.size.height);
    return arc4random() % 200 + max;
}

- (GLKVector3) blowingPosition
{
    if ((_blowingPosition.x == 0 && _blowingPosition.y == 0 && _blowingPosition.z == 0)) {
        _blowingPosition = [self randomBlowingPosition];
    }
    return _blowingPosition;
}

- (GLKVector3) randomBlowingPosition
{
    GLfloat x = arc4random() % (int) self.containerView.bounds.size.width;
    GLfloat y = arc4random() % (int) self.containerView.bounds.size.height;
    
    if (CGRectContainsPoint(CGRectInset(self.targetView.frame, -50, -50), CGPointMake(x, y))) {
        int random = arc4random() % 2;
        if (random == 0) {
            random = arc4random() % 2;
            int sign = (random == 0) ? 1 : -1;
            x += sign * self.targetView.frame.size.width;
        } else {
            random = arc4random() % 2;
            int sign = (random == 0) ? 1 : -1;
            y += sign * self.targetView.frame.size.height;
        }
    }
    
    return GLKVector3Make(x, y, 0);
}

- (GLfloat) minStartTime
{
    if (!_minStartTime) {
        _minStartTime = FLT_MAX;
    }
    return _minStartTime;
}

@end
