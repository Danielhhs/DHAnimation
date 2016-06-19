//
//  DHPointExplosionEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/16/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <DHAnimationFramework/DHAnimationFramework.h>

@interface DHPointExplosionEffect : DHParticleEffect
- (instancetype) initWithContext:(EAGLContext *)context emissionPosition:(GLKVector3)emissionPosition numberOfParticles:(NSInteger)numberOfParticles startTime:(NSTimeInterval)startTime;
@end
