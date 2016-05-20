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
        sharedInstance.settings = [DHObjectAnimationSettings defaultSettings];
    }
    return sharedInstance;
}


- (void) drawFrame
{
    [super drawFrame];
}

- (void) drawBackground
{
    [sharedInstance prepareAnimationWithSettings:sharedInstance.settings];
    [sharedInstance startAnimation];
}

- (void) setupMeshes
{
    
}

- (void) setupTextures
{
    
}

- (BOOL) shouldTearDownGL
{
    return NO;
}
@end
