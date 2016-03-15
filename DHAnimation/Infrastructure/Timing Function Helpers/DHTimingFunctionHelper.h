//
//  DHTimingFunctionHelper.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSBKeyframeAnimationFunctions.h"

typedef NS_ENUM(NSInteger, DHTimingFunction) {
    DHTimingFunctionEaseInQuad = 0,
    DHTimingFunctionEaseOutQuad = 1,
    DHTimingFunctionEaseInOutQuad = 2,
    DHTimingFunctionEaseInCubic = 3,
    DHTimingFunctionEaseOutCubic = 4,
    DHTimingFunctionEaseInOutCubic = 5,
    DHTimingFunctionEaseInQuart = 6,
    DHTimingFunctionEaseOutQuart = 7,
    DHTimingFunctionEaseInOutQuart = 8,
    DHTimingFunctionEaseInQuint = 9,
    DHTimingFunctionEaseOutQuint = 10,
    DHTimingFunctionEaseInOutQuint = 11,
    DHTimingFunctionEaseInSine = 12,
    DHTimingFunctionEaseOutSine = 13,
    DHTimingFunctionEaseInOutSine = 14,
    DHTimingFunctionEaseInExpo = 15,
    DHTimingFunctionEaseOutExpo = 16,
    DHTimingFunctionEaseInOutExpo = 17,
    DHTimingFunctionEaseInCirc = 18,
    DHTimingFunctionEaseOutCirc = 19,
    DHTimingFunctionEaseInOutCirc = 20,
    DHTimingFunctionEaseInElastic = 21,
    DHTimingFunctionEaseOutElastic = 22,
    DHTimingFunctionEaseInOutElastic = 23,
    DHTimingFunctionEaseInBack = 24,
    DHTimingFunctionEaseOutBack = 25,
    DHTimingFunctionEaseInOutBack = 26,
    DHTimingFunctionEaseInBounce = 27,
    DHTimingFunctionEaseOutBounce = 28,
    DHTimingFunctionEaseInOutBounce = 29,
    DHTimingFunctionLinear = 30,
};

@interface DHTimingFunctionHelper : NSObject
+ (NSString *) functionNameForTimingFunction:(DHTimingFunction)timingFunction;

+ (NSBKeyframeAnimationFunction) functionForTimingFunction:(DHTimingFunction)timingFunction;

+ (NSInteger) timingFunctionCount;
@end
