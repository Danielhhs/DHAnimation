//
//  TwistSourceMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "SceneMesh.h"
#import "DHConstans.h"
@interface DHTwistMesh : SceneMesh

- (void) updateWithRotation:(CGFloat)rotation transition:(CGFloat)transition direction:(AnimationDirection)direction;

@end
