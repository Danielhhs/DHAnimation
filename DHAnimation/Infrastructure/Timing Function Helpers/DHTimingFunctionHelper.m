//
//  DHTimingFunctionHelper.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTimingFunctionHelper.h"
#import "NSBKeyframeAnimationFunctions.h"
@interface DHTimingFunctionHelper()
@property (nonatomic, strong) NSArray *timingFunctions;
@end

static DHTimingFunctionHelper *sharedInstance;

@implementation DHTimingFunctionHelper

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    return self;
}

+ (DHTimingFunctionHelper *)helper
{
    if (sharedInstance == nil) {
        sharedInstance = [[DHTimingFunctionHelper alloc] initInternal];
    }
    return sharedInstance;
}

#pragma mark - Public APIs
- (NSArray *) timingFunctions
{
    if (!_timingFunctions) {
        _timingFunctions = @[@"Ease In Quad", @"Ease Out Quad", @"Ease In Out Quad", @"Ease In Cubic", @"Ease Out Cubic", @"Ease In Out Cubic", @"Ease In Quart", @"Ease Out Quart", @"Ease In Out Quart", @"Ease In Quint", @"Ease Out Quint", @"Ease In Out Quint", @"Ease In Sine", @"Ease Out Sine", @"Ease In Out Sine", @"Ease In Expo", @"Ease Out Expo", @"Ease In Out Expo", @"Ease In Circ", @"Ease Out Circ", @"Ease In Out Circ", @"Ease In Elastic", @"Ease Out Elastic", @"Ease In Out Elastic", @"Ease In Back", @"Ease Out Back", @"Ease In Out Back", @"Ease In Bounce", @"Ease Out Bounce", @"Ease In Out Bounce", @"Linear"];
    }
    return _timingFunctions;
}

+ (NSInteger) timingFunctionCount
{
    return [[DHTimingFunctionHelper helper].timingFunctions count];
}

+ (NSString *) functionNameForTimingFunction:(DHTimingFunction)timingFunction
{
    return [DHTimingFunctionHelper helper].timingFunctions[timingFunction];
}

+ (NSBKeyframeAnimationFunction) functionForTimingFunction:(DHTimingFunction)timingFunction
{
    switch (timingFunction) {
        case DHTimingFunctionEaseInQuad:
            return NSBKeyframeAnimationFunctionEaseInQuad;
        case DHTimingFunctionEaseOutQuad:
            return NSBKeyframeAnimationFunctionEaseOutQuad;
        case DHTimingFunctionEaseInOutQuad:
            return NSBKeyframeAnimationFunctionEaseInOutQuad;
            
        case DHTimingFunctionEaseInCubic:
            return NSBKeyframeAnimationFunctionEaseInCubic;
        case DHTimingFunctionEaseOutCubic:
            return NSBKeyframeAnimationFunctionEaseOutCubic;
        case DHTimingFunctionEaseInOutCubic:
            return NSBKeyframeAnimationFunctionEaseInOutCubic;
            
        case DHTimingFunctionEaseInQuart:
            return NSBKeyframeAnimationFunctionEaseInQuart;
        case DHTimingFunctionEaseOutQuart:
            return NSBKeyframeAnimationFunctionEaseOutQuart;
        case DHTimingFunctionEaseInOutQuart:
            return NSBKeyframeAnimationFunctionEaseInOutQuart;
            
        case DHTimingFunctionEaseInQuint:
            return NSBKeyframeAnimationFunctionEaseInQuint;
        case DHTimingFunctionEaseOutQuint:
            return NSBKeyframeAnimationFunctionEaseOutQuint;
        case DHTimingFunctionEaseInOutQuint:
            return NSBKeyframeAnimationFunctionEaseInOutQuint;
            
        case DHTimingFunctionEaseInSine:
            return NSBKeyframeAnimationFunctionEaseInSine;
        case DHTimingFunctionEaseOutSine:
            return NSBKeyframeAnimationFunctionEaseOutSine;
        case DHTimingFunctionEaseInOutSine:
            return NSBKeyframeAnimationFunctionEaseInOutSine;
            
        case DHTimingFunctionEaseInExpo:
            return NSBKeyframeAnimationFunctionEaseInExpo;
        case DHTimingFunctionEaseOutExpo:
            return NSBKeyframeAnimationFunctionEaseOutExpo;
        case DHTimingFunctionEaseInOutExpo:
            return NSBKeyframeAnimationFunctionEaseInOutExpo;
            
        case DHTimingFunctionEaseInCirc:
            return NSBKeyframeAnimationFunctionEaseInCirc;
        case DHTimingFunctionEaseOutCirc:
            return NSBKeyframeAnimationFunctionEaseOutCirc;
        case DHTimingFunctionEaseInOutCirc:
            return NSBKeyframeAnimationFunctionEaseInOutCirc;
            
        case DHTimingFunctionEaseInElastic:
            return NSBKeyframeAnimationFunctionEaseInElastic;
        case DHTimingFunctionEaseOutElastic:
            return NSBKeyframeAnimationFunctionEaseOutElastic;
        case DHTimingFunctionEaseInOutElastic:
            return NSBKeyframeAnimationFunctionEaseInOutElastic;
            
        case DHTimingFunctionEaseInBack:
            return NSBKeyframeAnimationFunctionEaseInBack;
        case DHTimingFunctionEaseOutBack:
            return NSBKeyframeAnimationFunctionEaseOutBack;
        case DHTimingFunctionEaseInOutBack:
            return NSBKeyframeAnimationFunctionEaseInOutBack;
            
        case DHTimingFunctionEaseInBounce:
            return NSBKeyframeAnimationFunctionEaseInBounce;
        case DHTimingFunctionEaseOutBounce:
            return NSBKeyframeAnimationFunctionEaseOutBounce;
        case DHTimingFunctionEaseInOutBounce:
            return NSBKeyframeAnimationFunctionEaseInOutBounce;
        
        case DHTimingFunctionLinear:
            return NSBKeyframeAnimationFunctionLinear;
        default:
            return NSBKeyframeAnimationFunctionLinear;
    }
}
@end
