//
//  DHFaceExplosionEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 5/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"
#import "DHConstants.h"

@interface DHFaceExplosionEffect : DHParticleEffect
- (instancetype) initWithContext:(EAGLContext *)context targetView:(UIView *)view containerView:(UIView *)containerView;

@property (nonatomic) NSTimeInterval startTime;
@end
