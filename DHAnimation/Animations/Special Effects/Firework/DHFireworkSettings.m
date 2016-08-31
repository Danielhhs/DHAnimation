//
//  DHFireworkSettings.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/31/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFireworkSettings.h"

@implementation DHFireworkSettings

+ (DHFireworkSettings *) randomFirework
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
            settings.tailParticleCount = 50;
            settings.explosionCount = 150;
            break;
        }
        case DHFireworkEffectTypeDoubleExplosion: {
            settings.tailParticleCount = 200;
            settings.explosionCount = 15;
            break;
        }
    }
    return settings;
}

@end
