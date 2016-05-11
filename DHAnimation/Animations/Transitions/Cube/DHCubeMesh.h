//
//  CubeMesh.h
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSceneMesh.h"
#import "DHConstants.h"
@interface DHCubeMesh : DHSceneMesh

- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount transitionDirection:(DHAnimationDirection)direction;

- (void) drawColumnAtIndex:(NSInteger)index;
@end
