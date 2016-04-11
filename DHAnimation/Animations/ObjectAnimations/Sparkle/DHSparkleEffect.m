//
//  DHSparkleEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSparkleEffect.h"
#import "OpenGLHelper.h"

typedef struct {
    GLKVector3 emitterPosition;
    GLKVector3 emitterVelocity;
    GLKVector3 emitterGravity;
    GLfloat emitTime;
    GLfloat lifeTime;
    GLfloat size;
}DHSparkleAttributes;

#define MAX_SPARKLE_SIZE 100

@interface DHSparkleEffect() {
}

@property (nonatomic) NSInteger numberOfParticles;
@property (nonatomic) CGFloat yResolution;
@end

@implementation DHSparkleEffect

- (void) setRowCount:(NSInteger)rowCount
{
    _rowCount = rowCount;
    self.yResolution = self.targetView.frame.size.height / rowCount;
}

- (NSString *) vertexShaderFileName
{
    return @"SparkleVertex.glsl";
}

- (NSString *) fragmentShaderFileName
{
    return @"SparkleFragment.glsl";
}

- (NSString *) particleImageName
{
    return @"Sparkle2.png";
}

- (void) setupExtraUniforms
{
}

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
}

- (DHSparkleAttributes) sparkleAtIndex:(NSInteger) index
{
    DHSparkleAttributes *sparkles = (DHSparkleAttributes *)[self.particleData bytes];
    return sparkles[index];
}

- (void) setSparkle:(DHSparkleAttributes)sparkle atIndex:(NSInteger)index
{
    DHSparkleAttributes *sparkles = (DHSparkleAttributes *)[self.particleData bytes];
    sparkles[index] = sparkle;
}

- (NSInteger) indexForFirstFadedParticle
{
    NSInteger result = -1;
    for (int i = 0; i < self.numberOfParticles; i++) {
        DHSparkleAttributes sparkle = [self sparkleAtIndex:i];
        if (sparkle.emitTime + sparkle.lifeTime < self.elapsedTime) {
            return i;
        }
    }
    return result;
}

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    self.elapsedTime = elapsedTime;
    for (int y = 0; y < self.rowCount; y++) {
        CGFloat yPos = self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame) + y * self.yResolution;
        for (int i = 0; i < 5; i++) {
            DHSparkleAttributes sparkle;
            sparkle.emitterPosition = GLKVector3Make(percent * self.targetView.frame.size.width + self.targetView.frame.origin.x, yPos, self.targetView.frame.size.height / 2 );
            sparkle.size = [self randomSize];
            sparkle.emitterGravity = [self gravityForSize:sparkle.size];
            sparkle.emitterVelocity = [self velocityForSize:sparkle.size];
            sparkle.emitTime = elapsedTime;
            sparkle.lifeTime = 1.f;
            NSInteger firstInvalidSpot = [self indexForFirstFadedParticle];
            if (firstInvalidSpot == -1) {
                [self.particleData appendBytes:&sparkle length:sizeof(sparkle)];
            } else {
                [self setSparkle:sparkle atIndex:firstInvalidSpot];
            }
        }
    }
}

- (CGFloat) randomSize
{
    return arc4random() % (MAX_SPARKLE_SIZE - 20) + 20;
}

- (CGFloat) randomVelocityComponent
{
    return (arc4random() % 500 - 250) / 3;
}

- (GLKVector3) gravityForSize:(CGFloat)size
{
    return GLKVector3Make(0, size / MAX_SPARKLE_SIZE * -200, 0);
}

- (GLKVector3) velocityForSize:(CGFloat)size
{
    CGFloat factor = size / MAX_SPARKLE_SIZE * (2 - size / MAX_SPARKLE_SIZE);
    return GLKVector3Make(-fabs([self randomVelocityComponent] / factor), [self randomVelocityComponent] / factor, [self randomVelocityComponent] / factor);
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
    }
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_DYNAMIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHSparkleAttributes), NULL + offsetof(DHSparkleAttributes, emitterPosition));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(DHSparkleAttributes), NULL + offsetof(DHSparkleAttributes, emitterVelocity));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(DHSparkleAttributes), NULL + offsetof(DHSparkleAttributes, emitterGravity));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHSparkleAttributes), NULL + offsetof(DHSparkleAttributes, emitTime));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHSparkleAttributes), NULL + offsetof(DHSparkleAttributes, lifeTime));
    
    glEnableVertexAttribArray(5);
    glVertexAttribPointer(5, 1, GL_FLOAT, GL_FALSE, sizeof(DHSparkleAttributes), NULL + offsetof(DHSparkleAttributes, size));
}

- (void) draw
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(elapsedTimeLoc, self.elapsedTime);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.particleData length] / sizeof(DHSparkleAttributes));
}

- (NSInteger) numberOfParticles
{
    return [self.particleData length] / sizeof(DHSparkleAttributes);
}
@end
