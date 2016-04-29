//
//  DHDustEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHDustEffect.h"
#import "TextureHelper.h"
#import "NSBKeyframeAnimationFunctions.h"
typedef struct {
    GLKVector3 position;
    GLKVector3 targetPosition;
    GLfloat pointSize;
    GLfloat targetPointSize;
    GLfloat rotation;
} DHDustEffectAttributes;

#define PARTICLE_COUNT 100
#define MAX_PARTICLE_SIZE 1000
@interface DHDustEffect() {
    
}
@property (nonatomic) GLKVector3 emitDirection;
@property (nonatomic) GLuint numberOfParticles;
@end

@implementation DHDustEffect

- (instancetype) initWithContext:(EAGLContext *)context
{
    self = [super initWithContext:context];
    if (self) {
        _numberOfEmissions = 10;
    }
    return self;
}

#pragma mark - Resource Files
- (NSString *) vertexShaderFileName
{
    return @"DustEffectVertex.glsl";
}

- (NSString *) fragmentShaderFileName
{
    return @"DustEffectFragment.glsl";
}

- (NSString *) particleImageName
{
    return @"dust.png";
}

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
    if (self.direction == DHDustEmissionDirectionLeft || self.direction == DHDustEmissionDirectionRight) {
        [self generateDustParticlesForSingleDirection:self.direction emissionPosition:self.emitPosition];
    } else {
        [self generateDustParticlesForAllDirections];
    }
}

#pragma mark - Generate Particle Data For Single Direction
- (void) generateDustParticlesForSingleDirection:(DHDustEmissionDirection)direction emissionPosition:(GLKVector3)emissionPosition
{
    self.numberOfParticles = PARTICLE_COUNT;
    if (direction == DHDustEmissionDirectionLeft) {
        self.emitDirection = GLKVector3Make(-1, 0, 0);
    } else if (direction == DHDustEmissionDirectionRight) {
        self.emitDirection = GLKVector3Make(1, 0, 0);
    }
    for (int i = 0; i < self.numberOfParticles; i++) {
        DHDustEffectAttributes dust;
        dust.position = emissionPosition;
        dust.pointSize = 5.f;
        dust.targetPosition = [self randomTargetPositionForSingleDirectionForEmissionPosition:emissionPosition];
        dust.targetPointSize = [self targetPointSizeForYPosition:dust.targetPosition.y - emissionPosition.y originalSize:dust.pointSize];
        dust.rotation = [self randomPercent] * M_PI * 4;
        [self.particleData appendBytes:&dust length:sizeof(dust)];
    }
}

- (GLKVector3) randomTargetPositionForSingleDirectionForEmissionPosition:(GLKVector3)emissionPosition
{
    GLKVector3 position;
    GLfloat xDirection = self.emitDirection.x > 0 ? 1 : -1;
    position.x = emissionPosition.x + [self randomPercent] * self.dustWidth * xDirection;
    position.y = emissionPosition.y + [self randomPercent] * [self maxYForX:position.x - emissionPosition.x];
    position.z = emissionPosition.z + [self randomPercent] * self.emissionRadius * self.emitDirection.z;
    return position;
}

- (GLfloat) maxYForX:(GLfloat)x
{
    float y = sqrt(self.emissionRadius * self.emissionRadius - x * x);
    y = self.emissionRadius - y;
    return y;
}

- (GLfloat) maxZForX:(GLfloat)x y:(GLfloat)y
{
    float z;
    if (x * x + y * y > self.emissionRadius * self.emissionRadius) {
        z =  0;
    } else {
        z = sqrt(self.emissionRadius * self.emissionRadius - x * x - y * y);
    }
    return z;
}

- (GLfloat) targetPointSizeForYPosition:(GLfloat)yPosition originalSize:(GLfloat)originalSize
{
    GLfloat maxYPosition = sqrt(self.emissionRadius * self.emissionRadius - self.dustWidth * self.dustWidth);
    return yPosition / maxYPosition * MAX_PARTICLE_SIZE + originalSize;
}

#pragma mark - Generate Particle Data For Horizontal Direction
- (void) generateDustParticlesForAllDirections
{
    GLfloat spaceBetweenEmitters = self.emissionWidth / self.numberOfEmissions;
//    for (int i = 1; i < self.numberOfEmissions - 1; i++) {
//        GLKVector3 emissionPosition = GLKVector3Make(self.emitPosition.x + i * spaceBetweenEmitters, self.emitPosition.y, self.emitPosition.z);
//        for (int i = 0; i < PARTICLE_COUNT; i++) {
//            DHDustEffectAttributes dust;
//            dust.position = emissionPosition;
//            dust.pointSize = 5.f;
//            dust.rotation = [self randomPercent] * M_PI * 4;
//            dust.targetPosition = [self randomTargetPositionForAllDirectionsForEmissionPosition:emissionPosition];
//            dust.targetPointSize = [self targetPointSizeForYPosition:dust.targetPosition.y - emissionPosition.y originalSize:dust.pointSize];
//            [self.particleData appendBytes:&dust length:sizeof(dust)];
//        }
//    }
    [self generateDustParticlesForSingleDirection:DHDustEmissionDirectionLeft emissionPosition:self.emitPosition];
    GLKVector3 rightEmitPosition = self.emitPosition;
    rightEmitPosition.x += self.emissionWidth;
    [self generateDustParticlesForSingleDirection:DHDustEmissionDirectionRight emissionPosition:rightEmitPosition];
    self.numberOfParticles = 2 * PARTICLE_COUNT;
}

- (GLKVector3) randomTargetPositionForAllDirectionsForEmissionPosition:(GLKVector3)emissionPosition
{
    GLfloat spaceBetweenEmitters = self.emissionWidth / self.numberOfEmissions;
    GLKVector3 position;
    GLfloat xOffset = [self randomPercent] * spaceBetweenEmitters * 2 - spaceBetweenEmitters;
    position.x = emissionPosition.x + xOffset;
    position.z = emissionPosition.z + [self randomPercent] * self.emissionRadius;
    position.y = [self maxYForX:position.z - emissionPosition.z];
    return position;
}

- (GLfloat) randomPercent
{
    return arc4random() % 100 / 100.f;
}

#pragma mark - Drawing
- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
    }
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_DYNAMIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, targetPosition));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, pointSize));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, targetPointSize));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, rotation));
}

- (void) draw
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glUseProgram(program);
    
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(percentLoc, self.percent);
    
    [self prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, self.numberOfParticles);
    
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithImage:[UIImage imageNamed:self.particleImageName]];
}

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    elapsedTime = elapsedTime - self.startTime;
    NSBKeyframeAnimationFunction function = [DHTimingFunctionHelper functionForTimingFunction:self.timingFuntion];
    self.percent = function(elapsedTime * 1000, 0, 1, (self.duration - self.startTime) * 1000);
}

@end
