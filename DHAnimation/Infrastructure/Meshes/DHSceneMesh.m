//
//  SceneMesh.m
//  StartAgain
//
//  Created by Huang Hongsen on 5/18/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "DHSceneMesh.h"

@interface DHSceneMesh ()
@end

@implementation DHSceneMesh

- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored rotateTexture:(BOOL)rotateTexture
{
    return [self initWithView:view  containerView:nil columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:splitTexture columnMajored:columnMajored rotateTexture:rotateTexture];
}

- (instancetype) initWithView:(UIView *)view containerView:(UIView *)containerView columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored rotateTexture:(BOOL)rotateTexture
{
    self = [super init];
    if (self) {
        _originX = view.frame.origin.x;
        if (containerView) {
            _originY = containerView.bounds.size.height - CGRectGetMaxY(view.frame);
        } else {
            _originY = 0;
        }
        _columnCount = columnCount;
        _rowCount = rowCount;
        
        [self generateVerticesAndIndicesForView:view columnCount:columnCount rowCount:rowCount columnMajored:columnMajored rotateTexture:rotateTexture];
        
        _verticesData = [NSData dataWithBytes:vertices length:self.verticesSize];
        _indicesData = [NSData dataWithBytes:indices length:self.indicesSize];
    }
    return self;
}

- (instancetype) initWithVerticesData:(NSData *)verticesData indicesData:(NSData *)indicesData
{
    self = [super init];
    if (self) {
        self.verticesData = verticesData;
        self.indicesData = indicesData;
    }
    return self;
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0 && [self.verticesData length] > 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.verticesData length], [self.verticesData bytes], GL_STATIC_DRAW);
    }
    if (indexBuffer == 0 && [self.indicesData length] > 0) {
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indicesData length], [self.indicesData bytes], GL_STATIC_DRAW);
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, normal));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, texCoords));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, columnStartPosition));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, rotation));
    
    glEnableVertexAttribArray(5);
    glVertexAttribPointer(5, 3, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, originalCenter));
    
    glEnableVertexAttribArray(6);
    glVertexAttribPointer(6, 3, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, targetCenter));
    
    glEnableVertexAttribArray(7);
    glVertexAttribPointer(7, 1, GL_BOOL, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, rotating));
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
}

- (void) drawIndicesWithMode:(GLenum)mode startIndex:(GLuint)index indicesCount:(size_t)indicesCount
{
    glDrawArrays(mode, index, (GLint)indicesCount);
}

- (void) makeDynamicAndUpdateWithVertices:(const SceneMeshVertex *)verticies numberOfVertices:(size_t)numberOfVertices
{
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SceneMeshVertex) * numberOfVertices, verticies, GL_DYNAMIC_DRAW);
}

- (void) tearDown
{
    if (vertexBuffer != 0) {
        glDeleteBuffers(1, &vertexBuffer);
    }
    if (indexBuffer != 0) {
        glDeleteBuffers(1, &indexBuffer);
    }
}

- (void) drawEntireMesh
{
    glDrawElements(GL_TRIANGLES, (int)self.indexCount, GL_UNSIGNED_INT, NULL);
}

- (void) destroyGL
{
    [self tearDown];
}

#pragma mark - Generate vertices and indices
- (void) generateVerticesAndIndicesForView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount columnMajored:(BOOL)columnMajor rotateTexture:(BOOL)rotateTexture
{
    
}

- (void) setupForVertexAtX:(NSInteger)x y:(NSInteger)y index:(NSInteger)index
{
    
}

- (void) printVertices
{
    for (int i = 0; i < self.vertexCount; i++) {
        NSLog(@"Vertices[%d].position = (%g, %g, %g)", i, vertices[i].position.x, vertices[i].position.y, vertices[i].position.z);
    }
}
@end
