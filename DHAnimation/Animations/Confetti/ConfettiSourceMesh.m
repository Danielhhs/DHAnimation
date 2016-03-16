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
    GLKVector3 center = GLKVector3Make((vertices[index + 1].position.x - vertices[index + 0].position.x) / 2, (vertices[index + 2].position.y - vertices[index + 0].position.y) / 2, 0);
    center.z = 100.f;
    
    vertices[index + 0].columnStartPosition = center;
    vertices[index + 1].columnStartPosition = center;
    vertices[index + 2].columnStartPosition = center;
    vertices[index + 3].columnStartPosition = center;
    
    GLfloat rotation = (arc4random() % 3 + 1) * M_PI * 2;
    vertices[index + 0].rotation = rotation;
    vertices[index + 1].rotation = rotation;
    vertices[index + 2].rotation = rotation;
    vertices[index + 3].rotation = rotation;
}

@end
