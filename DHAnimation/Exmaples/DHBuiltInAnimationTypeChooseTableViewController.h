//
//  ParticleAnimationTypeChooseTableViewController.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHConstants.h"
@interface DHBuiltInAnimationTypeChooseTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *animations;
@property (nonatomic) DHAnimationEvent animationEvent;
@end
