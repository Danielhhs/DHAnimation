//
//  ShredderMesh.m
//  ShrederAnimation
//
//  Created by Huang Hongsen on 12/21/15.
//  Copyright © 2015 cn.daniel. All rights reserved.
//

#import "DHShredderMesh.h"
#import <OpenGLES/ES3/glext.h>
@interface DHShredderMesh () {
    SceneMeshVertex *vertices;
    GLuint meshVAO;
}
@property (nonatomic) GLfloat shredderHeight;
@end

#define SHREDDER_INSET 5

@implementation DHShredderMesh

- (instancetype) initWithView:(UIView *)targetView containerView:(UIView *)containerView shredderHeight:(GLfloat)height
{
    self = [super init];
    if (self) {
        GLfloat originY = self.targetView.frame.size.height;
        if (containerView) {
            originY = self.containerView.bounds.size.height;
        }
        _shredderHeight = height;
        self.targetView = targetView;
        self.containerView = containerView;
        vertices = malloc(sizeof(SceneMeshVertex) * 4);
        vertices[0].position = GLKVector3Make(self.targetView.frame.origin.x - SHREDDER_INSET, originY - height, 0);
        vertices[0].texCoords = GLKVector2Make(0, 1);
        vertices[1].position = GLKVector3Make(CGRectGetMaxX(self.targetView.frame) + SHREDDER_INSET, originY - height, 0);
        vertices[1].texCoords = GLKVector2Make(1, 1);
        vertices[2].position = GLKVector3Make(self.targetView.frame.origin.x, originY - SHREDDER_INSET, 0);
        vertices[2].texCoords = GLKVector2Make(0, 0);
        vertices[3].position = GLKVector3Make(CGRectGetMaxX(self.targetView.frame) + SHREDDER_INSET, originY, 0);
        vertices[3].texCoords = GLKVector2Make(1, 0);
        
        GLushort indicies[6] = {0,1,2,2,1,3};
        NSData *vertexData = [NSData dataWithBytes:vertices length:sizeof(SceneMeshVertex) * 4];
        NSData *indexData = [NSData dataWithBytes:indicies length:sizeof(indicies)];
        [self createVAOWithVertexData:vertexData indexData:indexData];
        return [self initWithVerticesData:vertexData indicesData:indexData];
    }
    return nil;
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
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBindVertexArray(meshVAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, NULL);
    glBindVertexArray(0);
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
