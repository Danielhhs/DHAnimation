//
//  DHFaceExplosionEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 5/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFaceExplosionEffect.h"
#import <OpenGLES/ES3/glext.h>
#import "NSBKeyframeAnimationFunctions.h"
#define FACE_EXPLOSION_PARTICLE_SIZE 8

typedef struct {
    GLKVector3 startingPosition;
    GLKVector3 targetingPosition;
}DHFaceExplosionEffectAttributes;

@interface DHFaceExplosionEffect() {
    GLuint columnCount, rowCount;
    GLuint pointSizeLoc;
}

@end

@implementation DHFaceExplosionEffect

- (instancetype) initWithContext:(EAGLContext *)context targetView:(UIView *)view containerView:(UIView *)containerView
{
    self = [super initWithContext:context];
    if (self) {
        columnCount = view.bounds.size.width / FACE_EXPLOSION_PARTICLE_SIZE;
        rowCount = view.bounds.size.height / FACE_EXPLOSION_PARTICLE_SIZE;
        self.containerView = containerView;
        self.targetView = view;
        [self generateParticlesData];
    }
    return self;
}

- (void) setupGL
{
    [super setupGL];
    pointSizeLoc = glGetUniformLocation(program, "u_pointSize");
}

- (NSString *) vertexShaderFileName
{
    return @"FaceExplosionEffectVertex.glsl";
}

- (NSString *) fragmentShaderFileName
{
    return @"FaceExplosionEffectFragment.glsl";
}

- (NSString *) particleImageName
{
    return [DHConstants resourcePathForFile:@"explosion" ofType:@"png"];
}

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
    for (int i = 0; i < columnCount; i++) {
        GLfloat xPos = self.targetView.frame.origin.x + FACE_EXPLOSION_PARTICLE_SIZE * i;
        for (int j = 0; j < rowCount; j++) {
            DHFaceExplosionEffectAttributes particle;
            GLfloat yPos = self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame) + j * FACE_EXPLOSION_PARTICLE_SIZE;
            particle.startingPosition = [self rotatedPosition:GLKVector3Make(xPos, yPos, 0)];
            particle.targetingPosition = GLKVector3Make(particle.startingPosition.x + [self randomOffset], particle.startingPosition.y + [self randomOffset], [self randomZPosition]);
            [self.particleData appendBytes:&particle length:sizeof(particle)];
        }
    }
    [self prepareToDraw];
}

- (GLfloat) randomZPosition
{
    return arc4random() % 1000;
}

- (GLfloat) randomOffset
{
    return (int)arc4random() % 20 - 10;
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_DYNAMIC_DRAW);
    }
    glGenVertexArrays(1, &vertexArray);
    glBindVertexArray(vertexArray);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHFaceExplosionEffectAttributes), NULL + offsetof(DHFaceExplosionEffectAttributes, startingPosition));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(DHFaceExplosionEffectAttributes), NULL + offsetof(DHFaceExplosionEffectAttributes, targetingPosition));
    
    glBindVertexArray(0);
}

- (void) draw
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(percentLoc, self.percent);
    glUniform1f(pointSizeLoc, FACE_EXPLOSION_PARTICLE_SIZE * [UIScreen mainScreen].scale);
    
    glBindVertexArray(vertexArray);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, rowCount * columnCount);
    glBindVertexArray(0);
}

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    elapsedTime = MAX(0, elapsedTime - self.startTime);
    self.percent = NSBKeyframeAnimationFunctionEaseOutExpo(elapsedTime * 1000, 0, 1, self.duration * 1000);
}
@end
