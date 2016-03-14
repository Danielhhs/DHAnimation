//
//  ClothLineRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationRenderer.h"

@interface ClothLineRenderer : DHAnimationRenderer

- (void) startClothLineAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion;

@end
