//
//  DHTextAnimationSettings.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHConstants.h"
#import "DHTimingFunctionHelper.h"

@interface DHTextAnimationSettings : NSObject

@property (nonatomic, weak) GLKView *animationView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) DHAnimationDirection direction;
@property (nonatomic) DHAnimationEvent event;
@property (nonatomic) DHTimingFunction timingFunction;
@property (nonatomic, strong) void (^completion)(void);
@property (nonatomic, strong) void (^beforeAnimationAction)(void);
@property (nonatomic, strong) NSAttributedString *attributedText;
@property (nonatomic) CGPoint origin;
@property (nonatomic, weak) UIView *textContainerView;

+ (DHTextAnimationSettings *) defaultSettings;
+ (DHTextAnimationSettings *) defaultSettingForAnimationType:(DHTextAnimationType)animationType;
@end
