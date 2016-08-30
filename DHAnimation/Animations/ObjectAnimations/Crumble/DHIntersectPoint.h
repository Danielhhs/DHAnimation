//
//  DHIntersectPoint.h
//  DHAnimation
//
//  Created by Huang Hongsen on 8/29/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@class DHLine;

@interface DHIntersectPoint : NSObject

@property (nonatomic) GLKVector2 position;

@property (nonatomic, weak) DHLine *line1;
@property (nonatomic, weak) DHLine *line2;

- (DHLine *)nextLineForLine:(DHLine *)line;
@end
