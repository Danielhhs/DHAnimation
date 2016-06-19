//
//  DHPointExplosionAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/16/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHPointExplosionAnimationRenderer.h"
#import "DHPointExplosionEffect.h"

@interface DHPointExplosionAnimationRenderer () {
    
}
@property (nonatomic, strong) DHPointExplosionEffect *effect;
@end

@implementation DHPointExplosionAnimationRenderer

//- (NSString *) vertexShaderName
//{
//    return @"ObjectPointExplosionVertex.glsl";
//}
//
//- (NSString *) fragmentShaderName
//{
//    return @"ObjectPointExplosionFragment.glsl";
//}

- (void) drawFrame
{
    [super drawFrame];
    [self.effect draw];
}

- (void) setupEffects
{
    self.effect = [[DHPointExplosionEffect alloc] initWithContext:self.context emissionPosition:GLKVector3Make(CGRectGetMidX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame), 0.f) numberOfParticles:20 startTime:0];
    self.effect.mvpMatrix = mvpMatrix;
    self.effect.duration = 2.f;
}

- (void) updateAdditionalComponents
{
    [self.effect updateWithElapsedTime:self.elapsedTime percent:self.percent];
}

@end
