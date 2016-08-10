//
//  DHTextFadeMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextFadeMesh.h"
#import <OpenGLES/ES3/glext.h>
typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLKVector3 fadingAnchor;
    GLfloat startFadingTime;
}DHTextFadeMeshAttributes;

@interface DHTextFadeMesh () {
    DHTextFadeMeshAttributes *vertices;
}

@end

@implementation DHTextFadeMesh

- (void) generateMeshesData
{
    vertices = malloc(sizeof(DHTextFadeMeshAttributes) * self.vertexCount);
    GLfloat startTimeGap = (1.f - self.singleCharacterFadingTimeRatio) * self.duration / [self.attributedText length];
    for (int i = 0; i < [self.attributedText length]; i++) {
        GLKVector3 fadingAnchor = GLKVector3Make((attributes[i * 4 + 0].position.x + attributes[i * 4 + 1].position.x) / 2, attributes[i * 4 + 0].position.y, 0);
        vertices[i * 4 + 0].position = attributes[i * 4 + 0].position;
        vertices[i * 4 + 0].texCoords = attributes[i * 4 + 0].texCoords;
        vertices[i * 4 + 0].fadingAnchor = fadingAnchor;
        vertices[i * 4 + 0].startFadingTime = startTimeGap * i;
        
        vertices[i * 4 + 1].position = attributes[i * 4 + 1].position;
        vertices[i * 4 + 1].texCoords = attributes[i * 4 + 1].texCoords;
        vertices[i * 4 + 1].fadingAnchor = fadingAnchor;
        vertices[i * 4 + 1].startFadingTime = startTimeGap * i;
        
        vertices[i * 4 + 2].position = attributes[i * 4 + 2].position;
        vertices[i * 4 + 2].texCoords = attributes[i * 4 + 2].texCoords;
        vertices[i * 4 + 2].fadingAnchor = fadingAnchor;
        vertices[i * 4 + 2].startFadingTime = startTimeGap * i;
        
        vertices[i * 4 + 3].position = attributes[i * 4 + 3].position;
        vertices[i * 4 + 3].texCoords = attributes[i * 4 + 3].texCoords;
        vertices[i * 4 + 3].fadingAnchor = fadingAnchor;
        vertices[i * 4 + 3].startFadingTime = startTimeGap * i;
    }
    
    self.vertexData = [NSData dataWithBytesNoCopy:vertices length:sizeof(DHTextFadeMeshAttributes) * self.vertexCount freeWhenDone:YES];
    self.indexData = [NSData dataWithBytes:indicies length:self.indexCount * sizeof(GLubyte)];
    [self prepareToDraw];
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0 && [self.vertexData length] > 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.vertexData length], [self.vertexData bytes], GL_STATIC_DRAW);
        glGenVertexArrays(1, &vertexArray);
    }
    if (indexBuffer == 0 && [self.indexData length] > 0) {
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indexData length], [self.indexData bytes], GL_STATIC_DRAW);
    }
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHTextFadeMeshAttributes), NULL + offsetof(DHTextFadeMeshAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHTextFadeMeshAttributes), NULL + offsetof(DHTextFadeMeshAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(DHTextFadeMeshAttributes), NULL + offsetof(DHTextFadeMeshAttributes, fadingAnchor));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHTextFadeMeshAttributes), NULL + offsetof(DHTextFadeMeshAttributes, startFadingTime));
    
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
