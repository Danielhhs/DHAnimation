//
//  DHFireworkSettings.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/31/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFireworkSettings.h"

#define EXPLOSION_COUNT_PER_SECOND 3
#define EXPLOSION_TIME_RATIO 0.382
#define MAX_EXPLOSION_RATIO 0.382
#define MIN_EXPLOSION_RATIO 0.2

@implementation DHFireworkSettings

+ (DHFireworkSettings *) randomFireworkInView:(UIView *)view duration:(NSTimeInterval)duration startTime:(NSTimeInterval)startTime
{
    DHFireworkSettings *settings = [[DHFireworkSettings alloc] init];
    settings.fireworkType = arc4random() % 3;
    switch (settings.fireworkType) {
        case DHFireworkEffectTypeFastExplosion: {
            settings.tailParticleCount = 200;
            settings.explosionCount = 20;
        }
            break;
        case DHFireworkEffectTypeExplodeAndFade: {
            settings.tailParticleCount = 200;
            settings.explosionCount = 50;
            break;
        }
        case DHFireworkEffectTypeDoubleExplosion: {
            settings.tailParticleCount = 200;
            settings.explosionCount = 15;
            break;
        }
    }
    settings.explosionPosition = [DHFireworkSettings randomExplosionPositionInView:view];
    settings.explosionTime = [self randomExplosionTimeWithStartTime:startTime];
    settings.duration = [DHFireworkSettings randomDurationWithAnimationDuration:duration startTime:settings.explosionTime];
    settings.color = [DHFireworkSettings randomColor];
    settings.baseVelocity = [DHFireworkSettings randomVelocity];
    return settings;
}

+ (GLKVector3) randomExplosionPositionInView:(UIView *)view
{
    GLfloat x = ((arc4random() % 100) / 100.f * (1 - MIN_EXPLOSION_RATIO * 2) + MIN_EXPLOSION_RATIO) * view.frame.size.width;
    GLfloat y = ((arc4random() % 100) / 100.f * (1 - MIN_EXPLOSION_RATIO * 2) + MIN_EXPLOSION_RATIO) * view.frame.size.height;
    GLfloat z = (arc4random() % 100) / 100.f * 200 + view.frame.size.height / 2;
    return GLKVector3Make(x, y, z);
}

+ (GLfloat) randomDurationWithAnimationDuration:(NSTimeInterval)animationDuration startTime:(NSTimeInterval)startTime
{
    NSTimeInterval maxTime = animationDuration - startTime;
    return maxTime * 0.5 * (1 + [DHFireworkSettings randomBetweenZeroToOne]);
}

+ (NSTimeInterval) randomExplosionTimeWithStartTime:(NSTimeInterval)startTime
{
    CGFloat emissionTime = [DHFireworkSettings randomBetweenZeroToOne] + startTime;
    return emissionTime;
}

+ (CGFloat) randomBetweenZeroToOne
{
    int random = arc4random() % 1000;
    return random / 1000.f;
}

+ (UIColor *) randomColor
{
    return [UIColor colorWithRed:[self randomColorComponent] green:[self randomColorComponent] blue:[self randomColorComponent] alpha:1.f];
}

+ (CGFloat) randomColorComponent
{
    return arc4random() % 255 / 255.f;
}

+ (GLfloat) randomVelocity
{
    return arc4random() % 150 + 150;
}
@end
