//
//  DHDustEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 4/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"
#import "DHTimingFunctionHelper.h"

typedef NS_ENUM(NSInteger, DHDustEmissionDirection) {
    DHDustEmissionDirectionLeft = 0,
    DHDustEmissionDirectionRight = 1,
    DHDustEmissionDirectionHorizontal = 2,
};

@interface DHDustEffect : DHParticleEffect

//If you are using emission for single direction, like left & right, this is the position where the emission happens;
//If you are using emission for all directions, this is the left-most position for the emission; also, you need to set the emissionWidth to indicate the range for emission
@property (nonatomic) GLKVector3 emitPosition;
@property (nonatomic) GLfloat emissionWidth;    //Only necessary for emission for all horizontal directions;
@property (nonatomic) int numberOfEmissions;    //Only necessary for emission for all horizontal directions;
@property (nonatomic) int numberOfParticlesPerEmission; //Only necessary for emission for all horizontal directions;

@property (nonatomic) DHDustEmissionDirection direction;
@property (nonatomic) GLfloat dustWidth;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) GLfloat emissionRadius;
@property (nonatomic) DHTimingFunction timingFuntion;

@end
