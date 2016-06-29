//
//  DHFlameEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFlameEffect.h"
#import <OpenGLES/ES3/glext.h>

typedef struct {
    GLfloat lifeTime;
    GLfloat xPosition;
    GLfloat pointSize;
    GLKVector2 color;
    GLfloat emitTime;
    GLfloat rotation;
    GLKVector2 yRange;
}DHFlameEffectAttributes;

#define FLAME_COLUMN_COUNT 10

@interface DHFlameEffect () {
    GLuint timeLoc;
}

@end

@implementation DHFlameEffect

- (instancetype) initWithContext:(EAGLContext *)context targetView:(UIView *)targetView containerView:(UIView *)containerView
{
    self = [super initWithContext:context];
    if (self) {
        self.targetView = targetView;
        self.containerView = containerView;
        [self generateParticlesData];
    }
    return self;
}

- (void) setupExtraUniforms
{
    timeLoc = glGetUniformLocation(program, "u_time");
}

- (NSString *) vertexShaderFileName
{
    return @"FlameEffectVertex.glsl";
}

- (NSString *) fragmentShaderFileName
{
    return @"FlameEffectFragment.glsl";
}

- (NSString *) particleImageName
{
    return [DHConstants resourcePathForFile:@"flame" ofType:@"gif"];
}

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
}

- (GLfloat) randomBetweenZeroToOne
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
    glVertexAttribPointer(0, 1, GL_FLOAT, GL_FALSE, sizeof(DHFlameEffectAttributes), NULL + offsetof(DHFlameEffectAttributes, lifeTime));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 1, GL_FLOAT, GL_FALSE, sizeof(DHFlameEffectAttributes), NULL + offsetof(DHFlameEffectAttributes, xPosition));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHFlameEffectAttributes), NULL + offsetof(DHFlameEffectAttributes, pointSize));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 2, GL_FLOAT, GL_FALSE, sizeof(DHFlameEffectAttributes), NULL + offsetof(DHFlameEffectAttributes, color));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHFlameEffectAttributes), NULL + offsetof(DHFlameEffectAttributes, emitTime));
    
    glEnableVertexAttribArray(5);
    glVertexAttribPointer(5, 1, GL_FLOAT, GL_FALSE, sizeof(DHFlameEffectAttributes), NULL + offsetof(DHFlameEffectAttributes, rotation));
    
    glEnableVertexAttribArray(6);
    glVertexAttribPointer(6, 2, GL_FLOAT, GL_FALSE, sizeof(DHFlameEffectAttributes), NULL + offsetof(DHFlameEffectAttributes, yRange));
}

- (void) draw
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(percentLoc, self.percent);
    [self prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.particleData length] / sizeof(DHFlameEffectAttributes));
}

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    self.elapsedTime = elapsedTime;
    self.percent = percent;
    if (percent < 0.8) {
        for (int i = 0; i < FLAME_COLUMN_COUNT; i++) {
            DHFlameEffectAttributes particle;
            particle.lifeTime = self.duration * 0.2 * (1 + [self timeDifferentiator]);
            particle.xPosition = self.targetView.frame.origin.x + (GLfloat)i / FLAME_COLUMN_COUNT * self.targetView.frame.size.width;
            particle.pointSize = 80 * [self randomBetweenZeroToOne] + 20;
            particle.color = GLKVector2Make([self randomBetweenZeroToOne], [self randomBetweenZeroToOne] * 0.2);
            particle.emitTime = elapsedTime;
            particle.rotation = [self randomBetweenZeroToOne] * 10 * M_PI;
            GLfloat emitY = self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame);
            particle.yRange = GLKVector2Make(emitY, self.targetView.frame.size.height * (0.618 + [self timeDifferentiator]));
            [self.particleData appendBytes:&particle length:sizeof(particle)];
        }
    }
}

- (CGFloat) timeDifferentiator
{
    int random = arc4random() % 200;
    return (random - 100) / 300.f;
}
@end
