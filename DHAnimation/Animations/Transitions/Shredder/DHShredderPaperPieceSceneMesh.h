//
//  ShredderPaperPieceSceneMesh.h
//  ShrederAnimation
//
//  Created by Huang Hongsen on 12/15/15.
//  Copyright © 2015 cn.daniel. All rights reserved.
//

#import "DHSceneMesh.h"

typedef struct {
    GLKVector3 position;
    GLKVector3 normal;
    GLKVector2 texCoords;
    GLKVector2 pieceWidthRange;
    GLKVector3 cylinderCenter;
}ShredderPaperPieceSceneVertex;

@interface DHShredderPaperPieceSceneMesh : DHSceneMesh
- (void) updateWithPercentage:(CGFloat)percentage;
- (instancetype) initWithScreenWidth:(size_t)screenWidth screenHeight:(size_t)screenHeight yResolution:(size_t)yResolution totalPieces:(NSInteger)totalPieces index:(NSInteger)index;
- (CGFloat) generateRadiusForScreenHeight:(CGFloat)screenHeight;
- (GLuint) vertexArrayObject;
- (void) destroyGL;
@end
