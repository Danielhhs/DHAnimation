//
//  ConfettiSourceMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/16/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHConfettiSourceMesh.h"

@implementation DHConfettiSourceMesh

- (void) setupForVertexAtX:(NSInteger)x y:(NSInteger)y index:(NSInteger)index
{
    GLKVector3 center = GLKVector3Make(-1 * (vertices[index + 1].position.x + vertices[index + 0].position.x) / 2, -1 * (vertices[index + 2].position.y + vertices[index + 0].position.y) / 2, vertices[index + 2].position.z - vertices[index + 0].position.z);
    
    vertices[index + 0].columnStartPosition = GLKVector3Add(vertices[index + 0].position, center);
    vertices[index + 1].columnStartPosition = GLKVector3Add(vertices[index + 1].position, center);
    vertices[index + 2].columnStartPosition = GLKVector3Add(vertices[index + 2].position, center);
    vertices[index + 3].columnStartPosition = GLKVector3Add(vertices[index + 3].position, center);
    
    center.z = 0;
    center.x *= -1;
    center.y *= -1;
    vertices[index + 0].originalCenter = center;
    vertices[index + 1].originalCenter = center;
    vertices[index + 2].originalCenter = center;
    vertices[index + 3].originalCenter = center;
    
    CGFloat columnWidth = vertices[index + 1].position.x - vertices[index + 0].position.x;
    if (columnWidth == 0) {
        columnWidth = vertices[index + 2].position.x - vertices[index + 0].position.x;
    }
    GLKVector3 targetCenter = [self targetCenterForVertexAtX:x y:y originalCenter:center columnWidth:columnWidth];
    vertices[index + 0].targetCenter = targetCenter;
    vertices[index + 1].targetCenter = targetCenter;
    vertices[index + 2].targetCenter = targetCenter;
    vertices[index + 3].targetCenter = targetCenter;
    
    
    GLfloat rotation = (arc4random() % 3 + 1) * M_PI * 2;
    vertices[index + 0].rotation = rotation;
    vertices[index + 1].rotation = rotation;
    vertices[index + 2].rotation = rotation;
    vertices[index + 3].rotation = rotation;
}

- (GLKVector3) targetCenterForVertexAtX:(NSInteger)x y:(NSInteger)y originalCenter:(GLKVector3)originalCenter columnWidth:(CGFloat)columnWidth
{
    GLKVector3 center = originalCenter;
    int maxOffset = columnWidth * 3;
    center.z = -1 * CONFETTI_DEPTH;
    GLfloat xOffset = (int)arc4random() % (maxOffset * 2) - maxOffset;
    center.x += xOffset;
    GLfloat yOffset = (int)arc4random() % (maxOffset * 2) - maxOffset;
    center.y += yOffset;
    return center;
}

@end
