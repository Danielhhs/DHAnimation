//
//  DHShimmerEffect.m
//  Shimmer
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShimmerParticleEffect.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
#import <OpenGLES/ES3/glext.h>
typedef struct {
    GLKVector3 startingPosition;
    GLfloat originalSize;
    GLfloat targetSize;
    GLKVector3 targettingPosition;
    GLKVector2 texCoords;
    int isEdge;
}DHShimmerParticleAttributes;

@interface DHShimmerParticleEffect () {
    GLuint rotationMatrixLoc;
}
@end

@implementation DHShimmerParticleEffect

- (instancetype) initWithContext:(EAGLContext *)context columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount targetView:(UIView *)targetView containerView:(UIView *)containerView offsetData:(NSArray *)offsetData event:(DHAnimationEvent)event
{
    self = [super init];
    if (self) {
        self.context = context;
        self.columnCount = columnCount;
        self.rowCount = rowCount;
        self.targetView = targetView;
        self.containerView = containerView;
        _offsetData = offsetData;
        _event = event;
        self.vertexShaderFileName = @"ShimmerVertex.glsl";
        self.fragmentShaderFileName = @"ShimmerFragment.glsl";
        self.particleImageName = [DHConstants resourcePathForFile:@"star_white" ofType:@"png"];
        [self setupGL];
        [self setupTextures];
        [self generateParticlesData];
        [self prepareToDraw];
    }
    return self;
}


- (void) setupExtraUniforms
{
    rotationMatrixLoc = glGetUniformLocation(program, "u_rotationMatrix");
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_DYNAMIC_DRAW);
    }
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glGenVertexArrays(1, &vertexArray);
    glBindVertexArray(vertexArray);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHShimmerParticleAttributes), NULL + offsetof(DHShimmerParticleAttributes, startingPosition));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 1, GL_FLOAT, GL_FALSE, sizeof(DHShimmerParticleAttributes), NULL + offsetof(DHShimmerParticleAttributes, originalSize));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHShimmerParticleAttributes), NULL + offsetof(DHShimmerParticleAttributes, targetSize));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(DHShimmerParticleAttributes), NULL + offsetof(DHShimmerParticleAttributes, targettingPosition));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 2, GL_FLOAT, GL_FALSE, sizeof(DHShimmerParticleAttributes), NULL + offsetof(DHShimmerParticleAttributes, texCoords));
    
    glEnableVertexAttribArray(5);
    glVertexAttribPointer(5, 1, GL_INT, GL_FALSE, sizeof(DHShimmerParticleAttributes), NULL + offsetof(DHShimmerParticleAttributes, isEdge));
    
    glBindVertexArray(0);
}

- (void) draw
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    
    float a_angle = self.percent * M_PI_2;
    if (self.event == DHAnimationEventBuiltOut) {
        a_angle = M_PI_2 - a_angle;
    }
    float cosAngle = cos(a_angle);
    float sinAngle = sin(a_angle);
    GLKMatrix4 transInMat = GLKMatrix4Make(1.0, 0.0, 0.0, 0.0,
                                           0.0, 1.0, 0.0, 0.0,
                                           0.0, 0.0, 1.0, 0.0,
                                           0.5, 0.5, 0.0, 1.0);
    GLKMatrix4 rotMat = GLKMatrix4Make(cosAngle, -sinAngle, 0.0, 0.0,
                                       sinAngle, cosAngle, 0.0, 0.0,
                                       0.0, 0.0, 1.0, 0.0,
                                       0.0, 0.0, 0.0, 1.0);
    GLKMatrix4 resultMat = GLKMatrix4Multiply(transInMat, rotMat);
    resultMat.m30 = resultMat.m30 + resultMat.m00 * -0.5 + resultMat.m10 * -0.5;
    resultMat.m31 = resultMat.m31 + resultMat.m01 * -0.5 + resultMat.m11 * -0.5;
    resultMat.m32 = resultMat.m32 + resultMat.m02 * -0.5 + resultMat.m12 * -0.5;
    glUniformMatrix4fv(rotationMatrixLoc, 1, GL_FALSE, resultMat.m);
    
    glUniform1f(percentLoc, self.percent);
    
    glBindVertexArray(vertexArray);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(backgroundSamplerLoc, 1);
    glUniform1f(eventLoc, self.event);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.particleData length] / sizeof(DHShimmerParticleAttributes));
    glBindVertexArray(0);
}

- (void) generateParticlesData
{
    self.particleData = [NSMutableData data];
    CGFloat cellWidth = self.targetView.bounds.size.width / self.columnCount;
    CGFloat cellHeight = self.targetView.bounds.size.height / self.rowCount;
    
    for (int x = 0; x < self.columnCount; x++) {
        CGFloat xPos = self.targetView.frame.origin.x + cellWidth * x + cellWidth / 2;
        for (int y = 0; y < self.rowCount; y++) {
            CGFloat yPos = self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame) + cellHeight * y + cellHeight / 2;
            DHShimmerParticleAttributes particle;
            
            NSInteger index = x * self.rowCount + y;
            GLKVector3 offset = GLKVector3Make([self.offsetData[index] doubleValue], [self.offsetData[index + 1] doubleValue], [self.offsetData[index + 2] doubleValue]);
            if (self.event == DHAnimationEventBuiltIn) {
                particle.targettingPosition = [self rotatedPosition:GLKVector3Make(xPos, yPos, 0)];
                
                particle.startingPosition = GLKVector3Add(particle.targettingPosition, offset);
                particle.originalSize = [self randomPointSize] / 5;
                if (x == 0 || x == self.columnCount - 1) {
                    particle.targetSize = cellHeight * [UIScreen mainScreen].scale * 5 * [self randomScale];
                } else {
                    particle.targetSize = cellHeight * [UIScreen mainScreen].scale * 3 * [self randomScale];
                }
            } else {
                particle.startingPosition = [self rotatedPosition:GLKVector3Make(xPos, yPos, 0)];
                particle.targettingPosition = GLKVector3Add(particle.startingPosition, offset);
                particle.targetSize = [self randomPointSize] / 5;
                if (x == 0 || x == self.columnCount - 1) {
                    particle.originalSize = cellHeight * [UIScreen mainScreen].scale * 5 * [self randomScale];
                } else {
                    particle.originalSize = cellHeight * [UIScreen mainScreen].scale * 3 * [self randomScale];
                }
            }
            particle.texCoords = GLKVector2Make((GLfloat)x / (GLfloat)self.columnCount, (GLfloat)y / (GLfloat)self.rowCount);
            if (x == 0 || x == self.columnCount - 1 || y == 0 || y == self.rowCount - 1) {
                particle.isEdge = 1;
            } else {
                particle.isEdge = 0;
            }
            [self.particleData appendBytes:&particle length:sizeof(particle)];
        }
    }
}

- (NSInteger) numberOfParticles
{
    return [self.particleData length] / sizeof(DHShimmerParticleAttributes);
}

- (GLfloat) randomPointSize
{
    return arc4random() % 100;
}

- (GLfloat) randomScale
{
    GLfloat scale = 1 + ((int) (arc4random() % 100) - 50) / (GLfloat)500;
    return scale;
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithImage:[UIImage imageNamed:self.particleImageName]];
    backgroundTexture = [TextureHelper setupTextureWithView:self.targetView];
}
@end
