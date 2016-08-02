//
//  DHShredderMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 7/31/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShredderAnimationSceneMesh.h"
#import <OpenGLES/ES3/glext.h>

@interface DHShredderAnimationSceneMesh () {
    DHShredderSceneMeshAttributes *vertices;
    GLuint *indices;
    GLuint vertexBuffer, indexBuffer, vertexArray;
}
@property (nonatomic, strong) NSData *vertexData;
@property (nonatomic, strong) NSData *indexData;
@end

@implementation DHShredderAnimationSceneMesh

- (instancetype) initWithTargetView:(UIView *)targetView containerView:(UIView *)containerView columnCount:(NSInteger)columnCount
{
    self = [super init];
    if (self) {
        self.targetView = targetView;
        self.containerView = containerView;
        self.columnCount = columnCount;
        self.rowCount = targetView.frame.size.height;
    }
    return self;
}

- (void) generateMeshData
{
    self.vertexCount = 4 * self.columnCount * self.rowCount;
    self.indexCount = 6 * self.columnCount * self.rowCount;
    vertices = malloc(self.vertexCount * sizeof(DHShredderSceneMeshAttributes));
    
    GLfloat originX = self.targetView.frame.origin.x;
    GLfloat originY = self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame);
    for (int i = 0; i < self.columnCount; i++) {
        GLfloat radius = 0;
        if (i % 2 == 0) {
            radius = self.targetView.frame.size.height * 1.382 + arc4random() % (int)self.targetView.frame.size.height * 0.5;
        } else {
            radius = self.targetView.frame.size.height * 1.618 + arc4random() % (int)self.targetView.frame.size.height;
        }
        GLfloat zOffset = 0;
        if (i % 2 == 1) {
            zOffset = -1 * (self.targetView.frame.size.height * 0.2 + arc4random() % (int)(self.targetView.frame.size.height * 0.1));
        }
        GLfloat columnCenter = originX + (i + 0.5) * self.targetView.frame.size.width / self.columnCount;
        for (int row = 0; row < self.targetView.frame.size.height; row++) {
            NSInteger index = i * self.rowCount + row;
            vertices[index * 4 + 0].position = GLKVector3Make(originX + self.targetView.frame.size.width / self.columnCount * i, originY + row / (GLfloat)self.rowCount * self.targetView.frame.size.height, 0);
            vertices[index * 4 + 0].texCoords = GLKVector2Make(i / (GLfloat)self.columnCount, 1.f - (GLfloat)row / self.rowCount);
            vertices[index * 4 + 0].radius = radius;
            vertices[index * 4 + 0].shredderedZOffset = zOffset;
            
            vertices[index * 4 + 1].position = GLKVector3Make(originX + self.targetView.frame.size.width / self.columnCount * (i + 1), originY + row / (GLfloat)self.rowCount * self.targetView.frame.size.height, 0);
            vertices[index * 4 + 1].texCoords = GLKVector2Make((i + 1) / (GLfloat)self.columnCount, 1.f - (GLfloat)row / self.rowCount);
            vertices[index * 4 + 1].radius = radius;
            vertices[index * 4 + 1].shredderedZOffset = zOffset;
            
            vertices[index * 4 + 2].position = GLKVector3Make(originX + self.targetView.frame.size.width / self.columnCount * i, originY +  (1 + row) / (GLfloat)self.rowCount * self.targetView.frame.size.height, 0);
            vertices[index * 4 + 2].texCoords = GLKVector2Make(i / (GLfloat)self.columnCount, 1.f - (GLfloat)(row + 1) / self.rowCount);
            vertices[index * 4 + 2].radius = radius;
            vertices[index * 4 + 2].shredderedZOffset = zOffset;
            
            vertices[index * 4 + 3].position = GLKVector3Make(originX + self.targetView.frame.size.width / self.columnCount * (i + 1), originY + (1 + row) / (GLfloat)self.rowCount * self.targetView.frame.size.height, 0);
            vertices[index * 4 + 3].texCoords = GLKVector2Make((i + 1) / (GLfloat)self.columnCount, 1.f - (GLfloat)(row + 1) / self.rowCount);
            vertices[index * 4 + 3].radius = radius;
            vertices[index * 4 + 3].shredderedZOffset = zOffset;
            
            vertices[index * 4 + 0].columnCenter = columnCenter;
            vertices[index * 4 + 1].columnCenter = columnCenter;
            vertices[index * 4 + 2].columnCenter = columnCenter;
            vertices[index * 4 + 3].columnCenter = columnCenter;
        }
    }
    
    indices = malloc(self.indexCount * sizeof(GLuint));
    for (int i = 0; i < self.columnCount; i++) {
        for (int row = 0; row < self.rowCount; row++) {
            NSInteger index = i * self.rowCount + row;
            indices[index * 6 + 0] = (GLuint)index * 4 + 0;
            indices[index * 6 + 1] = (GLuint)index * 4 + 1;
            indices[index * 6 + 2] = (GLuint)index * 4 + 2;
            indices[index * 6 + 3] = (GLuint)index * 4 + 2;
            indices[index * 6 + 4] = (GLuint)index * 4 + 1;
            indices[index * 6 + 5] = (GLuint)index * 4 + 3;
        }
    }
    
    self.vertexData = [NSData dataWithBytesNoCopy:vertices length:self.vertexCount * sizeof(DHShredderSceneMeshAttributes) freeWhenDone:YES];
    self.indexData = [NSData dataWithBytes:indices length:self.indexCount * sizeof(GLuint)];
    [self prepareToDraw];
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0 && [self.vertexData length] > 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.vertexData length], [self.vertexData bytes], GL_STATIC_DRAW);
        
        glGenVertexArrays(1, &vertexArray);
        glBindVertexArray(vertexArray);
    }
    if (indexBuffer == 0 && [self.indexData length] > 0) {
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indexData length], [self.indexData bytes], GL_STATIC_DRAW);
    }
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHShredderSceneMeshAttributes), NULL + offsetof(DHShredderSceneMeshAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHShredderSceneMeshAttributes), NULL + offsetof(DHShredderSceneMeshAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderSceneMeshAttributes), NULL + offsetof(DHShredderSceneMeshAttributes, radius));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderSceneMeshAttributes), NULL + offsetof(DHShredderSceneMeshAttributes, columnCenter));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderSceneMeshAttributes), NULL + offsetof(DHShredderSceneMeshAttributes, shredderedZOffset));
    glBindVertexArray(0);
}

- (GLfloat) randomRadius
{
    GLfloat base = self.targetView.frame.size.height * 2;
    int random = arc4random() % (int)self.targetView.frame.size.height - (int)self.targetView.frame.size.height / 2;
    return base + random;
}

- (void) drawEntireMesh
{
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBindVertexArray(vertexArray);
    for (int i = 0; i < self.columnCount / 2; i++) {
        glDrawElements(GL_TRIANGLES, (GLsizei)self.rowCount * 6, GL_UNSIGNED_INT, NULL + i * self.rowCount * 6 * sizeof(GLuint));
    }
    for (NSInteger i = self.columnCount - 1; i >= self.columnCount / 2; i--) {
        glDrawElements(GL_TRIANGLES, (GLsizei)self.rowCount * 6, GL_UNSIGNED_INT, NULL + i * self.rowCount * 6 * sizeof(GLuint));
    }
    glBindVertexArray(0);
}

@end
