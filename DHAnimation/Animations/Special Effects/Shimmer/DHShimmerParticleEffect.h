//
//  DHShimmerEffect.h
//  Shimmer
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"
#import "DHConstants.h"

@interface DHShimmerParticleEffect : DHParticleEffect
@property (nonatomic, strong) NSArray *offsetData;
@property (nonatomic) DHAnimationEvent event;
@property (nonatomic) DHAnimationDirection direction;

- (instancetype) initWithContext:(EAGLContext *)context columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount targetView:(UIView *)targetView containerView:(UIView *)containerView offsetData:(NSArray *)offsetData event:(DHAnimationEvent)event;

@end
