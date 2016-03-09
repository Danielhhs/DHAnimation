//
//  TwistRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "TwistRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"

@interface TwistRenderer () {
    GLuint srcProgram, dstProgram;
    GLuint srcMVPLoc, srcSamplerLoc;
    GLuint dstMVPLoc, dstSamplerLoc;
    
}

@end

@implementation TwistRenderer

- (void) startTwistFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.duration = duration;
    self.timingFunction = timingFunction;
    self.completion = completion;
    [self setupGL];
    [self setupMesh];
    [self setupTexture];
    self.animationView = [[GLKView alloc] initWithFrame:fromView.frame context:self.context];
    self.animationView.delegate = self;
    [containerView addSubview:self.animationView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    srcProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"TwistSourceVertex.glsl" fragmentShaderSrc:@"TwistSourceFragment.glsl"];
    glUseProgram(srcProgram);
    srcMVPLoc = glGetUniformLocation(srcProgram, "u_mvpMatrix");
    srcSamplerLoc = glGetUniformLocation(srcProgram, "s_tex");
    
    dstProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"TwistDestinationVertex.glsl" fragmentShaderSrc:@"TwistDestinationFragment.glsl"];
    glUseProgram(dstProgram);
    dstMVPLoc = glGetUniformLocation(dstProgram, "u_mvpMatrix");
    dstSamplerLoc = glGetUniformLocation(dstSamplerLoc, "s_tex");
}

- (void) setupMesh
{
    
}

- (void) setupTexture
{
    
}

@end
