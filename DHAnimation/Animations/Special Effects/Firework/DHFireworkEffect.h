//
//  DHFireworkEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"

typedef NS_ENUM(NSInteger, DHFireworkEffectType) {
    DHFireworkEffectTypeExplodeAndFade,
    DHFireworkEffectTypeFastExplosion,
    DHFireworkEffectTypeDoubleExplosion,
};

@interface DHFireworkEffect : DHParticleEffect

@property (nonatomic) DHFireworkEffectType fireworkType;
@property (nonatomic) NSInteger explosionCount;
@property (nonatomic) NSInteger tailParticleCount;

- (void) addExplosionAtPosition:(GLKVector3)explosionPosition explosionTime:(NSTimeInterval)explosionTime duration:(NSTimeInterval)duration color:(UIColor *)color baseVelocity:(GLfloat)baseVelocity;

@end
