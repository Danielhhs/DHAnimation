//
//  AnimationShowViewController.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHConstants.h"
#import "NSBKeyframeAnimationFunctions.h"
#import "DHTransitionRenderer.h"
@interface DHTransitionPresentationViewController : UIViewController

@property (nonatomic) DHTransitionType animationType;
@property (nonatomic, strong) DHTransitionRenderer *renderer;

- (void) performAnimation;

@end
