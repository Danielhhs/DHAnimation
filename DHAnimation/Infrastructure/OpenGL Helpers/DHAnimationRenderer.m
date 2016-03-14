//
//  DHAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationRenderer.h"
#import "OpenGLHelper.h"

@implementation DHAnimationRenderer

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
}

- (void) performAnimationWithSettings:(DHAnimationSettings *)settings
{
    
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        GLfloat populatedTime = self.timingFunction(self.elapsedTime * 1000, 0, self.duration, self.duration * 1000);
        self.percent = populatedTime / self.duration;
        [self.animationView display];
    } else {
        self.percent = 1;
        [self.animationView display];
        [displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        if (self.completion) {
            self.completion();
        }
        [self tearDownGL];
    }
}

- (void) tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    [self.srcMesh tearDown];
    [self.dstMesh tearDown];
    if (srcTexture) {
        glDeleteTextures(1, &srcTexture);
        srcTexture = 0;
    }
    if (dstTexture) {
        glDeleteTextures(1, &dstTexture);
        dstTexture = 0;
    }
    if (srcProgram) {
        glDeleteProgram(srcProgram);
        srcProgram = 0;
    }
    if (dstProgram) {
        glDeleteProgram(dstProgram);
        dstProgram = 0;
    }
    self.animationView = nil;
    [EAGLContext setCurrentContext:nil];
    self.context = nil;
}

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    if (self.srcVertexShaderFileName && self.srcFragmentShaderFileName) {
        srcProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:self.srcVertexShaderFileName fragmentShaderSrc:self.srcFragmentShaderFileName];
        glUseProgram(srcProgram);
        srcMvpLoc = glGetUniformLocation(srcProgram, "u_mvpMatrix");
        srcSamplerLoc = glGetUniformLocation(srcProgram, "s_tex");
    }
    if (self.dstVertexShaderFileName && self.dstFragmentShaderFileName) {
        dstProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:self.dstVertexShaderFileName fragmentShaderSrc:self.dstFragmentShaderFileName];
        glUseProgram(dstProgram);
        dstMvpLoc = glGetUniformLocation(dstProgram, "u_mvpMatrix");
        dstSamplerLoc = glGetUniformLocation(dstProgram, "s_tex");
    }
    glClearColor(0, 0, 0, 1);
}

@end
