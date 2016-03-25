//
//  DHParticleEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/25/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"
#import "OpenGLHelper.h"
typedef struct
{
    GLKVector3 emissionPosition;
    GLKVector3 emissionVelocity;
    GLKVector3 emissionForce;
    GLKVector2 size;
    GLKVector2 emissionTimeAndLife;
}DHParticleAttributes;

@interface DHParticleEffect () {
    GLuint program;
    GLuint mvpLoc, samplerLoc, percentLoc, directionLoc, elapsedTimeLoc;
}
@property (nonatomic, strong) NSMutableData *particleData;
@property (nonatomic) BOOL particleDataUpdated;
@property (nonatomic) NSTimeInterval elapsedTime;
@end

@implementation DHParticleEffect

- (instancetype) init
{
    self = [super init];
    if (self) {
        _particleData = [NSMutableData data];
    }
    return self;
}

- (void) setupGL
{
    glUseProgram(program);
    mvpLoc = glGetUniformLocation(program, "u_mvpMatrix");
    samplerLoc = glGetUniformLocation(program, "s_tex");
    percentLoc = glGetUniformLocation(program, "u_percent");
    directionLoc = glGetUniformLocation(program, "u_direction");
    elapsedTimeLoc = glGetUniformLocation(program, "u_elapsedTime");
}

- (DHParticleAttributes) particleAtIndex:(NSInteger)index
{
    DHParticleAttributes *particlesPtr = (DHParticleAttributes *)[self.particleData bytes];
    return particlesPtr[index];
}

- (void) setParticle:(DHParticleAttributes)particle atIndex:(NSInteger)index
{
    DHParticleAttributes *particlePtr = (DHParticleAttributes *)[self.particleData mutableBytes];
    particlePtr[index] = particle;
    self.particleDataUpdated = YES;
}

- (void) addParticleAtPosition:(GLKVector3)position
                      velocity:(GLKVector3)velocity
                         force:(GLKVector3)force
                          size:(float)size
              lifeSpanSenconds:(NSTimeInterval)span
           fadeDurationSeconds:(NSTimeInterval)duration
{
    DHParticleAttributes particle;
    particle.emissionPosition = position;
    particle.emissionVelocity = velocity;
    particle.emissionForce = force;
    particle.size = GLKVector2Make(size, duration);
    particle.emissionTimeAndLife = GLKVector2Make(self.elapsedTime, self.elapsedTime + span);
    BOOL foundSlot = NO;
    NSInteger count = [self numberOfParticles];
    
    for (int i = 0; i < count && !foundSlot; i++) {
        DHParticleAttributes oldParticle = [self particleAtIndex:i];
        if (oldParticle.emissionTimeAndLife.y < self.elapsedTime) {
            [self setParticle:particle atIndex:i];
            foundSlot = YES;
        }
    }
    
    if (!foundSlot) {
        [self.particleData appendBytes:&particle length:sizeof(particle)];
        self.particleDataUpdated = YES;
    }
}

- (NSInteger) numberOfParticles
{
    return [self.particleData length] / sizeof(DHParticleAttributes);
}

- (void) prepareToDraw
{
    if (program == 0) {
        program = [OpenGLHelper loadProgramWithVertexShaderSrc:self.particleVertexShaderFileName fragmentShaderSrc:self.particleFragmentShaderFileName];
    }
    glUseProgram(program);
    [self setupMVPMatrix];
}

- (void) setupMVPMatrix
{
    GLKMatrix4 modelView = GLKMatrix4MakeTranslation(-self.animationView.bounds.size.width / 2, -self.animationView.bounds.size.height / 2, -self.animationView.bounds.size.height / 2 / tan(M_PI / 24));
    GLfloat aspect = self.animationView.bounds.size.width / self.animationView.bounds.size.height;
    GLKMatrix4 projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(projection, modelView);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, mvpMatrix.m);
}
@end
