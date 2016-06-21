//
//  DHTextOrbitalMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextOrbitalMesh.h"
#import <OpenGLES/ES3/glext.h>
#import <CoreText/CoreText.h>
#import "TextureHelper.h"

typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLfloat direction;
    GLfloat rotationRadius;
}DHTextOrbitalAttributes;

@interface DHTextOrbitalMesh() {
    DHTextOrbitalAttributes *vertices;
}
@end

@implementation DHTextOrbitalMesh

- (void) generateMeshesData
{
    NSInteger vertexSize = sizeof(DHTextOrbitalAttributes) * self.vertexCount;
    vertices = malloc(vertexSize);
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    int centerIndex = (int)CTLineGetStringIndexForPosition(line, CGPointMake(self.attributedText.size.width / 2, self.attributedText.size.height / 2));
    for (int i = 0; i < [self.attributedText length]; i++) {
        int offsetToCenter = abs(i - centerIndex);
        GLfloat direction = (offsetToCenter % 2 == 0) ? 1.f : -1.f;
        
        GLfloat offset = attributes[i * 4 + 0].position.x - self.origin.x;
        GLfloat nextCharOffset = attributes[i * 4 + 1].position.x - self.origin.x;
        
        GLfloat radius = offset + (nextCharOffset - offset) / 2 - self.attributedText.size.width / 2;
        if (i == centerIndex) {
            radius = 0.f;
        }
        vertices[i * 4 + 0].position = attributes[i * 4 + 0].position;
        vertices[i * 4 + 0].texCoords = attributes[i * 4 + 0].texCoords;
        vertices[i * 4 + 0].direction = direction;
        vertices[i * 4 + 0].rotationRadius = radius;
        
        vertices[i * 4 + 1].position = attributes[i * 4 + 1].position;
        vertices[i * 4 + 1].texCoords = attributes[i * 4 + 1].texCoords;
        vertices[i * 4 + 1].direction = direction;
        vertices[i * 4 + 1].rotationRadius = radius;
        
        vertices[i * 4 + 2].position = attributes[i * 4 + 2].position;
        vertices[i * 4 + 2].texCoords = attributes[i * 4 + 2].texCoords;
        vertices[i * 4 + 2].direction = direction;
        vertices[i * 4 + 2].rotationRadius = radius;
        
        vertices[i * 4 + 3].position = attributes[i * 4 + 3].position;
        vertices[i * 4 + 3].texCoords = attributes[i * 4 + 3].texCoords;
        vertices[i * 4 + 3].direction = direction;
        vertices[i * 4 + 3].rotationRadius = radius;
    }
    self.vertexData = [NSData dataWithBytesNoCopy:vertices length:vertexSize];
    self.indexData = [NSData dataWithBytes:indicies length:self.indexCount * sizeof(GLubyte)];
    [self prepareToDraw];
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
        glGenVertexArrays(1, &vertexArray);
    }
    if (indexBuffer == 0) {
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indexData length], [self.indexData bytes], GL_STATIC_DRAW);
    }
    
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self.vertexData length], [self.vertexData bytes], GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHTextOrbitalAttributes), NULL + offsetof(DHTextOrbitalAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHTextOrbitalAttributes), NULL + offsetof(DHTextOrbitalAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHTextOrbitalAttributes), NULL + offsetof(DHTextOrbitalAttributes, direction));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHTextOrbitalAttributes), NULL + offsetof(DHTextOrbitalAttributes, rotationRadius));
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
