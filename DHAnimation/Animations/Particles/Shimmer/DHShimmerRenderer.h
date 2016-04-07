//
//  ShimmerRenderer.h
//  Shimmer
//
//  Created by Huang Hongsen on 4/1/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface DHShimmerRenderer : NSObject

- (void) startAnimationForView:(UIView *)view inContainerView:(UIView *)containerView completion:(void (^)(void))completion;;
@end
