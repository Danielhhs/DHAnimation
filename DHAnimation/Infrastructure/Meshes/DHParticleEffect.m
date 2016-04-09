//
//  DHParticleEffect.m
//  Shimmer
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"
#import "OpenGLHelper.h"
@implementation DHParticleEffect

- (instancetype) initWithContext:(EAGLContext *)context targetView:(UIView *)targetView containerView:(UIView *)containerView
{
    self = [super init];
    if (self) {
        _context = context;
        _targetView = targetView;
        _containerView = containerView;
        [self setupGL];
    }
    return self;
}

- (void) prepareToDraw
{
    
}

- (void) draw
{
    
}

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    program = [OpenGLHelper loadProgramWithVertexShaderSrc:self.vertexShaderFileName fragmentShaderSrc:self.fragmentShaderFileName];
    glUseProgram(program);
    mvpLoc = glGetUniformLocation(program, "u_mvpMatrix");
    samplerLoc = glGetUniformLocation(program, "s_tex");
    percentLoc = glGetUniformLocation(program, "u_percent");
    backgroundSamplerLoc = glGetUniformLocation(program, "s_texBack");
    eventLoc = glGetUniformLocation(program, "u_event");
    [self setupExtraUniforms];
}

- (void) setupExtraUniforms
{
    
}

@end
