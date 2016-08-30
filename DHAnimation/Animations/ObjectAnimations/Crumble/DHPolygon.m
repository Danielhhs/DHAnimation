//
//  DHPolygon.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/29/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHPolygon.h"

@interface DHPolygon()
@property (nonatomic, strong) NSMutableArray *verticesInPolygon;
@end

@implementation DHPolygon

- (NSArray *) vertices
{
    return [self.verticesInPolygon copy];
}

- (NSMutableArray *) verticesInPolygon
{
    if (!_verticesInPolygon) {
        _verticesInPolygon = [NSMutableArray array];
    }
    return _verticesInPolygon;
}

- (void)appendVertex:(DHIntersectPoint *)vertex
{
    if (![self.verticesInPolygon containsObject:vertex]) {
        [self.verticesInPolygon addObject:vertex];
    }
}

- (BOOL) isCompleted {
    if ([self.verticesInPolygon count] < 3) {
        return NO;
    }
    DHIntersectPoint *firstVertex = [self.verticesInPolygon firstObject];
    DHIntersectPoint *lastVertex = [self.verticesInPolygon lastObject];
    if (GLKVector2AllEqualToVector2(firstVertex.position, lastVertex.position)) {
        return YES;
    }
    return NO;
}

- (BOOL) isEqual:(id)object
{
    if ([object isKindOfClass:[DHPolygon class]]) {
        DHPolygon *polygon = (DHPolygon *)object;
        if ([self.vertices count] != [polygon.vertices count]) {
            return NO;
        }
        for (DHIntersectPoint *point in self.vertices) {
            if (![polygon.vertices containsObject:point]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end
