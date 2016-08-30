//
//  DHPolygon.h
//  DHAnimation
//
//  Created by Huang Hongsen on 8/29/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHIntersectPoint.h"

@interface DHPolygon : NSObject
@property (nonatomic, strong, readonly) NSArray *vertices;
- (void) appendVertex:(DHIntersectPoint *)vertex;
- (BOOL) isCompleted;
@end
