//
//  DHEdge.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/29/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHEdge.h"

@implementation DHEdge

- (BOOL) isEqual:(id)object
{
    if ([object isKindOfClass:[DHEdge class]]) {
        DHEdge *anotherEdge = (DHEdge *)object;
        if (GLKVector2AllEqualToVector2(self.startPoint, anotherEdge.startPoint) && GLKVector2AllEqualToVector2(self.endPoint, anotherEdge.endPoint)) {
            return YES;
        }
        if (GLKVector2AllEqualToVector2(self.endPoint, anotherEdge.startPoint) && GLKVector2AllEqualToVector2(self.startPoint, anotherEdge.endPoint)) {
            return YES;
        }
    }
    return NO;
}


@end
