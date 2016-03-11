//
//  TwistSourceMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "SceneMesh.h"

@interface TwistMesh : SceneMesh

- (void) updateWithRotation:(CGFloat)rotation transition:(CGFloat)transition;

@end
