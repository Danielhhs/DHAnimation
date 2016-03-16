//
//  ConfettiSourceMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/16/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "ConfettiSourceMesh.h"

@implementation ConfettiSourceMesh

- (void) setupColumnStartPositionAndRotationForVertexAtX:(NSInteger)x y:(NSInteger)y index:(NSInteger)index
{
    GLKVector3 center = GLKVector3Make(-1 * (vertices[index + 1].position.x + vertices[index + 0].position.x) / 2, -1 * (vertices[index + 2].position.y + vertices[index + 0].position.y) / 2, vertices[index + 2].position.z - vertices[index + 0].position.z);
    
    vertices[index + 0].columnStartPosition = GLKVector3Add(vertices[index + 0].position, center);
    vertices[index + 1].columnStartPosition = GLKVector3Add(vertices[index + 1].position, center);
    vertices[index + 2].columnStartPosition = GLKVector3Add(vertices[index + 2].position, center);
    vertices[index + 3].columnStartPosition = GLKVector3Add(vertices[index + 3].position, center);
//    NSLog(@"Vertices[%lu].originalCenter = (%g, %g, %g)", index, vertices[index + 0].columnStartPosition.x, vertices[index + 0].columnStartPosition.y, vertices[index + 0].columnStartPosition.z);
    
    center.z = -500;
    center.x *= -1;
    center.y *= -1;
    vertices[index + 0].originalCenter = center;
    vertices[index + 1].originalCenter = center;
    vertices[index + 2].originalCenter = center;
    vertices[index + 3].originalCenter = center;
//    NSLog(@"Vertices[%lu].originalCenter = (%g, %g, %g)", index, center.x, center.y, center.z);
    
    GLKVector3 targetCenter = [self targetCenterForVertexAtX:x y:y originalCenter:center];
    vertices[index + 0].targetCenter = targetCenter;
    vertices[index + 1].targetCenter = targetCenter;
    vertices[index + 2].targetCenter = targetCenter;
    vertices[index + 3].targetCenter = targetCenter;
    
//    NSLog(@"Vertices[%lu].originalCenter = (%g, %g, %g)", index, targetCenter.x, targetCenter.y, targetCenter.z);
    
    GLfloat rotation = (arc4random() % 6 + 1) * M_PI * 2;
    vertices[index + 0].rotation = rotation;
    vertices[index + 1].rotation = rotation;
    vertices[index + 2].rotation = rotation;
    vertices[index + 3].rotation = rotation;
}

- (GLKVector3) targetCenterForVertexAtX:(NSInteger)x y:(NSInteger)y originalCenter:(GLKVector3)originalCenter
{
    GLKVector3 center = originalCenter;
    center.z = 0;
    if (x < self.columnCount / 2) {
        center.x -= arc4random() % 100;
    } else {
        center.x += arc4random() % 100;
    }
    if (y < self.rowCount / 2) {
        center.y -= arc4random() % 100;
    } else {
        center.y += arc4random() % 100;
    }
    return center;
}

@end
