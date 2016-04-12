//
//  DHConfettiAnimationMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHConfettiAnimationMesh.h"

@implementation DHConfettiAnimationMesh

- (void) updateMeshDataWithEvent:(AnimationEvent)event
{
    if (event == AnimationEventBuiltIn) {
        return;
    }
//    for (int i = 0; i < self.vertexCount; i++) {
//        GLKVector3 originalCenter = vertices[i].originalCenter;
//        vertices[i].originalCenter = vertices[i].targetCenter;
//        vertices[i].targetCenter = originalCenter;
//    }
//    self.verticesData = [NSData dataWithBytes:vertices length:self.verticesSize];
//    self.indicesData = [NSData dataWithBytes:indices length:self.indicesSize];
}

@end
