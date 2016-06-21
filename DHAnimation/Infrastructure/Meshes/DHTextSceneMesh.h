//
//  DHTextSceneMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface DHTextSceneMesh : NSObject {
    GLuint vertexBuffer, indexBuffer;
    GLuint vertexArray;
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic) CGPoint origin;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, strong) NSAttributedString *attributedText;
@property (nonatomic, strong) NSData *vertexData;
@property (nonatomic, strong) NSData *indexData;

- (instancetype) initWithAttributedText:(NSAttributedString *)attributedText origin:(CGPoint)origin containerView:(UIView *)containerView;

- (void) printVertices;
- (void) printVerticesTextureCoords;

#pragma mark - For Override
//Override this method to generate mesh data, it is called while initialization;
- (void) generateMeshesData;

//Override this method to set up vertex buffer, index buffer and vertex array(if necessary)
- (void) prepareToDraw;

//Override this method to draw the entire mesh;
//Default implementation does nothing;
- (void) drawEntireMesh;

//Override this method to update vertex data attributes(if necessary)
- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(CGFloat)percent;


@end
