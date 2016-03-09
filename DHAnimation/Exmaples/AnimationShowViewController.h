//
//  AnimationShowViewController.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"
#import "NSBKeyframeAnimationFunctions.h"
#import "DHAnimationRenderer.h"
@interface AnimationShowViewController : UIViewController

@property (nonatomic) AnimationType animationType;
@property (nonatomic, strong) DHAnimationRenderer *renderer;

- (void) performAnimation;

@end
