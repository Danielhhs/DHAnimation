//
//  DHParticleEffect.h
//  Shimmer
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface DHParticleEffect : NSObject
@property (nonatomic) GLKMatrix4 mvpMatrix;
@property (nonatomic) GLfloat percent;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) EAGLContext *context;

- (void) prepareToDraw;
- (void) draw;

@end
