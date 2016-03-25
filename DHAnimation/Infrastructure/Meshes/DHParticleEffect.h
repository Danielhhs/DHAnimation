//
//  DHParticleEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/25/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface DHParticleEffect : NSObject
@property (nonatomic, strong) NSString *particleVertexShaderFileName;
@property (nonatomic, strong) NSString *particleFragmentShaderFileName;
@property (nonatomic, weak) GLKView *animationView;


- (void) setupMVPMatrix;
@end
