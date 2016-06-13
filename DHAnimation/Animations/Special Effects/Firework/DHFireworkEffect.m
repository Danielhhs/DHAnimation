//
//  DHFireworkEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFireworkEffect.h"
#import <OpenGLES/ES3/glext.h>
#import "NSBKeyframeAnimationFunctions.h"

#define FIREWORK_TAIL_COUNT 150
#define GRAVITY 100

typedef struct {
    GLKVector3 position;
    GLfloat appearTime;
    GLfloat lifeTime;
}DHFireworkTailAttributes;

@interface DHFireworkEffect () {
    GLuint emissionPositionLoc, timeLoc, durationLoc, gravityLoc, colorLoc;
    double red, green, blue, alpha;
}
@property (nonatomic) GLKVector3 emissionPosition;
@property (nonatomic) GLfloat emissionTime;
@end

@implementation DHFireworkEffect

- (instancetype) initWithContext:(EAGLContext *)context exposionPosition:(GLKVector3)position emissionTime:(GLfloat) emissionTime duration:(NSTimeInterval)duration
{
    self = [super initWithContext:context];
    if (self) {
        _emissionPosition = position;
        _emissionTime = emissionTime;
        self.duration = duration;
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
    colorLoc = glGetUniformLocation(program, "u_color");
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
        CGFloat angle = [self randomBetweenZeroToOne] * M_PI * 2;
        CGFloat radius = [self randomBetweenZeroToOne] * 200;
        GLKVector3 direction = GLKVector3Normalize(GLKVector3Make(cos(angle) * radius, sin(angle) * radius, [self randomBetweenZeroToOne] * 2 * radius));
        GLfloat velocity = 120;
        GLfloat emissionTime = self.emissionTime;
        [self generateTailForDirection:direction velocity:velocity emissionTime:emissionTime];
    }
    [self prepareToDraw];
}

- (void) generateTailForDirection:(GLKVector3)direction velocity:(GLfloat)velocity emissionTime:(GLfloat)emissionTime
{
    for (int i = 0; i < 50; i++) {
        DHFireworkTailAttributes particle;
        float appearTime = self.duration / 100.f * i;
        float t = NSBKeyframeAnimationFunctionEaseOutCubic(appearTime * 1000.f, 0.f, self.duration, self.duration * 1000.f);
        GLKVector3 velocityVector = GLKVector3MultiplyScalar(direction, velocity);
        float ax = -velocityVector.x / self.duration;
        float g = ((direction.y + 1.f) / 2.f * GRAVITY) * 0.5 + GRAVITY * 0.5;
        float tsquare = 0.5 * t * t;
        GLKVector3 offset = GLKVector3Add(GLKVector3MultiplyScalar(velocityVector, t), GLKVector3MultiplyScalar(GLKVector3Make(ax, -g, 0.f), tsquare));
        particle.position = GLKVector3Add(self.emissionPosition, offset);
        particle.appearTime = self.emissionTime + appearTime;
        particle.lifeTime = self.duration / 4.f * (1.f - appearTime / self.duration);
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
        glGenVertexArrays(1, &vertexArray);
    }
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHFireworkTailAttributes), NULL + offsetof(DHFireworkTailAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkTailAttributes), NULL + offsetof(DHFireworkTailAttributes, appearTime));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkTailAttributes), NULL + offsetof(DHFireworkTailAttributes, lifeTime));
    
    glBindVertexArray(0);
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
    glUniform4f(colorLoc, red, green, blue, alpha);
    
//    [self prepareToDraw];
    glBindVertexArray(vertexArray);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.particleData length] / sizeof(DHFireworkTailAttributes));
    glBindVertexArray(0);
}


- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    self.elapsedTime = elapsedTime;
    
}

- (void) setColor:(UIColor *)color
{
    _color = color;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
}
@end
