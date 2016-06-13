//
//  DHFireworkEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"

@interface DHFireworkEffect : DHParticleEffect

- (instancetype) initWithContext:(EAGLContext *)context exposionPosition:(GLKVector3)position emissionTime:(GLfloat)emissionTime;

@end
