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
}DHTextFlyInAttributes;

@interface DHTextFlyInMesh () {
    DHTextFlyInAttributes *vertices;
}
@end

@implementation DHTextFlyInMesh

- (void) generateMeshesData
{
    vertices = malloc(sizeof(DHTextFlyInAttributes) * self.vertexCount);
    
    for (int i = 0; i < [self.attributedText length]; i++) {
        GLfloat centerX = (attributes[i * 4 + 1].position.x + attributes[i * 4 + 0].position.x) / 2;
        GLfloat centerY = (attributes[i * 4 + 2].position.y + attributes[i * 4 + 0].position.y) / 2;
        GLKVector2 center = GLKVector2Make(centerX, centerY);
        vertices[i * 4 + 0].position = attributes[i * 4 + 0].position;
        vertices[i * 4 + 0].texCoords = attributes[i * 4 + 0].texCoords;
        vertices[i * 4 + 0].center = center;
        
        vertices[i * 4 + 1].position = attributes[i * 4 + 1].position;
        vertices[i * 4 + 1].texCoords = attributes[i * 4 + 1].texCoords;
        vertices[i * 4 + 1].center = center;
        
        vertices[i * 4 + 2].position = attributes[i * 4 + 2].position;
        vertices[i * 4 + 2].texCoords = attributes[i * 4 + 2].texCoords;
        vertices[i * 4 + 2].center = center;
        
        vertices[i * 4 + 3].position = attributes[i * 4 + 3].position;
        vertices[i * 4 + 3].texCoords = attributes[i * 4 + 3].texCoords;
        vertices[i * 4 + 3].center = center;
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
    
    glBindVertexArray(0);
    
}

- (void) drawEntireMesh
{
    glBindVertexArray(vertexArray);
    glDrawElements(GL_TRIANGLES, (GLsizei)self.indexCount, GL_UNSIGNED_BYTE, NULL);
    glBindVertexArray(0);
}

@end
