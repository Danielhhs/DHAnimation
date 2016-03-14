//
//  DHAnimationRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHAnimationSettings.h"
#import "SceneMesh.h"

@interface DHAnimationRenderer : NSObject<GLKViewDelegate> {
    GLuint srcProgram, dstProgram;
    GLuint srcTexture, dstTexture;
    GLuint srcMvpLoc, srcSamplerLoc;
    GLuint dstMvpLoc, dstSamplerLoc;
}

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKView *animationView;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic, strong) void(^completion)(void);
@property (nonatomic) NSBKeyframeAnimationFunction timingFunction;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) CGFloat percent;
@property (nonatomic) AnimationDirection direction;

@property (nonatomic, strong) NSString *srcVertexShaderFileName;
@property (nonatomic, strong) NSString *srcFragmentShaderFileName;
@property (nonatomic, strong) NSString *dstVertexShaderFileName;
@property (nonatomic, strong) NSString *dstFragmentShaderFileName;

@property (nonatomic, strong) SceneMesh *srcMesh;
@property (nonatomic, strong) SceneMesh *dstMesh;

- (void) performAnimationWithSettings:(DHAnimationSettings *)settings;
- (void) update:(CADisplayLink *)displayLink;
- (void) setupGL;
- (void) tearDownGL;
@end
