//
//  DHLine.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/29/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHLine.h"

@interface DHLine ()
@property (nonatomic, strong) NSMutableArray *intersecPointsForLine;
@property (nonatomic, strong) NSArray *sortedIntersectPoints;
@end

@implementation DHLine

- (BOOL) isEqual:(id)object
{
    if ([object isKindOfClass:[DHLine class]]) {
        DHLine *anotherLine = (DHLine *)object;
        if (GLKVector2AllEqualToVector2(self.direction, anotherLine.direction) && GLKVector2AllEqualToVector2(self.startPoint, anotherLine.startPoint)) {
            return YES;
        }
    }
    return NO;
}

- (DHIntersectPoint *) intersectPointWithLine:(DHLine *)line
{
    GLfloat dividant = (line.startPoint.y - self.startPoint.y) * line.direction.x - (line.startPoint.x - self.startPoint.x) * line.direction.y;
    GLfloat dividor = self.direction.y * line.direction.x - self.direction.x * line.direction.y;
    GLfloat t = dividant / dividor;
    DHIntersectPoint *point = [[DHIntersectPoint alloc] init];
    point.position = GLKVector2Add(self.startPoint, GLKVector2MultiplyScalar(self.direction, t));
    point.line1 = self;
    point.line2 = line;
    return point;
}

- (BOOL) isParallelWithLine:(DHLine *)line
{
    return GLKVector2AllEqualToVector2(self.direction, line.direction);
}

- (NSMutableArray *) intersecPointsForLine
{
    if (!_intersecPointsForLine) {
        _intersecPointsForLine = [NSMutableArray array];
    }
    return _intersecPointsForLine;
}

- (NSArray *) intersectPoints
{
    return [self.intersecPointsForLine copy];
}

- (void) addInterSectPoint:(DHIntersectPoint *)point
{
    [self.intersecPointsForLine addObject:point];
}

- (NSArray *) nearestIntersectPointForPoint:(DHIntersectPoint *)point
{
    NSInteger index = [self.sortedIntersectPoints indexOfObject:point];
    if (index == 0) {
        return @[self.sortedIntersectPoints[index + 1]];
    }
    if (index == [self.sortedIntersectPoints count] - 1) {
        return @[self.sortedIntersectPoints[index - 1]];
    }
    return @[self.sortedIntersectPoints[index - 1], self.sortedIntersectPoints[index + 1]];
}

- (NSArray *) sortedIntersectPoints
{
    if (!_sortedIntersectPoints) {
        _sortedIntersectPoints = [self.intersecPointsForLine sortedArrayUsingComparator:^NSComparisonResult(DHIntersectPoint *obj1, DHIntersectPoint *obj2) {
            return obj1.position.x > obj2.position.x;
        }];
    }
    return _sortedIntersectPoints;
}

- (BOOL) containsPoint:(DHIntersectPoint *)point
{
    GLKVector2 pointVector = GLKVector2Subtract(point.position, self.startPoint);
    if (GLKVector2AllEqualToVector2(GLKVector2Normalize(pointVector), self.direction)) {
        return YES;
    }
    return NO;
}
@end
