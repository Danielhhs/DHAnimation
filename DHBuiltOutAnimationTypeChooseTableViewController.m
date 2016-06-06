//
//  DHBuiltOutAnimationTypeChooseTableViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/2/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBuiltOutAnimationTypeChooseTableViewController.h"
#import "DHConstants.h"

@implementation DHBuiltOutAnimationTypeChooseTableViewController


- (NSArray *) animations
{
    return [DHConstants builtOutAnimations];
}


- (DHAnimationEvent)animationEvent {
    return DHAnimationEventBuiltOut;
}
@end
