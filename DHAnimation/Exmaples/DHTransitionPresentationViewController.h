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
#import "DHTransitionRenderer.h"
@interface DHTransitionPresentationViewController : UIViewController

@property (nonatomic) TransitionType animationType;
@property (nonatomic, strong) DHTransitionRenderer *renderer;

- (void) performAnimation;

@end
