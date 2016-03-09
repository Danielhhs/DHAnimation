//
//  DHAnimationRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHAnimationSettings.h"

@interface DHAnimationRenderer : NSObject<GLKViewDelegate>

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKView *animationView;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic, strong) void(^completion)(void);
@property (nonatomic) NSBKeyframeAnimationFunction timingFunction;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) CGFloat percent;

- (void) performAnimationWithSettings:(DHAnimationSettings *)settings;
- (void) update:(CADisplayLink *)displayLink;
- (void) tearDownGL;
@end
