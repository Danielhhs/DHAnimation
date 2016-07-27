//
//  SceneMesh.m
//  StartAgain
//
//  Created by Huang Hongsen on 5/18/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "DHSceneMesh.h"
#import <OpenGLES/ES3/glext.h>

@interface DHSceneMesh ()
@property (nonatomic) BOOL columnMajored;
@property (nonatomic) BOOL rotateTexture;
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
        _containerView = containerView;
        _targetView = view;
        if (containerView) {
            _originY = containerView.bounds.size.height - CGRectGetMaxY(view.frame);
        } else {
            _originY = 0;
        }
        _columnCount = columnCount;
        _rowCount = rowCount;
        _columnMajored = columnMajored;
        _rotateTexture = rotateTexture;
    }
    [self generateVerticesAndIndicesForView:self.targetView containerView:self.containerView columnCount:self.columnCount rowCount:self.rowCount columnMajored:self.columnMajored rotateTexture:self.rotateTexture];
    return self;
}

- (instancetype) initWithVerticesData:(NSData *)verticesData indicesData:(NSData *)indicesData
{
    self = [super init];
    if (self) {
        self.verticesData = verticesData;
        self.indicesData = indicesData;
        [self prepareToDraw];
        self.bufferDataBumped = YES;
    }
    return self;
}

- (void) generateMeshData
{
    _verticesData = [NSData dataWithBytesNoCopy:vertices length:self.verticesSize freeWhenDone:YES];
    _indicesData = [NSData dataWithBytes:indices length:self.indicesSize];
    [self prepareToDraw];
    self.bufferDataBumped = YES;
}

- (void) prepareToDraw
{
    if (self.bufferDataBumped == NO) {
        if (vertexBuffer == 0 && [self.verticesData length] > 0) {
            glGenBuffers(1, &vertexBuffer);
            glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
            glGenVertexArrays(1, &vertexArray);
            glBindVertexArray(vertexArray);
        }
        if (indexBuffer == 0 && [self.indicesData length] > 0) {
            glGenBuffers(1, &indexBuffer);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
            glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indicesData length], [self.indicesData bytes], GL_STATIC_DRAW);
        }
        
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.verticesData length], [self.verticesData bytes], GL_STATIC_DRAW);
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
        glVertexAttribPointer(7, 1, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, rotating));
        
        glEnableVertexAttribArray(8);
        glVertexAttribPointer(8, 1, GL_FLOAT, GL_FALSE, sizeof(SceneMeshVertex), NULL + offsetof(SceneMeshVertex, startTime));
        
    }
    glBindVertexArray(0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    self.bufferDataBumped = YES;
}

- (void) drawIndicesWithMode:(GLenum)mode startIndex:(GLuint)index indicesCount:(size_t)indicesCount
{
    glDrawArrays(mode, index, (GLint)indicesCount);
}

- (void) makeDynamicAndUpdateWithVertices:(const SceneMeshVertex *)verticies numberOfVertices:(size_t)numberOfVertices
{
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SceneMeshVertex) * numberOfVertices, verticies, GL_DYNAMIC_DRAW);
    self.bufferDataBumped = NO;
}

- (void) tearDown
{
    if (vertexBuffer != 0) {
        glDeleteBuffers(1, &vertexBuffer);
        vertexBuffer = 0;
    }
    if (indexBuffer != 0) {
        glDeleteBuffers(1, &indexBuffer);
        indexBuffer = 0;
    }
//    self.verticesData = nil;
//    self.indicesData = nil;
//    free(vertices);
//    free(indices);
}

- (void) drawEntireMesh
{
    glBindVertexArray(vertexArray);
    glDrawElements(GL_TRIANGLES, (int)self.indexCount, GL_UNSIGNED_INT, NULL);
    glBindVertexArray(0);
}

- (void) destroyGL
{
    [self tearDown];
}

#pragma mark - Generate vertices and indices
- (void) generateVerticesAndIndicesForView:(UIView *)view containerView:(UIView *)containerView columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount columnMajored:(BOOL)columnMajor rotateTexture:(BOOL)rotateTexture
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

- (BOOL) needToUpdateBufferData
{
    return NO;
}
@end
