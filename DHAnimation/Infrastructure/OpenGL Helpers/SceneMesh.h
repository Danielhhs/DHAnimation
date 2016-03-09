//
//  SceneMesh.h
//  StartAgain
//
//  Created by Huang Hongsen on 5/18/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef struct {
    GLKVector3 position;
    GLKVector3 normal;
    GLKVector2 texCoords;
    GLKVector3 columnStartPosition;
}SceneMeshVertex;

@interface SceneMesh : NSObject {
    GLuint vertexBuffer;
    GLuint indexBuffer;
    SceneMeshVertex *vertices;
    GLushort *indices;
}
@property (nonatomic, strong) NSData *verticesData;
@property (nonatomic, strong) NSData *indicesData;
@property (nonatomic) NSInteger vertexCount;
@property (nonatomic) NSInteger indexCount;
@property (nonatomic) NSInteger verticesSize;
@property (nonatomic) NSInteger indicesSize;

- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored;
- (instancetype) initWithVerticesData:(NSData *)verticesData indicesData:(NSData *)indicesData;
- (void) prepareToDraw;
- (void) drawIndicesWithMode:(GLenum)mode startIndex:(GLuint)index indicesCount:(size_t)indicesCount;
- (void) makeDynamicAndUpdateWithVertices:(const SceneMeshVertex *)vertices numberOfVertices:(size_t)numberOfVertices;
- (void) tearDown;
- (void) drawEntireMesh;
- (void) destroyGL;
@end
