//
//  DHAnimationSettings.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHConstants.h"
#import "DHTimingFunctionHelper.h"
@interface DHTransitionSettings : NSObject
@property (nonatomic) DHAnimationDirection animationDirection;
@property (nonatomic) DHTimingFunction timingFunction;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) void (^completion)(void);
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger rowCount;
@property (nonatomic, strong) NSArray *allowedDirections;

@property (nonatomic) BOOL partialAnimation;

+ (DHTransitionSettings *)defaultSettings;
+ (DHTransitionSettings *) defaultSettingsForTransitionType:(DHTransitionType)transitionType;
@end
