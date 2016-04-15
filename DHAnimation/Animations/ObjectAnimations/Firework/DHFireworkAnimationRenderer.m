//
//  DHFireworkAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFireworkAnimationRenderer.h"
#import "DHFireworkEffect.h"
@interface DHFireworkAnimationRenderer()
@property (nonatomic, strong) NSMutableArray *fireworkEffects;
@end

#define EXPLOSION_COUNT_PER_SECOND 3
#define EXPLOSION_TIME_RATIO 0.382
#define MAX_EXPLOSION_RATIO 0.382
#define MIN_EXPLOSION_RATIO 0.2
@implementation DHFireworkAnimationRenderer

//- (NSString *) vertexShaderName
//{
//    return @"FireworkBackgroundVertex.glsl";
//}
//
//- (NSString *) fragmentShaderName
//{
//    return @"FireworkBackgroundFragment.glsl";
//}

- (void) setupEffects
{
    self.fireworkEffects = [NSMutableArray array];
    for (int i = 0; i < self.duration * EXPLOSION_COUNT_PER_SECOND; i++) {
        DHFireworkEffect *effect = [[DHFireworkEffect alloc] initWithContext:self.context targetView:self.targetView containerView:self.containerView rowCount:1 columnCount:1 emissionPosition:[self randomEmissionPosition] emissionRadius:[self randomExplosionRadius]];
        effect.explosionRadius = [self randomExplosionRadius];
        effect.mvpMatrix = mvpMatrix;
        [self.fireworkEffects addObject:effect];
    }
}

- (NSTimeInterval) randomEmissionTime
{
    return (arc4random() % 100) / 100.f * self.duration * (1 - EXPLOSION_TIME_RATIO);
}

- (GLfloat) randomExplosionRadius
{
    return ((arc4random() % 100) / 100.f * (MAX_EXPLOSION_RATIO - MIN_EXPLOSION_RATIO) + MIN_EXPLOSION_RATIO) * self.containerView.frame.size.width;
}

- (GLKVector3) randomEmissionPosition
{
    GLfloat x = ((arc4random() % 100) / 100.f * (1 - MIN_EXPLOSION_RATIO * 2) + MIN_EXPLOSION_RATIO) * self.containerView.frame.size.width;
    GLfloat y = ((arc4random() % 100) / 100.f * (1 - MIN_EXPLOSION_RATIO * 2) + MIN_EXPLOSION_RATIO) * self.containerView.frame.size.height;
    GLfloat z = (arc4random() % 100) / 100.f * 200 + self.containerView.frame.size.height / 2;
    return GLKVector3Make(x, y, z);
}

- (void) drawFrame
{
    [super drawFrame];
    
    for (DHFireworkEffect *effect in self.fireworkEffects) {
        if (effect.emissionTime < self.elapsedTime) {
            [effect prepareToDraw];
            [effect draw];
        }
    }
}

- (void) updateAdditionalComponents
{
    for (DHFireworkEffect *effect in self.fireworkEffects) {
        [effect updateWithElapsedTime:self.elapsedTime percent:self.percent];
    }
}

@end
