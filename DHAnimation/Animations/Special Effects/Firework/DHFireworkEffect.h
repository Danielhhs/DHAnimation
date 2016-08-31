//
//  DHFireworkEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"
#import "DHFireworkSettings.h"

@interface DHFireworkEffect : DHParticleEffect

@property (nonatomic) DHFireworkEffectType fireworkType;
@property (nonatomic) NSInteger explosionCount;
@property (nonatomic) NSInteger tailParticleCount;

- (void) addFireworkOfType:(DHFireworkEffectType)type
                atPosition:(GLKVector3)explosionPosition
             explosionTime:(NSTimeInterval)explosionTime
                  duration:(NSTimeInterval)duration
                     color:(UIColor *)color
              baseVelocity:(GLfloat)baseVelocity
            explosionCount:(NSInteger)explosionCount
         tailParticleCount:(NSInteger)tailParticleCount;
@end
