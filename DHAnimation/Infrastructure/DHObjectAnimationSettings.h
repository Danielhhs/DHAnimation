//
//  DHObjectAnimationSettings.h
//  DHAnimation
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"
#import "DHTimingFunctionHelper.h"
@interface DHObjectAnimationSettings : NSObject

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) AnimationDirection direction;
@property (nonatomic) AnimationEvent event;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic) DHTimingFunction timingFunction;
@property (nonatomic, strong) void (^completion)(void);
@property (nonatomic) NSInteger rowCount;
@property (nonatomic) NSInteger columnCount;

+ (DHObjectAnimationSettings *)defaultSettings;
@end
