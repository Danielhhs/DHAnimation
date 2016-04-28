//
//  DHDustEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHDustEffect.h"

typedef struct {
    GLKVector3 position;
    GLKVector3 targetPosition;
    GLfloat pointSize;
    GLfloat targetPointSize;
} DHDustEffectAttributes;

#define PARTICLE_COUNT 500
@implementation DHDustEffect

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
    for (int i = 0; i < PARTICLE_COUNT; i++) {
        DHDustEffectAttributes dust;
        dust.position = self.emitPosition;
        dust.pointSize = 10.f;
        dust.targetPosition = [self randomTargetPosition];
        [self.particleData appendBytes:&dust length:sizeof(dust)];
    }
}

- (GLKVector3) randomTargetPosition
{
    GLKVector3 position;
    position.x = [self randomPercent] * self.dustWidth;
    position.y = [self randomPercent] * self.dustHeight;
    position.z = [self randomPercent] * self.dustWidth;
    return position;
}

- (GLfloat) randomPercent
{
    return arc4random() % 100 / 100.f;
}
@end
