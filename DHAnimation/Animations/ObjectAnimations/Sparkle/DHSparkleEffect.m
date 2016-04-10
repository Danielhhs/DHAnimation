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

@end

@implementation DHSparkleEffect

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

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    self.elapsedTime = elapsedTime;
    for (int i = 0; i < 5; i++) {
        DHSparkleAttributes sparkle;
        sparkle.emitterPosition = GLKVector3Make(percent * self.targetView.frame.size.width + self.targetView.frame.origin.x, CGRectGetMidY(self.targetView.frame), self.targetView.frame.size.height / 2 );
        sparkle.emitterGravity = GLKVector3Make(0, -10, 0);
        sparkle.emitterVelocity = GLKVector3Make(-fabs([self randomVelocityComponent]), [self randomVelocityComponent], 0);
        sparkle.emitTime = elapsedTime;
        sparkle.lifeTime = 1.f;
        sparkle.size = [self randomSize];
        [self.particleData appendBytes:&sparkle length:sizeof(sparkle)];
    }
}

- (CGFloat) randomSize
{
    return arc4random() % 75;
}

- (CGFloat) randomVelocityComponent
{
    return arc4random() % 200 - 100;
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
@end
