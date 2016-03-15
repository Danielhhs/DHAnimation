//
//  ConfettiSceneMesh.m
//  ShrederAnimation
//
//  Created by Huang Hongsen on 12/21/15.
//  Copyright © 2015 cn.daniel. All rights reserved.
//

#import "ShredderConfettiSceneMesh.h"
#import <OpenGLES/ES3/glext.h>
typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLKVector2 yRange;
} ConfettiSceneVertex;
@interface ShredderConfettiSceneMesh () {
    ConfettiSceneVertex *vertices;
    size_t vertexCount;
    size_t indexCount;
    size_t length;
    size_t startingY;
    GLuint meshVAO;
    GLuint vertexBuffer;
    GLuint indexBuffer;
}
@property (nonatomic) size_t screenHeight;
@property (nonatomic) NSTimeInterval fallingTime;
@property (nonatomic) CGFloat fallingDistance;
@end

#define CONFETTI_WIDTH 3
#define CONFETTI_MIN_LENGTH 75
#define CONFETTI_MAX_LENGTH 150

@implementation ShredderConfettiSceneMesh

- (instancetype) initWithScreenWidth:(size_t)screenWidth
                        screenHeight:(size_t)screenHeight
                      numberOfPieces:(NSInteger)numberOfPieces
                               index:(NSInteger)index
{
    _screenHeight = screenHeight;
    size_t pixelsPerPiece = screenWidth / numberOfPieces;
    size_t minY = screenHeight / 10;
    size_t maxLength = 6 * minY;
    _fallingTime = 0;
    
    startingY = arc4random() % maxLength + minY;
    size_t availableLength = CONFETTI_MAX_LENGTH - CONFETTI_MIN_LENGTH;
    length = arc4random() % availableLength;
    size_t endingY = startingY + length;
    
    vertexCount = CONFETTI_WIDTH * (length + 1);
    size_t vertexSize = vertexCount * sizeof(ConfettiSceneVertex);
    vertices = malloc(vertexSize);
    
    size_t startingX = pixelsPerPiece * index - CONFETTI_WIDTH;
    for (size_t y = 0; y <= length; y++) {
        GLfloat ty = (GLfloat)(startingY + y) / screenHeight;
        for (int x = 0; x < CONFETTI_WIDTH; x++) {
            ConfettiSceneVertex *vertex = &vertices[y * CONFETTI_WIDTH + x];
            vertex->position.x = startingX + x;
            vertex->position.y = startingY + y;
            vertex->position.z = 0;
            vertex->texCoords.x = vertex->position.x / (GLfloat)screenWidth;
            vertex->texCoords.y = ty;
            vertex->yRange.x = startingY;
            vertex->yRange.y = endingY;
        }
    }
    
    indexCount = (CONFETTI_WIDTH - 1) * (length) * 2 * 3;
    NSInteger indexSize = indexCount * sizeof(GLuint);
    indices = malloc(indexSize);
    for (int y = 0; y < length; y++) {
        for (int x = 0; x < CONFETTI_WIDTH - 1; x++) {
            int idx = y * (CONFETTI_WIDTH - 1) + x;
            int i = y * CONFETTI_WIDTH + x;
            indices[idx * 6 + 0] = i;
            indices[idx * 6 + 1] = i + 1;
            indices[idx * 6 + 2] = i + CONFETTI_WIDTH;
            indices[idx * 6 + 3] = i + 1;
            indices[idx * 6 + 4] = i + CONFETTI_WIDTH + 1;
            indices[idx * 6 + 5] = i + CONFETTI_WIDTH;
        }
    }
    NSData *vertexData = [NSData dataWithBytes:vertices length:vertexSize];
    NSData *indexData = [NSData dataWithBytes:indices length:indexSize];
    [self createVAOWithVertexData:vertexData indexData:indexData];
    return [self initWithVerticesData:vertexData indicesData:indexData];
}

- (void) createVAOWithVertexData:(NSData *)vertexData indexData:(NSData *)indexData
{
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [vertexData length], [vertexData bytes], GL_STATIC_DRAW);
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, [indexData length], [indexData bytes], GL_STATIC_DRAW);
    
    glGenVertexArrays(1, &meshVAO);
    glBindVertexArray(meshVAO);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(ConfettiSceneVertex), NULL + offsetof(ConfettiSceneVertex, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(ConfettiSceneVertex), NULL + offsetof(ConfettiSceneVertex, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(ConfettiSceneVertex), NULL + offsetof(ConfettiSceneVertex, yRange));
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBindVertexArray(0);
}


- (GLuint) vertexArrayObject
{
    return meshVAO;
}

- (void) drawEntireMesh
{
    glDrawElements(GL_TRIANGLES, (GLsizei)indexCount, GL_UNSIGNED_INT, NULL);
}

- (void) updateWithPercentage:(CGFloat)percentage timeInterval:(NSTimeInterval)timeInterval
{
    CGFloat shredderPosition = self.screenHeight * percentage;
    if (shredderPosition > startingY + length) {
        self.fallingTime += timeInterval;
        self.fallingDistance = -0.5 * 10000 * self.fallingTime * self.fallingTime;
    }
}

- (void) destroyGL
{
    glDeleteVertexArrays(1, &meshVAO);
    meshVAO = 0;
    glDeleteBuffers(1, &vertexBuffer);
    vertexBuffer = 0;
    glDeleteBuffers(1, &indexBuffer);
    indexBuffer = 0;
}
@end
