//
//  DHParticleEffect.m
//  Shimmer
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
@implementation DHParticleEffect

- (instancetype) initWithContext:(EAGLContext *)context
{
    self = [super init];
    if (self) {
        _context = context;
        [self setupGL];
        [self setupTextures];
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
    elapsedTimeLoc = glGetUniformLocation(program, "u_elapsedTime");
    [self setupExtraUniforms];
}

- (void) setupExtraUniforms
{
    
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithImage:[UIImage imageNamed:self.particleImageName]];
}

- (void) generateParticlesData
{
}

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    self.percent = percent;
    self.elapsedTime = elapsedTime;
}

@end
