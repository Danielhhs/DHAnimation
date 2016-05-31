//
//  DHShimmerBackgroundMesh.m
//  Shimmer
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShimmerBackgroundMesh.h"

@implementation DHShimmerBackgroundMesh

- (void) updateWithOffsetData:(NSArray *)offsetData event:(DHAnimationEvent)event
{
    _offsetData = offsetData;
    for (int x = 0; x < self.columnCount; x++) {
        for (int y = 0; y < self.rowCount; y++) {
            NSInteger idx = x * self.rowCount + y;
            GLKVector3 offset = GLKVector3Make([self.offsetData[idx] doubleValue], [self.offsetData[idx+ 1] doubleValue], [self.offsetData[idx + 2] doubleValue]);
                vertices[idx * 4 + 0].originalCenter = GLKVector3Add(vertices[idx * 4 + 0].position, offset);
                vertices[idx * 4 + 1].originalCenter = GLKVector3Add(vertices[idx * 4 + 1].position, offset);
                vertices[idx * 4 + 2].originalCenter = GLKVector3Add(vertices[idx * 4 + 2].position, offset);
                vertices[idx * 4 + 3].originalCenter = GLKVector3Add(vertices[idx * 4 + 3].position, offset);
        }
    }
    
    self.verticesData = [NSData dataWithBytes:vertices length:self.verticesSize];
    self.indicesData = [NSData dataWithBytes:indices length:self.indicesSize];
    self.bufferDataBumped = NO;
    [self prepareToDraw];
}
@end
