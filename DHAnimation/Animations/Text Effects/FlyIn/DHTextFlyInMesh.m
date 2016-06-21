//
//  DHTextFlyInMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextFlyInMesh.h"
#import <OpenGLES/ES3/glext.h>

typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLKVector2 center;
    GLfloat startTime;
    GLfloat lifeTime;
}DHTextFlyInAttributes;

@interface DHTextFlyInMesh () {
    DHTextFlyInAttributes *vertices;
}
@property (nonatomic) NSTimeInterval lifeTime;
@end

@implementation DHTextFlyInMesh

- (instancetype) initWithAttributedText:(NSAttributedString *)attributedText origin:(CGPoint)origin textContainerView:(UIView *)textContainerView containerView:(UIView *)containerView lifeTime:(NSTimeInterval)lifeTime
{
    self = [super initWithAttributedText:attributedText origin:origin textContainerView:textContainerView containerView:containerView];
    if (self) {
        _lifeTime = lifeTime;
    }
    return self;
}

- (void) generateMeshesData
{
    vertices = malloc(sizeof(DHTextFlyInAttributes) * self.vertexCount);
    int numberOfChars = (int)[self.attributedText length] - 1;
    for (int i = 0; i < [self.attributedText length]; i++) {
        GLfloat centerX = (attributes[i * 4 + 1].position.x + attributes[i * 4 + 0].position.x) / 2;
        GLfloat centerY = (attributes[i * 4 + 2].position.y + attributes[i * 4 + 0].position.y) / 2;
        GLKVector2 center = GLKVector2Make(centerX, centerY);
        vertices[i * 4 + 0].position = attributes[i * 4 + 0].position;
        vertices[i * 4 + 0].texCoords = attributes[i * 4 + 0].texCoords;
        vertices[i * 4 + 0].center = center;
        vertices[i * 4 + 0].startTime = self.lifeTime / 2 * (numberOfChars - i);
        vertices[i * 4 + 0].lifeTime = self.lifeTime;
        
        vertices[i * 4 + 1].position = attributes[i * 4 + 1].position;
        vertices[i * 4 + 1].texCoords = attributes[i * 4 + 1].texCoords;
        vertices[i * 4 + 1].center = center;
        vertices[i * 4 + 1].startTime = self.lifeTime / 2 * (numberOfChars - i);
        vertices[i * 4 + 1].lifeTime = self.lifeTime;
        
        vertices[i * 4 + 2].position = attributes[i * 4 + 2].position;
        vertices[i * 4 + 2].texCoords = attributes[i * 4 + 2].texCoords;
        vertices[i * 4 + 2].center = center;
        vertices[i * 4 + 2].startTime = self.lifeTime / 2 * (numberOfChars - i);
        vertices[i * 4 + 2].lifeTime = self.lifeTime;
        
        vertices[i * 4 + 3].position = attributes[i * 4 + 3].position;
        vertices[i * 4 + 3].texCoords = attributes[i * 4 + 3].texCoords;
        vertices[i * 4 + 3].center = center;
        vertices[i * 4 + 3].startTime = self.lifeTime / 2 * (numberOfChars - i);
        vertices[i * 4 + 3].lifeTime = self.lifeTime;
    }
    self.vertexData = [NSData dataWithBytesNoCopy:vertices length:sizeof(DHTextFlyInAttributes) * self.vertexCount];
    self.indexData = [NSData dataWithBytes:indicies length:self.indexCount * sizeof(GLubyte)];
    [self prepareToDraw];
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.vertexData length], [self.vertexData bytes], GL_STATIC_DRAW);
        glGenVertexArrays(1, &vertexArray);
    }
    if (indexBuffer == 0) {
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indexData length], [self.indexData bytes], GL_STATIC_DRAW);
    }
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHTextFlyInAttributes), NULL + offsetof(DHTextFlyInAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHTextFlyInAttributes), NULL + offsetof(DHTextFlyInAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(DHTextFlyInAttributes), NULL + offsetof(DHTextFlyInAttributes, center));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHTextFlyInAttributes), NULL + offsetof(DHTextFlyInAttributes, startTime));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHTextFlyInAttributes), NULL + offsetof(DHTextFlyInAttributes, lifeTime));
    glBindVertexArray(0);
}

- (void) drawEntireMesh
{
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glDrawElements(GL_TRIANGLES, (GLsizei)self.indexCount, GL_UNSIGNED_BYTE, NULL);
    glBindVertexArray(0);
}

@end
