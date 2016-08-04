//
//  DHShredderConfettiMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/2/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShredderConfettiMesh.h"
#import <OpenGLES/ES3/glext.h>

typedef struct{
    GLKVector3 position;
    GLKVector2 texCoords;
    GLfloat startY;
    GLfloat length;
    GLfloat radius;
    GLfloat startFallingTime;
}DHShredderConfettiMeshAttributes;

@interface DHShredderConfettiMesh () {
}
@property (nonatomic, strong) NSMutableData *vertexData;
@property (nonatomic, strong) NSMutableData *indexData;
@end

@implementation DHShredderConfettiMesh

- (instancetype) initWithTargetView:(UIView *)targetView containerView:(UIView *)containerView
{
    self = [super init];
    if (self) {
        self.targetView = targetView;
        self.containerView = containerView;
        self.vertexData = [NSMutableData data];
        self.indexData = [NSMutableData data];
    }
    return self;
}

- (void) appendConfettiAtPosition:(GLKVector3)position length:(GLfloat)length startFallingTime:(GLfloat)startFallingTime
{
    GLfloat width = 3 + arc4random() % 3;
    GLfloat originX = self.targetView.frame.origin.x;
    GLfloat originY = 0;
    if (self.containerView) {
        originY = self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame);
    }
    for (int i = 0; i < length; i++) {
        GLfloat radius = length / 2 + arc4random() % (int)length;
        DHShredderConfettiMeshAttributes bottomLeft;
        bottomLeft.position = GLKVector3Make(position.x, position.y + i, position.z);
        bottomLeft.texCoords = GLKVector2Make((bottomLeft.position.x - originX) / self.targetView.frame.size.width, 1.f - (bottomLeft.position.y - originY) / self.targetView.frame.size.height);
        bottomLeft.length = length;
        bottomLeft.radius = radius;
        bottomLeft.startY = position.y;
        bottomLeft.startFallingTime = startFallingTime;
        [self.vertexData appendBytes:&bottomLeft length:sizeof(DHShredderConfettiMeshAttributes)];
        
        DHShredderConfettiMeshAttributes bottomRight;
        bottomRight.position = GLKVector3Make(position.x + width, position.y + i, position.z);
        bottomRight.texCoords = GLKVector2Make((bottomRight.position.x - originX) / self.targetView.frame.size.width, 1.f - (bottomRight.position.y - originY) / self.targetView.frame.size.height);
        bottomRight.length = length;
        bottomRight.radius = radius;
        bottomRight.startY = position.y;
        bottomRight.startFallingTime = startFallingTime;
        [self.vertexData appendBytes:&bottomRight length:sizeof(DHShredderConfettiMeshAttributes)];
        
        DHShredderConfettiMeshAttributes topLeft;
        topLeft.position = GLKVector3Make(position.x, position.y + 1 + i, position.z);
        topLeft.texCoords = GLKVector2Make((topLeft.position.x - originX) / self.targetView.frame.size.width, 1.f - (topLeft.position.y - originY) / self.targetView.frame.size.height);
        topLeft.length = length;
        topLeft.radius = radius;
        topLeft.startY = position.y;
        topLeft.startFallingTime = startFallingTime;
        [self.vertexData appendBytes:&topLeft length:sizeof(DHShredderConfettiMeshAttributes)];
        
        DHShredderConfettiMeshAttributes topRight;
        topRight.position = GLKVector3Make(position.x + width, position.y + 1 + i, position.z);
        topRight.texCoords = GLKVector2Make((topRight.position.x - originX) / self.targetView.frame.size.width, 1.f - (topRight.position.y - originY) / self.targetView.frame.size.height);
        topRight.length = length;
        topRight.radius = radius;
        topRight.startY = position.y;
        topRight.startFallingTime = startFallingTime;
        [self.vertexData appendBytes:&topRight length:sizeof(DHShredderConfettiMeshAttributes)];
    }
    
    for (int i = 0; i < length; i++) {
        GLuint index1 = ((GLuint)self.indexCount / 6 + i) * 4 + 0;
        GLuint index2 = ((GLuint)self.indexCount / 6 + i) * 4 + 1;
        GLuint index3 = ((GLuint)self.indexCount / 6 + i) * 4 + 2;
        GLuint index4 = ((GLuint)self.indexCount / 6 + i) * 4 + 2;
        GLuint index5 = ((GLuint)self.indexCount / 6 + i) * 4 + 1;
        GLuint index6 = ((GLuint)self.indexCount / 6 + i) * 4 + 3;
        [self.indexData appendBytes:&index1 length:sizeof(GLuint)];
        [self.indexData appendBytes:&index2 length:sizeof(GLuint)];
        [self.indexData appendBytes:&index3 length:sizeof(GLuint)];
        [self.indexData appendBytes:&index4 length:sizeof(GLuint)];
        [self.indexData appendBytes:&index5 length:sizeof(GLuint)];
        [self.indexData appendBytes:&index6 length:sizeof(GLuint)];
    }
    self.indexCount += 6 * length;
    self.vertexCount += 4 * length;
}


- (NSData *)verticesData
{
    return self.vertexData;
}

- (NSData *) indicesData
{
    return self.indexData;
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0 && [self.vertexData length] > 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.vertexData length], [self.vertexData bytes], GL_STATIC_DRAW);
    }
    if (indexBuffer == 0 && [self.indexData length] > 0) {
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indexData length], [self.indexData bytes], GL_STATIC_DRAW);
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, startY));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, length));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, radius));
    
    glEnableVertexAttribArray(5);
    glVertexAttribPointer(5, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, startFallingTime));
//    glBindVertexArray(0);
}

- (void) drawEntireMesh
{
    [self prepareToDraw];
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
//    glBindVertexArray(vertexArray);
    glDrawElements(GL_TRIANGLES, self.indexCount, GL_UNSIGNED_INT, NULL);
//    glBindVertexArray(0);
}

@end
