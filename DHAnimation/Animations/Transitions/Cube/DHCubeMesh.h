//
//  CubeMesh.h
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "SceneMesh.h"
#import "Enums.h"
@interface DHCubeMesh : SceneMesh

- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount transitionDirection:(AnimationDirection)direction;

- (void) drawColumnAtIndex:(NSInteger)index;
@end
