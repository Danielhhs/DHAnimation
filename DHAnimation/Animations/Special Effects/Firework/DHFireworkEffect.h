//
//  DHFireworkEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"

@interface DHFireworkEffect : DHParticleEffect

- (void) addExplosionAtPosition:(GLKVector3)explosionPosition explosionTime:(NSTimeInterval)explosionTime duration:(NSTimeInterval)duration color:(UIColor *)color;

@end
