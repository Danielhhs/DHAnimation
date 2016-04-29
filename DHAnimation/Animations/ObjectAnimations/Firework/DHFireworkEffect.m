//
//  DHFireworkEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFireworkEffect.h"
#import "TextureHelper.h"
typedef struct {
    GLKVector3 emissionPosition;
    GLKVector3 emissionDirection;
    GLfloat emissionVelocity;
    GLfloat emissionForce;
    GLfloat emissionTime;
    GLfloat lifeTime;
    GLfloat size;
    GLfloat shouldUpdatePosition;
}DHFireworkParticleAttributes;

@interface DHFireworkEffect () {
    GLuint emissionTimeLoc, gravityLoc;;
}
@property (nonatomic) GLKVector3 gravity;
@end

#define NUMBER_OF_EXLOSIONS_PER_SECOND 3
#define FIREWORK_EXPLOSION_DURATION_RATIO 0.618
#define FIREWORK_BRANCH_COUNT 50

@implementation DHFireworkEffect

- (NSString *) vertexShaderFileName
{
    return @"FireworkVertex.glsl";
}

- (NSString *) fragmentShaderFileName
{
    return @"FireworkFragment.glsl";
}

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
}

- (void) setupFireworkData
{
    for (int i = 0; i < FIREWORK_BRANCH_COUNT; i++) {
        DHFireworkParticleAttributes fireworkParticle;
        fireworkParticle.emissionPosition = self.emissionPosition;
        fireworkParticle.emissionTime = self.emissionTime;
        GLfloat yDirection = sin(i / (float)FIREWORK_BRANCH_COUNT * M_PI * 2);
        if (yDirection < 0) {
            yDirection /= 2;
        }
        fireworkParticle.emissionDirection = GLKVector3Make(cos(i / (float)FIREWORK_BRANCH_COUNT * M_PI * 2), yDirection, 0.1);
        fireworkParticle.emissionVelocity = arc4random() % 100 + 100;
        fireworkParticle.emissionForce = 2 * (fireworkParticle.emissionVelocity * self.duration - self.explosionRadius) / self.duration / self.duration;
        fireworkParticle.lifeTime = self.duration;
        fireworkParticle.size = 30;
        fireworkParticle.shouldUpdatePosition = 1.f;
        [self.particleData appendBytes:&fireworkParticle length:sizeof(fireworkParticle)];
    }
}

- (void) setupExtraUniforms
{
    emissionTimeLoc = glGetUniformLocation(program, "u_emissionTime");
    gravityLoc = glGetUniformLocation(program, "u_gravity");
}

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    self.elapsedTime = elapsedTime;
    if (elapsedTime < self.emissionTime) {
        return;
    }
    for (int i = 0; i < FIREWORK_BRANCH_COUNT; i++) {
        DHFireworkParticleAttributes source = [self particleAtIndex:i];
        DHFireworkParticleAttributes fireworkParticle;
        fireworkParticle.emissionPosition = source.emissionPosition;
        fireworkParticle.emissionTime = elapsedTime;
        fireworkParticle.emissionDirection = source.emissionDirection;
        fireworkParticle.emissionVelocity = source.emissionVelocity;
        fireworkParticle.emissionForce = source.emissionForce;
        fireworkParticle.lifeTime = self.duration * (1 - FIREWORK_EXPLOSION_DURATION_RATIO);
        fireworkParticle.size = 10;
        fireworkParticle.shouldUpdatePosition = 0.f;
        [self.particleData appendBytes:&fireworkParticle length:sizeof(fireworkParticle)];
    }
}

- (DHFireworkParticleAttributes) fireworkParticleForOriginalParticle:(DHFireworkParticleAttributes)original offset:(CGFloat)offset
{
    DHFireworkParticleAttributes particle;
    particle.emissionPosition = original.emissionPosition;
    particle.emissionTime = original.emissionTime;
    particle.emissionDirection = original.emissionDirection;
    particle.emissionVelocity = original.emissionVelocity;
    particle.lifeTime = original.lifeTime;
    particle.size = original.size;
    particle.shouldUpdatePosition = original.shouldUpdatePosition;
    particle.emissionForce = original.emissionForce;
    return particle;
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithImage:[UIImage imageNamed:@"star_white.png"]];
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
    }
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHFireworkParticleAttributes), NULL + offsetof(DHFireworkParticleAttributes, emissionPosition));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(DHFireworkParticleAttributes), NULL + offsetof(DHFireworkParticleAttributes, emissionDirection));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkParticleAttributes), NULL + offsetof(DHFireworkParticleAttributes, emissionVelocity));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkParticleAttributes), NULL + offsetof(DHFireworkParticleAttributes, emissionForce));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkParticleAttributes), NULL + offsetof(DHFireworkParticleAttributes, emissionTime));
    
    glEnableVertexAttribArray(5);
    glVertexAttribPointer(5, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkParticleAttributes), NULL + offsetof(DHFireworkParticleAttributes, lifeTime));
    
    glEnableVertexAttribArray(6);
    glVertexAttribPointer(6, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkParticleAttributes), NULL + offsetof(DHFireworkParticleAttributes, size));
    
    glEnableVertexAttribArray(7);
    glVertexAttribPointer(7, 1, GL_FLOAT, GL_FALSE, sizeof(DHFireworkParticleAttributes), NULL + offsetof(DHFireworkParticleAttributes, shouldUpdatePosition));
    
}

- (void) draw
{
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(percentLoc, self.percent);
    glUniform1f(elapsedTimeLoc, self.elapsedTime);
    glUniform1f(emissionTimeLoc, self.emissionTime);
    glUniform3f(gravityLoc, 0, -50, 0);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.particleData length] / sizeof(DHFireworkParticleAttributes));
}

- (DHFireworkParticleAttributes) particleAtIndex:(NSInteger) index
{
    DHFireworkParticleAttributes *particles = (DHFireworkParticleAttributes *)[self.particleData bytes];
    return particles[index];
}
@end
