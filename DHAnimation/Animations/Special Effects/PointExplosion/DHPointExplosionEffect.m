//
//  DHPointExplosionEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/16/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHPointExplosionEffect.h"
#import <OpenGLES/ES3/glext.h>

typedef struct {
    GLKVector3 direction;
    GLfloat velocity;
    GLfloat pointSize;
} DHPointExplosionEffectAttributes;

@interface DHPointExplosionEffect () {
    GLuint gravityLoc, timeLoc, emissionPositionLoc;
}
@property (nonatomic) NSInteger numberOfParticles;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) GLKVector3 emissionPosition;
@end

@implementation DHPointExplosionEffect

- (instancetype) initWithContext:(EAGLContext *)context emissionPosition:(GLKVector3)emissionPosition numberOfParticles:(NSInteger)numberOfParticles startTime:(NSTimeInterval)startTime
{
    self = [super initWithContext:context];
    if (self) {
        _numberOfParticles = numberOfParticles;
        _startTime = startTime;
        _emissionPosition = emissionPosition;
        [self generateParticlesData];
    }
    return self;
}

- (NSString *) vertexShaderFileName
{
    return @"PointExplosionVertex.glsl";
}

- (NSString *) fragmentShaderFileName
{
    return @"PointExplosionFragment.glsl";
}

- (void) setupExtraUniforms
{
    gravityLoc = glGetUniformLocation(program, "u_gravity");
    timeLoc = glGetUniformLocation(program, "u_time");
}

- (NSString *) particleImageName
{
    return @"Sparkle2.png";
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
        glGenVertexArrays(1, &vertexArray);
    }
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHPointExplosionEffectAttributes), NULL + offsetof(DHPointExplosionEffectAttributes, direction));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 1, GL_FLOAT, GL_FALSE, sizeof(DHPointExplosionEffectAttributes), NULL + offsetof(DHPointExplosionEffectAttributes, velocity));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHPointExplosionEffectAttributes), NULL + offsetof(DHPointExplosionEffectAttributes, pointSize));
    
    glBindVertexArray(0);
}

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
    for (int i = 0; i < self.numberOfParticles; i++) {
        DHPointExplosionEffectAttributes particle;
        particle.direction = [self randomDirection];
        particle.velocity = [self randomVelocity];
        particle.pointSize = arc4random() % 10 + 10;
        [self.particleData appendBytes:&particle length:sizeof(particle)];
    }
    [self prepareToDraw];
}

- (GLKVector3) randomDirection
{
    GLfloat x = (int)(arc4random() % 400) - 200;
    GLfloat y = arc4random() % 500;
    GLfloat z = (int)arc4random() % 700;
    return GLKVector3Normalize(GLKVector3Make(x, y, z));
}

- (GLfloat) randomVelocity
{
    return arc4random() % 200 + 500;
}

- (void) draw
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform3f(emissionPositionLoc, self.emissionPosition.x, self.emissionPosition.y, self.emissionPosition.z);
    glUniform1f(gravityLoc, 700);
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(percentLoc, self.percent);
    
    glBindVertexArray(vertexArray);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.particleData length] / sizeof(DHPointExplosionEffectAttributes));
    glBindVertexArray(0);
}

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    self.elapsedTime = elapsedTime;
    self.percent = percent;
}

@end
