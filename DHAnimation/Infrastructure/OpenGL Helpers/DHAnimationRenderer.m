//
//  DHAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationRenderer.h"

@implementation DHAnimationRenderer

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
}

- (void) performAnimationWithSettings:(DHAnimationSettings *)settings
{
    
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        GLfloat populatedTime = self.timingFunction(self.elapsedTime * 1000, 0, self.duration, self.duration * 1000);
        self.percent = populatedTime / self.duration;
        [self.animationView display];
    } else {
        self.percent = 1;
        [self.animationView display];
        [displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        [self tearDownGL];
        if (self.completion) {
            self.completion();
        }
    }
}

- (void) tearDownGL
{
    
}

@end
