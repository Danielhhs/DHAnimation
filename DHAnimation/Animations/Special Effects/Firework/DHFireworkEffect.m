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
#import "DHConstants.h"

typedef struct {
    GLKVector3 position;
    GLfloat appearTime;
    GLfloat lifeTime;
    GLKVector4 color;
    GLfloat shining;
}DHFireworkTailAttributes;

@interface DHFireworkEffect () {
    GLuint timeLoc;
    CGFloat red, green, blue, alpha;
}
@property (nonatomic) DHFireworkSettings *settings;
@property (nonatomic, strong) NSMutableArray *velocityArray;
@end

@implementation DHFireworkEffect

#pragma mark - Set up
- (instancetype) initWithContext:(EAGLContext *)context
{
    self = [super initWithContext:context];
    if (self) {
        self.velocityArray = [NSMutableArray array];
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
    return @"ExplodeAndFadeFireworkVertex.glsl";
}

- (NSString *) fragmentShaderFileName
{
    return @"ExplodeAndFadeFireworkFragment.glsl";
}

- (NSString *) particleImageName
{
    return [DHConstants resourcePathForFile:@"dust" ofType:@"png"];
}

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
}

#pragma mark - Append Particle Data
- (void) addFireworkWithSettings:(DHFireworkSettings *)settings
{
    self.settings = settings;
    if (self.settings.fireworkType == DHFireworkEffectTypeDoubleExplosion) {
        self.settings.duration *= 0.5;
    }
    [self.settings.color getRed:&red green:&green blue:&blue alpha:&alpha];
    [self appendExplosionDataWithBaseVelocity:self.settings.baseVelocity];
}

- (void) appendExplosionDataWithBaseVelocity:(GLfloat)baseVelocity
{
    NSInteger explosionCount = self.settings.explosionCount;
    if (self.settings.fireworkType == DHFireworkEffectTypeFastExplosion) {
        explosionCount = pow(explosionCount, 3);
    }
    for (int i = 0; i < explosionCount; i++) {
        GLKVector3 direction = [self tailDirectionAtIndex:i];
        GLfloat velocity = [self velocityForBaseVelocity:baseVelocity];
        
        if (self.settings.fireworkType == DHFireworkEffectTypeDoubleExplosion) {
            [self.velocityArray addObject:@(velocity)];
        }
        [self generateTailForDirection:direction velocity:velocity emissionTime:self.settings.explosionTime emissionPosition:self.settings.explosionPosition emissionDuration:self.settings.duration particleCount:self.settings.tailParticleCount];
    }
    if (self.settings.fireworkType == DHFireworkEffectTypeDoubleExplosion) {
        for (int i = 0; i < self.settings.explosionCount; i++) {
            GLKVector3 direction = [self tailDirectionAtIndex:i];
            GLfloat velocity = [self.velocityArray[i] floatValue];
            GLKVector3 offset = [self offsetForParticleForDirection:direction velocity:velocity appearTime:self.settings.duration duration:self.settings.duration ];
            GLKVector3 position = GLKVector3Add(self.settings.explosionPosition, offset);
            for (int j = 0; j < 10; j++) {
                GLfloat angle = j * M_PI * 2 / 10;
                GLKVector3 secondExplosionDirection = GLKVector3Make(cos(angle), sin(angle), 0);
                GLfloat explosionVelocity = [self randomNumberAroundNumber:100 range:0.2];
                GLfloat explosionTime = self.settings.explosionTime + [self randomNumberAroundNumber:self.settings.duration range:0.3];
                GLfloat duration = [self randomNumberAroundNumber:self.settings.duration * 0.8 range:0.2];
                [self generateTailForDirection:secondExplosionDirection velocity:explosionVelocity emissionTime:explosionTime emissionPosition:position emissionDuration:duration particleCount:50];
            }
        }
    }
}

- (GLKVector3) tailDirectionAtIndex:(NSInteger)index
{
    CGFloat angle = index * M_PI * 2 / self.settings.explosionCount;
    if (self.settings.fireworkType == DHFireworkEffectTypeExplodeAndFade) {
        angle = [self randomBetweenZeroToOne] * M_PI * 2;
    }
    switch (self.settings.fireworkType) {
        case DHFireworkEffectTypeFastExplosion: {
            GLfloat x = index % self.settings.explosionCount - self.settings.explosionCount / 2.f;
            GLfloat y = index % (self.settings.explosionCount * self.settings.explosionCount) / self.settings.explosionCount - self.settings.explosionCount / 2.f;
            GLfloat z = index / (self.settings.explosionCount * self.settings.explosionCount) - self.settings.explosionCount / 2.f;
            return GLKVector3Normalize(GLKVector3Make(x, y, z));
        }
        case DHFireworkEffectTypeDoubleExplosion:
            return GLKVector3Normalize(GLKVector3Make(cos(angle), sin(angle), 0));
        case DHFireworkEffectTypeExplodeAndFade:
            return GLKVector3Normalize(GLKVector3Make(cos(angle), sin(angle), [self randomBetweenZeroToOne]));
    }
}

- (GLfloat) velocityForBaseVelocity:(GLfloat)baseVelocity
{
    switch (self.settings.fireworkType) {
        case DHFireworkEffectTypeExplodeAndFade:
            return [self randomBetweenZeroToOne] * baseVelocity / 2 + baseVelocity / 2;
        case DHFireworkEffectTypeDoubleExplosion:
        case DHFireworkEffectTypeFastExplosion:
            return [self randomBetweenZeroToOne] * baseVelocity / 4 + baseVelocity * 3 / 4;
    }
}

- (void) generateTailForDirection:(GLKVector3)direction
                         velocity:(GLfloat)velocity
                     emissionTime:(GLfloat)emissionTime
                 emissionPosition:(GLKVector3)emissionPosition
                 emissionDuration:(NSTimeInterval)emissionDuration
                    particleCount:(NSInteger)particleCount
{
    for (int i = 0; i < particleCount; i++) {
        DHFireworkTailAttributes particle;
        float appearTime = emissionDuration / particleCount * i;
        GLKVector3 offset = [self offsetForParticleForDirection:direction velocity:velocity appearTime:appearTime duration:emissionDuration];
        particle.position = GLKVector3Add(emissionPosition, offset);
        particle.appearTime = emissionTime + appearTime;
        particle.lifeTime = emissionDuration / 5.f * (1.f - appearTime / emissionDuration);
        particle.color = GLKVector4Make(red, green, blue, alpha);
        if(arc4random() % 5 == 0) {
            particle.shining = 1.f;
        } else {
            particle.shining = 0.f;
        }
        [self.particleData appendBytes:&particle length:sizeof(particle)];
    }
}

- (GLKVector3) offsetForParticleForDirection:(GLKVector3)direction velocity:(GLfloat)velocity appearTime:(GLfloat)appearTime duration:(GLfloat)duration
{
    float t = NSBKeyframeAnimationFunctionEaseOutQuad(appearTime * 1000.f, 0.f, duration, duration * 1000.f);
    GLKVector3 offset;
    float tsquare = 0.5 * t * t;
    if (self.settings.fireworkType == DHFireworkEffectTypeExplodeAndFade) {
        GLKVector3 velocityVector = GLKVector3MultiplyScalar(direction, velocity);
        float ax = -velocityVector.x / duration;
        float g = ((direction.y + 1.f) / 2.f * self.settings.gravity) * 0.5 + self.settings.gravity * 0.5;
        offset = GLKVector3Add(GLKVector3MultiplyScalar(velocityVector, t), GLKVector3MultiplyScalar(GLKVector3Make(ax, -g, 0.f), tsquare));
    } else if (self.settings.fireworkType == DHFireworkEffectTypeFastExplosion) {
        float a = -velocity / duration;
        float distance = velocity * t + a * tsquare;
        offset = GLKVector3MultiplyScalar(direction, distance);
    } else if (self.settings.fireworkType == DHFireworkEffectTypeDoubleExplosion) {
        float a = -velocity / duration;
        float distance = velocity * t + a * tsquare;
        offset = GLKVector3MultiplyScalar(direction, distance);
    }
    return offset;
}

- (CGFloat) randomBetweenZeroToOne
{
    int random = arc4random() % 1000;
    return random / 1000.f;
}

- (CGFloat) randomNumberAroundNumber:(CGFloat)baseNumber range:(GLfloat)range
{
    return baseNumber + baseNumber * ((arc4random() % 100 / 100.f) * range * 2 - range);
}

#pragma mark - Drawing
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
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 4, GL_FLOAT, GL_FALSE, sizeof(DHFireworkTailAttributes), NULL + offsetof(DHFireworkTailAttributes, color));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkTailAttributes), NULL + offsetof(DHFireworkTailAttributes, shining));
    
    glBindVertexArray(0);
}

- (void) draw
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(timeLoc, self.elapsedTime);
    
    glBindVertexArray(vertexArray);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.particleData length] / sizeof(DHFireworkTailAttributes));
    glBindVertexArray(0);
}

@end
