//
//  DHMosaicMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHMosaicMesh.h"

@implementation DHMosaicMesh

- (void) updateWithIndicesItemsStartedRotation:(NSArray *)items incrementedRotation:(CGFloat)increment
{
    for (NSNumber *index in items) {
        vertices[[index integerValue]].rotating = YES;
    }
    for (int i = 0; i < self.vertexCount; i++) {
        if (vertices[i].rotating == YES) {
            vertices[i * 4 + 0].rotation += increment;
            if (vertices[i * 4 + 0].rotation > M_PI) {
                vertices[i * 4 + 0].rotation = M_PI;
            }
            vertices[i * 4 + 1].rotation = vertices[i * 4 + 0].rotation;
            vertices[i * 4 + 2].rotation = vertices[i * 4 + 0].rotation;
            vertices[i * 4 + 3].rotation = vertices[i * 4 + 0].rotation;
        }
    }
    [self makeDynamicAndUpdateWithVertices:vertices numberOfVertices:self.vertexCount];
}

@end
