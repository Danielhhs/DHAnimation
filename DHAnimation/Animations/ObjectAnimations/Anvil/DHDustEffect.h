//
//  DHDustEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 4/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"

typedef NS_ENUM(NSInteger, DHDustEmissionDirection) {
    DHDustEmissionDirectionLeft = 0,
    DHDustEmissionDirectionRight = 1,
    DHDustEmissionDirectionHorizontal = 2,
};

@interface DHDustEffect : DHParticleEffect

@property (nonatomic) GLKVector3 emitPosition;
@property (nonatomic) DHDustEmissionDirection direction;
@property (nonatomic) GLfloat dustWidth;

- (instancetype) initWithContext:(EAGLContext *)context emitPosition:(GLKVector3)emitPosition direction:(DHDustEmissionDirection)direction dustWidth:(GLfloat)dustWidth;
@end
