//
//  DHFireworkSettings.h
//  DHAnimation
//
//  Created by Huang Hongsen on 8/31/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>


typedef NS_ENUM(NSInteger, DHFireworkEffectType) {
    DHFireworkEffectTypeExplodeAndFade,
    DHFireworkEffectTypeFastExplosion,
    DHFireworkEffectTypeDoubleExplosion,
};

@interface DHFireworkSettings : NSObject

@property (nonatomic) DHFireworkEffectType fireworkType;
@property (nonatomic) NSInteger explosionCount;
@property (nonatomic) NSInteger tailParticleCount;
@property (nonatomic) GLKVector3 explosionPosition;
@property (nonatomic) NSTimeInterval explosionTime;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) GLfloat baseVelocity;
@property (nonatomic) GLfloat gravity;

+ (DHFireworkSettings *)randomFireworkInView:(UIView *)view duration:(NSTimeInterval)duration startTime:(NSTimeInterval)startTime;
@end
