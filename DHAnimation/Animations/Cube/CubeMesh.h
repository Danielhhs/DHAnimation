//
//  CubeMesh.h
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "SceneMesh.h"
#import "Enums.h"
@interface CubeMesh : SceneMesh

- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount transitionDirection:(AnimationDirection)direction;
@property (nonatomic) NSInteger columnCount;

- (void) drawColumnAtIndex:(NSInteger)index;
@end
