//
//  DHFireworkEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 4/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"

@interface DHFireworkEffect : DHParticleEffect

@property (nonatomic) NSTimeInterval emissionTime;
@property (nonatomic) GLKVector3 emissionPosition;
@property (nonatomic) GLfloat explosionRadius;

- (instancetype) initWithContext:(EAGLContext *)context targetView:(UIView *)targetView containerView:(UIView *)containerView rowCount:(NSInteger)rowCount columnCount:(NSInteger)columnCount emissionPosition:(GLKVector3)emissionPosition emissionRadius:(GLfloat)emissionRadius;

@end
