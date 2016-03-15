//
//  ShredderMesh.m
//  ShrederAnimation
//
//  Created by Huang Hongsen on 12/21/15.
//  Copyright © 2015 cn.daniel. All rights reserved.
//

#import "ShredderMesh.h"
#import <OpenGLES/ES3/glext.h>
@interface ShredderMesh () {
    SceneMeshVertex *vertices;
    GLuint meshVAO;
}

@end

@implementation ShredderMesh

- (instancetype) initWithScreenWidth:(size_t)screenWidth screenHeight:(size_t)screenHeight
{
    vertices = malloc(sizeof(SceneMeshVertex) * 4);
    vertices[0].position = GLKVector3Make(0, 0, 0);
    vertices[0].texCoords = GLKVector2Make(0, 1);
    vertices[1].position = GLKVector3Make(screenWidth, 0, 0);
    vertices[1].texCoords = GLKVector2Make(1, 1);
    vertices[2].position = GLKVector3Make(0, SHREDDER_HEIGHT, 0);
    vertices[2].texCoords = GLKVector2Make(0, 0);
    vertices[3].position = GLKVector3Make(screenWidth, SHREDDER_HEIGHT, 0);
    vertices[3].texCoords = GLKVector2Make(1, 0);
    
    GLushort indices[6] = {0,1,2,2,1,3};
    NSData *vertexData = [NSData dataWithBytes:vertices length:sizeof(SceneMeshVertex) * 4];
    NSData *indexData = [NSData dataWithBytes:indices length:sizeof(indices)];
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
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, normal));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, texCoords));
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBindVertexArray(0);
}

- (void) drawEntireMesh
{
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, NULL);
}

- (GLuint) vertexArrayObejct
{
    return meshVAO;
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
