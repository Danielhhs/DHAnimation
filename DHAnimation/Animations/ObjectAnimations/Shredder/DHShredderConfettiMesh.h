//
//  DHShredderConfettiMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 8/2/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <DHAnimationFramework/DHAnimationFramework.h>

@interface DHShredderConfettiMesh : DHSceneMesh

- (instancetype) initWithTargetView:(UIView *)targetView containerView:(UIView *)containerView;
- (void) appendConfettiAtPosition:(GLKVector3)position length:(GLfloat)length startFallingTime:(GLfloat)startFallingTime;
@end
