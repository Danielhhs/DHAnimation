//
//  DHLine.h
//  DHAnimation
//
//  Created by Huang Hongsen on 8/29/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHIntersectPoint.h"

@interface DHLine : NSObject

@property (nonatomic) GLKVector2 direction;
@property (nonatomic) GLKVector2 startPoint;
@property (nonatomic, strong, readonly) NSArray *intersectPoints;

- (DHIntersectPoint *)intersectPointWithLine:(DHLine *)line;
- (BOOL) isParallelWithLine:(DHLine *)line;
- (void) addInterSectPoint:(DHIntersectPoint *)point;
- (BOOL) containsPoint:(DHIntersectPoint *)point;

- (NSArray *) nearestIntersectPointForPoint:(DHIntersectPoint *)point;
@end
