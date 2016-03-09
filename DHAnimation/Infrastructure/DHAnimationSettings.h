//
//  DHAnimationSettings.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"
#import "DHTimingFunctionHelper.h"
@interface DHAnimationSettings : NSObject
@property (nonatomic) AnimationDirection animationDirection;
@property (nonatomic) DHTimingFunction timingFunction;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) void (^completion)(void);
@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) UIView *toView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger rowCount;

@property (nonatomic) BOOL partialAnimation;

+ (DHAnimationSettings *)defaultSettings;
@end
