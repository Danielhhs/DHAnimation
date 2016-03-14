//
//  ClothLineRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "ClothLineRenderer.h"

@interface ClothLineRenderer()
@property (nonatomic, strong) SceneMesh *sourceMesh;
@property (nonatomic, strong) SceneMesh *destinationMesh;
@end

@implementation ClothLineRenderer

- (void) startClothLineAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    self.duration = duration;
    self.timingFunction = timingFunction;
    self.completion = completion;
    self.elapsedTime = 0;
    self.percent = 0;
}

@end
