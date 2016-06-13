//
//  DHFireworkEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFireworkEffect.h"

#define FIREWORK_TAIL_COUNT 150

typedef struct {
    GLKVector3 direction;
    GLfloat velocity;
    GLfloat emissionTime;
}DHFireworkEffectAttributes;

typedef struct {
    GLKVector3 position;
    GLfloat appearTime;
    GLfloat lifeTime;
}DHFireworkTailAttributes;
@interface DHFireworkEffect () {
    GLuint emissionPositionLoc, timeLoc, durationLoc, gravityLoc;
}
@property (nonatomic) GLKVector3 emissionPosition;
@property (nonatomic) GLfloat emissionTime;
@end

@implementation DHFireworkEffect

- (instancetype) initWithContext:(EAGLContext *)context exposionPosition:(GLKVector3)position emissionTime:(GLfloat) emissionTime
{
    self = [super initWithContext:context];
    if (self) {
        _emissionPosition = position;
        _emissionTime = emissionTime;
        [self generateParticlesData];
    }
    return self;
}

- (void) setupExtraUniforms
{
    emissionPositionLoc = glGetUniformLocation(program, "u_emissionPosition");
    timeLoc = glGetUniformLocation(program, "u_time");
    durationLoc = glGetUniformLocation(program, "u_duration");
    gravityLoc = glGetUniformLocation(program, "u_gravity");
}

- (NSString *) vertexShaderFileName
{
    return @"FireworkVertex.glsl";
}

- (NSString *) fragmentShaderFileName
{
    return @"FireworkFragment.glsl";
}

- (NSString *) particleImageName
{
    return @"firework.png";
}

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
    for (int i = 0; i < FIREWORK_TAIL_COUNT; i++) {
        DHFireworkEffectAttributes particle;
        CGFloat angle = [self randomBetweenZeroToOne] * M_PI * 2;
        CGFloat radius = [self randomBetweenZeroToOne] * 200;
        particle.direction = GLKVector3Normalize(GLKVector3Make(cos(angle) * radius, sin(angle) * radius, [self randomBetweenZeroToOne] * 2 * radius));
        particle.velocity = 100;
        particle.emissionTime = self.emissionTime;
        [self.particleData appendBytes:&particle length:sizeof(particle)];
    }
}

- (CGFloat) randomBetweenZeroToOne
{
    int random = arc4random() % 1000;
    return random / 1000.f;
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
    }
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHFireworkEffectAttributes), NULL + offsetof(DHFireworkEffectAttributes, direction));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkEffectAttributes), NULL + offsetof(DHFireworkEffectAttributes, velocity));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkEffectAttributes), NULL + offsetof(DHFireworkEffectAttributes, emissionTime));
}

- (void) draw
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform3fv(emissionPositionLoc, 1, self.emissionPosition.v);
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(durationLoc, self.duration);
    glUniform1f(gravityLoc, 100);
    
    [self prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.particleData length] / sizeof(DHFireworkEffectAttributes));
}


- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    self.elapsedTime = elapsedTime;
}
@end
