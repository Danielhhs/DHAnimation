//
//  DHDustEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHDustEffect.h"
#import "TextureHelper.h"
typedef struct {
    GLKVector3 position;
    GLKVector3 targetPosition;
    GLfloat pointSize;
    GLfloat targetPointSize;
    GLfloat rotation;
} DHDustEffectAttributes;

#define PARTICLE_COUNT 500
#define DUST_RADIUS 300
#define MAX_PARTICLE_SIZE 1000

@implementation DHDustEffect

- (instancetype) initWithContext:(EAGLContext *)context emitPosition:(GLKVector3)emitPosition direction:(DHDustEmissionDirection)direction dustWidth:(GLfloat)dustWidth
{
    self = [super init];
    if (self) {
        self.context = context;
        _emitPosition = emitPosition;
        _direction = direction;
        _dustWidth = dustWidth;
        [self setupGL];
        [self setupTextures];
        [self generateParticlesData];
    }
    return self;
}

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
    for (int i = 0; i < PARTICLE_COUNT; i++) {
        DHDustEffectAttributes dust;
        dust.position = self.emitPosition;
        dust.pointSize = 5.f;
        dust.targetPosition = [self randomTargetPosition];
        dust.targetPointSize = [self targetPointSizeForYPosition:dust.targetPosition.y - self.emitPosition.y originalSize:dust.pointSize];
        dust.rotation = [self randomPercent] * M_PI * 4;
        [self.particleData appendBytes:&dust length:sizeof(dust)];
    }
}

- (GLKVector3) randomTargetPosition
{
    GLKVector3 position;
    position.x = self.emitPosition.x + [self randomPercent] * self.dustWidth;
    position.y = self.emitPosition.y + [self randomPercent] * [self maxYForX:position.x - self.emitPosition.x];
    position.z = self.emitPosition.z;
    return position;
}

- (GLfloat) randomPercent
{
    return arc4random() % 100 / 100.f;
}

- (GLfloat) maxYForX:(GLfloat)x
{
    float y = sqrt(DUST_RADIUS * DUST_RADIUS - x * x);
    y = DUST_RADIUS - y;
    return y;
}

- (GLfloat) maxZForX:(GLfloat)x y:(GLfloat)y
{
    float z;
    if (x * x + y * y > DUST_RADIUS * DUST_RADIUS) {
        z =  0;
    } else {
        z = sqrt(DUST_RADIUS * DUST_RADIUS - x * x - y * y);
    }
    return z;
}

- (GLfloat) targetPointSizeForYPosition:(GLfloat)yPosition originalSize:(GLfloat)originalSize
{
    GLfloat maxYPosition = sqrt(DUST_RADIUS * DUST_RADIUS - self.dustWidth * self.dustWidth);
    return yPosition / maxYPosition * MAX_PARTICLE_SIZE + originalSize;
}

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
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glUseProgram(program);
    
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(percentLoc, self.percent);
    
    [self prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, PARTICLE_COUNT);
    
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithImage:[UIImage imageNamed:self.particleImageName]];
}
@end
