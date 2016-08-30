//
//  DHIntersectPoint.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/29/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHIntersectPoint.h"
#import "DHLine.h"
@interface DHIntersectPoint ()
@end

@implementation DHIntersectPoint

- (BOOL) isEqual:(id)object
{
    if ([object isKindOfClass:[DHIntersectPoint class]]) {
        DHIntersectPoint *anotherPoint = (DHIntersectPoint *)object;
        if (GLKVector2AllEqualToVector2(anotherPoint.position, self.position)) {
            return YES;
        }
    }
    return NO;
}

- (DHLine *) nextLineForLine:(DHLine *)line
{
    if ([line isEqual:self.line1]) {
        return self.line2;
    }
    return self.line1;
}
@end
