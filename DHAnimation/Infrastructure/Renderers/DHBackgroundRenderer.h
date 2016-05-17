//
//  DHBackgroundRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 5/15/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationRenderer.h"

@interface DHBackgroundRenderer : DHObjectAnimationRenderer
+ (DHBackgroundRenderer *)backgroundRenderer;

@property (nonatomic, strong) DHObjectAnimationSettings *settings;
- (void) drawBackground;
@end
