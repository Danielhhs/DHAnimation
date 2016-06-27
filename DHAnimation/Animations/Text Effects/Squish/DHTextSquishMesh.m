//
//  DHTextSquishMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextSquishMesh.h"
#import <OpenGLES/ES3/glext.h>
typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLfloat startTime;
    GLKVector2 center;
}DHTextSquishAttributes;

@interface DHTextSquishMesh () {
    DHTextSquishAttributes *vertices;
}

@end

@implementation DHTextSquishMesh

- (void) generateMeshesData
{
    vertices = malloc(sizeof(DHTextSquishAttributes) * self.vertexCount);
    GLfloat timeGap = self.duration * (1.f - self.squishTimeRatio) / ([self.attributedText length] - 1);
    for (int i = 0; i < [self.attributedText length]; i++) {
        GLKVector2 center = GLKVector2Make((attributes[i * 4 + 0].position.x + attributes[i * 4 + 1].position.x) / 2, (attributes[i * 4 + 2].position.y + attributes[i * 4 + 0].position.y) / 2);
        vertices[i * 4 + 0].position = attributes[i * 4 + 0].position;
        vertices[i * 4 + 0].texCoords = attributes[i * 4 + 0].texCoords;
        vertices[i * 4 + 0].startTime = timeGap * i;
        vertices[i * 4 + 0].center = center;
        
        vertices[i * 4 + 1].position = attributes[i * 4 + 1].position;
        vertices[i * 4 + 1].texCoords = attributes[i * 4 + 1].texCoords;
        vertices[i * 4 + 1].startTime = timeGap * i;
        vertices[i * 4 + 1].center = center;
        
        vertices[i * 4 + 2].position = attributes[i * 4 + 2].position;
        vertices[i * 4 + 2].texCoords = attributes[i * 4 + 2].texCoords;
        vertices[i * 4 + 2].startTime = timeGap * i;
        vertices[i * 4 + 2].center = center;
        
        vertices[i * 4 + 3].position = attributes[i * 4 + 3].position;
        vertices[i * 4 + 3].texCoords = attributes[i * 4 + 3].texCoords;
        vertices[i * 4 + 3].startTime = timeGap * i;
        vertices[i * 4 + 3].center = center;
    }
    
    self.vertexData = [NSData dataWithBytesNoCopy:vertices length:sizeof(DHTextSquishAttributes) * self.vertexCount];
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHTextSquishAttributes), NULL + offsetof(DHTextSquishAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHTextSquishAttributes), NULL + offsetof(DHTextSquishAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHTextSquishAttributes), NULL + offsetof(DHTextSquishAttributes, startTime));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 2, GL_FLOAT, GL_FALSE, sizeof(DHTextSquishAttributes), NULL + offsetof(DHTextSquishAttributes, center));
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
