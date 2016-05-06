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


@interface DHSparkleEffect() {
}

@property (nonatomic) NSInteger numberOfParticles;
@property (nonatomic) CGFloat yResolution;
@property (nonatomic) CGFloat maxPointSize;
@end

@implementation DHSparkleEffect

- (void) setRowCount:(NSInteger)rowCount
{
    [super setRowCount:rowCount];
    self.yResolution = self.targetView.frame.size.height / rowCount;
    self.maxPointSize = self.yResolution * [UIScreen mainScreen].scale * 1.8;
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
    return [DHConstants resourcePathForFile:@"Sparkle2" ofType:@"png"];
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
    if (percent > 1 - SPARKLE_LIFE_TIME_RATIO) {
        return;
    }
    for (int y = 0; y < 4; y++) {
        CGFloat yPos = self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame) + arc4random() % (int)self.targetView.frame.size.height;
        CGFloat xPos = percent / (1 - SPARKLE_LIFE_TIME_RATIO) * self.targetView.frame.size.width + self.targetView.frame.origin.x - (int)arc4random() % 10;
        if (self.direction != DHAnimationDirectionLeftToRight) {
            xPos = (1 - percent / (1 - SPARKLE_LIFE_TIME_RATIO)) * self.targetView.frame.size.width + self.targetView.frame.origin.x + (int)arc4random() % 10;
        }
        DHSparkleAttributes sparkle;
        sparkle.emitterPosition = GLKVector3Make(xPos, yPos, self.targetView.frame.size.height / 2 );
        sparkle.size = [self randomSize];
        sparkle.emitterGravity = [self gravityForSize:sparkle.size];
        sparkle.emitterVelocity = [self velocityForSize:sparkle.size];
        sparkle.emitTime = elapsedTime;
        sparkle.lifeTime = self.duration * SPARKLE_LIFE_TIME_RATIO;
        NSInteger firstInvalidSpot = [self indexForFirstFadedParticle];
        if (firstInvalidSpot == -1) {
            [self.particleData appendBytes:&sparkle length:sizeof(sparkle)];
        } else {
            [self setSparkle:sparkle atIndex:firstInvalidSpot];
        }
    }
}

- (CGFloat) randomSize
{
    return arc4random() % ((int)self.maxPointSize - 20) + 20;
}

- (CGFloat) randomVelocityComponent
{
    return ((int)arc4random() % 300 - 150) / (GLfloat)3;
}

- (GLKVector3) gravityForSize:(CGFloat)size
{
    return GLKVector3Make(0, size / self.maxPointSize * -200, 0);
}

- (GLKVector3) velocityForSize:(CGFloat)size
{
    CGFloat factor = size / self.maxPointSize * (2 - size / self.maxPointSize);
    CGFloat xVelocity = fabs([self randomVelocityComponent] / factor);
    if (self.direction == DHAnimationDirectionLeftToRight) {
        xVelocity *= -1;
    }
    return GLKVector3Make(xVelocity, [self randomVelocityComponent] / factor, [self randomVelocityComponent] / factor);
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
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 1);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.particleData length] / sizeof(DHSparkleAttributes));
}

- (NSInteger) numberOfParticles
{
    return [self.particleData length] / sizeof(DHSparkleAttributes);
}
@end
