//
//  DHShimmerEffect.h
//  Shimmer
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"

@interface DHShimmerParticleEffect : DHParticleEffect
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger rowCount;
@property (nonatomic, strong) NSArray *offsetData;

- (instancetype) initWithContext:(EAGLContext *)context columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount targetView:(UIView *)targetView containerView:(UIView *)containerView offsetData:(NSArray *)offsetData;

@end
