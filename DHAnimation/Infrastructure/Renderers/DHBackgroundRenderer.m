//
//  DHBackgroundRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 5/15/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBackgroundRenderer.h"

static DHBackgroundRenderer *sharedInstance;

@implementation DHBackgroundRenderer

+ (DHBackgroundRenderer *) backgroundRenderer
{
    if (sharedInstance == nil) {
        sharedInstance = [[DHBackgroundRenderer alloc] init];
    }
    return sharedInstance;
}

@end
