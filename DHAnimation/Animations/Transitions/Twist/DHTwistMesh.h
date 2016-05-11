//
//  TwistSourceMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHConsecutiveTextureSceneMesh.h"
#import "DHConstants.h"
@interface DHTwistMesh : DHConsecutiveTextureSceneMesh

- (void) updateWithRotation:(CGFloat)rotation transition:(CGFloat)transition direction:(DHAnimationDirection)direction;

@end
