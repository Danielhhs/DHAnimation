//
//  DHMosaicMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHMosaicMesh.h"

@implementation DHMosaicMesh

- (void) setupForVertexAtX:(NSInteger)x y:(NSInteger)y index:(NSInteger)index
{
    vertices[index + 0].originalCenter = GLKVector3Make((vertices[index + 0].position.x + vertices[index + 1].position.x) / 2, (vertices[index + 0].position.y + vertices[index + 2].position.y) / 2, 0);
    vertices[index + 1].originalCenter = vertices[index + 0].originalCenter;
    vertices[index + 2].originalCenter = vertices[index + 0].originalCenter;
    vertices[index + 3].originalCenter = vertices[index + 0].originalCenter;
}

- (void) updateStartTime:(NSArray *)startTime
{
    for (int i = 0; i < [startTime count]; i++) {
        vertices[i * 4 + 0].startTime = [startTime[i] doubleValue];
        vertices[i * 4 + 1].startTime = [startTime[i] doubleValue];
        vertices[i * 4 + 2].startTime = [startTime[i] doubleValue];
        vertices[i * 4 + 3].startTime = [startTime[i] doubleValue];
    }
    
}

@end
