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
    GLuint *indices;
}
@property (nonatomic) NSInteger indexCount;
@end

@implementation DHTextOrbitalMesh

- (void) generateMeshesData
{
    NSInteger vertexSize = sizeof(DHTextOrbitalAttributes) * [self.attributedText length] * 4;
    vertices = malloc(vertexSize);
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    int centerIndex = (int)CTLineGetStringIndexForPosition(line, CGPointMake(self.attributedText.size.width / 2, self.attributedText.size.height / 2));
    CGFloat width = self.attributedText.size.width;
    for (int i = 0; i < [self.attributedText length]; i++) {
        int offsetToCenter = abs(i - centerIndex);
        GLfloat direction = (offsetToCenter % 2 == 0) ? 1.f : -1.f;
        CGFloat offset = CTLineGetOffsetForStringIndex(line, i, NULL);
        CGFloat nextCharOffset = 0.f;
        if (i != [self.attributedText length] - 1) {
            nextCharOffset = CTLineGetOffsetForStringIndex(line, i + 1, NULL);
        } else {
            nextCharOffset = self.attributedText.size.width;
        }
        GLfloat radius = offset + (nextCharOffset - offset) / 2 - self.attributedText.size.width / 2;
        if (i == centerIndex) {
            radius = 0.f;
        }
        
        vertices[i * 4 + 0].position = GLKVector3Make(self.origin.x + offset, self.origin.y, 0);
        vertices[i * 4 + 0].texCoords = GLKVector2Make(offset / width, 1.f);
        vertices[i * 4 + 0].direction = direction;
        vertices[i * 4 + 0].rotationRadius = radius;
        
        vertices[i * 4 + 1].position = GLKVector3Make(self.origin.x + nextCharOffset, self.origin.y, 0);
        vertices[i * 4 + 1].texCoords = GLKVector2Make(nextCharOffset / width, 1.f);
        vertices[i * 4 + 1].direction = direction;
        vertices[i * 4 + 1].rotationRadius = radius;
        
        vertices[i * 4 + 2].position = GLKVector3Make(self.origin.x + offset, self.origin.y + self.attributedText.size.height, 0);
        vertices[i * 4 + 2].texCoords = GLKVector2Make(offset / width, 0.f);
        vertices[i * 4 + 2].direction = direction;
        vertices[i * 4 + 2].rotationRadius = radius;
        
        vertices[i * 4 + 3].position = GLKVector3Make(self.origin.x + nextCharOffset, self.origin.y + self.attributedText.size.height, 0);
        vertices[i * 4 + 3].texCoords = GLKVector2Make(nextCharOffset / width, 0.f);
        vertices[i * 4 + 3].direction = direction;
        vertices[i * 4 + 3].rotationRadius = radius;
        
    }
    
    self.indexCount = [self.attributedText length] * 6;
    indices = malloc(self.indexCount * sizeof(GLuint));
    for (int i = 0; i < [self.attributedText length]; i++) {
        indices[i * 6 + 0] = i * 4 + 0;
        indices[i * 6 + 1] = i * 4 + 1;
        indices[i * 6 + 2] = i * 4 + 2;
        indices[i * 6 + 3] = i * 4 + 2;
        indices[i * 6 + 4] = i * 4 + 1;
        indices[i * 6 + 5] = i * 4 + 3;
    }
    self.vertexData = [NSData dataWithBytesNoCopy:vertices length:vertexSize];
    self.indexData = [NSData dataWithBytes:indices length:self.indexCount * sizeof(GLuint)];
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
//        glGenVertexArrays(1, &vertexArray);
    }
    if (indexBuffer == 0) {
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indexData length], [self.indexData bytes], GL_STATIC_DRAW);
    }
    
//    glBindVertexArray(vertexArray);
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
//    glBindVertexArray(0);
}

- (void) drawEntireMesh
{
    //    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glDrawElements(GL_TRIANGLES, (GLsizei)self.indexCount, GL_UNSIGNED_INT, NULL);
}

- (void) printVertices
{
    for (int i = 0; i < [self.attributedText length]; i++) {
        NSLog(@"Vertex For Character At Index %d", i);
        NSLog(@"\t{%g, %g, %g}", vertices[i * 4 + 0].position.x, vertices[i * 4 + 0].position.y, vertices[i * 4 + 0].position.z);
        NSLog(@"\t{%g, %g, %g}", vertices[i * 4 + 1].position.x, vertices[i * 4 + 1].position.y, vertices[i * 4 + 1].position.z);
        NSLog(@"\t{%g, %g, %g}", vertices[i * 4 + 2].position.x, vertices[i * 4 + 2].position.y, vertices[i * 4 + 2].position.z);
        NSLog(@"\t{%g, %g, %g}", vertices[i * 4 + 3].position.x, vertices[i * 4 + 3].position.y, vertices[i * 4 + 3].position.z);
    }
}

- (void) printVerticesTextureCoords
{
    for (int i = 0; i < [self.attributedText length]; i++) {
        NSLog(@"Texture For Character At Index %d", i);
        NSLog(@"\t{%g, %g}", vertices[i * 4 + 0].texCoords.x, vertices[i * 4 + 0].texCoords.y);
        NSLog(@"\t{%g, %g}", vertices[i * 4 + 1].texCoords.x, vertices[i * 4 + 1].texCoords.y);
        NSLog(@"\t{%g, %g}", vertices[i * 4 + 2].texCoords.x, vertices[i * 4 + 2].texCoords.y);
        NSLog(@"\t{%g, %g}", vertices[i * 4 + 3].texCoords.x, vertices[i * 4 + 3].texCoords.y);
    }
}

@end
