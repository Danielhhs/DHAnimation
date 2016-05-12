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

- (GLKVector3) rotatedPosition:(GLKVector3)position
{
    CGFloat originX = self.targetView.frame.origin.x;
    
    UIView *view = self.targetView;
    GLKMatrix4 transformMatrix = GLKMatrix4Identity;
    if (!CGAffineTransformIsIdentity(view.transform)) {
        float angle = atan(view.transform.c / view.transform.a);
        transformMatrix = GLKMatrix4MakeTranslation(-(originX + view.bounds.size.width / 2), -(self.containerView.frame.size.height - CGRectGetMaxY(view.frame) + view.bounds.size.height / 2), 0);
        GLKMatrix4 rotationMatrix = GLKMatrix4MakeRotation(angle, 0, 0, 1);
        transformMatrix = GLKMatrix4Multiply(rotationMatrix, transformMatrix);
        GLKMatrix4 translateBackMatrix = GLKMatrix4MakeTranslation(originX + view.frame.size.width / 2, self.containerView.frame.size.height - CGRectGetMaxY(view.frame) + view.frame.size.height / 2, 0);
        transformMatrix = GLKMatrix4Multiply(translateBackMatrix, transformMatrix);
    }
    GLKVector4 rotatedPos = GLKVector4Make(position.x, position.y, position.z, 1);
    rotatedPos = GLKMatrix4MultiplyVector4(transformMatrix, rotatedPos);
    return GLKVector3Make(rotatedPos.x, rotatedPos.y, rotatedPos.z);
}
@end
