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
#import <OpenGLES/ES3/glext.h>
#import "DHConstants.h"
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
    GLuint vertexArray;
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
        _numberOfParticlesPerEmission = 10;
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
    return [DHConstants resourcePathForFile:@"dust" ofType:@"png"];
}

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
    if (self.direction == DHDustEmissionDirectionLeft || self.direction == DHDustEmissionDirectionRight) {
        [self generateDustParticlesForSingleDirection:self.direction emissionPosition:self.emitPosition];
    } else {
        [self generateDustParticlesForAllDirections];
    }
    [self prepareToDraw];
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
    for (int i = 5; i < self.emissionWidth - 1; i+=5) {
        GLKVector3 emissionPosition = self.emitPosition;
        float angle = acosf((i - self.emissionWidth / 2) / (self.emissionWidth / 2));
        GLKVector3 direction = GLKVector3Make(cos(angle), 0, fabs(sin(angle)));
        for (int i = 0; i < self.numberOfParticlesPerEmission; i++) {
            DHDustEffectAttributes dust;
            dust.position = emissionPosition;
            dust.pointSize = 5.f;
            dust.rotation = [self randomPercent] * M_PI * 4;
            GLfloat distance = [self randomDistance];
            GLKVector3 targetPosition = GLKVector3MultiplyScalar(direction, distance);
            dust.targetPosition = GLKVector3Add(targetPosition, emissionPosition);
            float yOffset = [self randomPercent] * [self maxYForDistance:distance];
            dust.targetPosition.y = emissionPosition.y + yOffset;
            dust.targetPointSize = [self targetPointSizeForYPosition:dust.targetPosition.y - emissionPosition.y originalSize:dust.pointSize];
            [self.particleData appendBytes:&dust length:sizeof(dust)];
        }
    }
    [self generateDustParticlesForSingleDirection:DHDustEmissionDirectionLeft emissionPosition:self.emitPosition];
    GLKVector3 rightEmitPosition = self.emitPosition;
    rightEmitPosition.x += self.targetView.frame.size.width;
    [self generateDustParticlesForSingleDirection:DHDustEmissionDirectionRight emissionPosition:rightEmitPosition];
    self.numberOfParticles = PARTICLE_COUNT * 2 + self.numberOfParticlesPerEmission * self.emissionWidth / 5;
}

- (GLfloat) randomDistance
{
    float random = arc4random() % 1000 / 1000.f * self.dustWidth;
    return random;
}

- (GLfloat) maxYForDistance:(GLfloat) distance
{
    float maxY = sqrt(self.emissionRadius * self.emissionRadius - distance * distance);
    return self.emissionRadius - maxY;
}
- (GLKVector3) randomTargetPositionForAllDirectionsForEmissionPosition:(GLKVector3)emissionPosition
{
    GLKVector3 position;
    GLfloat angle = (emissionPosition.x - self.emitPosition.x) / self.emissionWidth * M_PI;
    GLfloat xOffset = -self.dustWidth / 2 * cos(angle);
    position.x = emissionPosition.x + xOffset;
    position.z = emissionPosition.z + [self randomPercent] * self.emissionRadius;
    GLfloat yOffset = [self maxYForX:position.z - emissionPosition.z] / 3 * [self randomPercent];
    position.y = emissionPosition.y + yOffset;
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
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_DYNAMIC_DRAW);
    }
    glGenVertexArrays(1, &vertexArray);
    glBindVertexArray(vertexArray);
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
    glBindVertexArray(0);
}

- (void) draw
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glUseProgram(program);
    
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(percentLoc, self.percent);
    glBindVertexArray(vertexArray);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, self.numberOfParticles);
    glBindVertexArray(0);
    
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
