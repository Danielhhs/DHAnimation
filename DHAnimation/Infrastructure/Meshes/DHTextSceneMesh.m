//
//  DHTextSceneMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextSceneMesh.h"
#import <CoreText/CoreText.h>
@implementation DHTextSceneMesh

- (instancetype) initWithAttributedText:(NSAttributedString *)attributedText origin:(CGPoint)origin containerView:(UIView *)containerView
{
    return [self initWithAttributedText:attributedText origin:origin textContainerView:nil containerView:containerView];
}

- (instancetype) initWithAttributedText:(NSAttributedString *)attributedText origin:(CGPoint)origin textContainerView:(UIView *)textContainerView containerView:(UIView *)containerView
{
    self = [super init];
    if (self) {
        _text = attributedText.string;
        CGFloat height = (textContainerView == nil) ? attributedText.size.height : textContainerView.frame.size.height;
        _origin = CGPointMake(origin.x, containerView.frame.size.height - origin.y - ceil(height));
        _containerView = containerView;
        _attributedText = attributedText;
        _vertexCount = [attributedText length] * 4;
        _indexCount = [attributedText length] * 6;
        _textContainerView = textContainerView;
        [self generateIndeciesData];
        [self generatePositionAndTexCoordsData];
    }
    return self;
}

- (void) prepareToDraw
{
    
}

- (void) drawEntireMesh
{
    
}

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(CGFloat)percent
{
    
}

- (void) generateMeshesData
{
    
}

- (void) printVertices
{
    for (int i = 0; i < [self.attributedText length]; i++) {
        NSLog(@"Vertex For Character At Index %d", i);
        NSLog(@"\t{%g, %g, %g}", attributes[i * 4 + 0].position.x, attributes[i * 4 + 0].position.y, attributes[i * 4 + 0].position.z);
        NSLog(@"\t{%g, %g, %g}", attributes[i * 4 + 1].position.x, attributes[i * 4 + 1].position.y, attributes[i * 4 + 1].position.z);
        NSLog(@"\t{%g, %g, %g}", attributes[i * 4 + 2].position.x, attributes[i * 4 + 2].position.y, attributes[i * 4 + 2].position.z);
        NSLog(@"\t{%g, %g, %g}", attributes[i * 4 + 3].position.x, attributes[i * 4 + 3].position.y, attributes[i * 4 + 3].position.z);
    }
}

- (void) printVerticesTextureCoords
{
    for (int i = 0; i < [self.attributedText length]; i++) {
        NSLog(@"Texture For Character At Index %d", i);
        NSLog(@"\t{%g, %g}", attributes[i * 4 + 0].texCoords.x, attributes[i * 4 + 0].texCoords.y);
        NSLog(@"\t{%g, %g}", attributes[i * 4 + 1].texCoords.x, attributes[i * 4 + 1].texCoords.y);
        NSLog(@"\t{%g, %g}", attributes[i * 4 + 2].texCoords.x, attributes[i * 4 + 2].texCoords.y);
        NSLog(@"\t{%g, %g}", attributes[i * 4 + 3].texCoords.x, attributes[i * 4 + 3].texCoords.y);
    }
}

- (void) generatePositionAndTexCoordsData
{
    attributes = malloc(self.vertexCount * sizeof(DHTextAttributes));
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGFloat width = self.attributedText.size.width;
    for (int i = 0; i < [self.attributedText length]; i++) {
        CGFloat offset = CTLineGetOffsetForStringIndex(line, i, NULL);
        CGFloat nextCharOffset = 0.f;
        if (i != [self.attributedText length] - 1) {
            nextCharOffset = CTLineGetOffsetForStringIndex(line, i + 1, NULL);
        } else {
            nextCharOffset = self.attributedText.size.width;
        }
        
        attributes[i * 4 + 0].position = GLKVector3Make(self.origin.x + offset, self.origin.y, 0);
        attributes[i * 4 + 0].texCoords = GLKVector2Make(offset / width, 1.f);
        
        attributes[i * 4 + 1].position = GLKVector3Make(self.origin.x + nextCharOffset, self.origin.y, 0);
        attributes[i * 4 + 1].texCoords = GLKVector2Make(nextCharOffset / width, 1.f);
        
        attributes[i * 4 + 2].position = GLKVector3Make(self.origin.x + offset, self.origin.y + ceil(self.attributedText.size.height), 0);
        attributes[i * 4 + 2].texCoords = GLKVector2Make(offset / width, 0.f);
        
        attributes[i * 4 + 3].position = GLKVector3Make(self.origin.x + nextCharOffset, self.origin.y + ceil(self.attributedText.size.height), 0);
        attributes[i * 4 + 3].texCoords = GLKVector2Make(nextCharOffset / width, 0.f);
    }
}

- (void) generateIndeciesData
{
    indicies = malloc(self.indexCount * sizeof(GLubyte));
    for (int i = 0; i < [self.attributedText length]; i++) {
        indicies[i * 6 + 0] = i * 4 + 0;
        indicies[i * 6 + 1] = i * 4 + 1;
        indicies[i * 6 + 2] = i * 4 + 2;
        indicies[i * 6 + 3] = i * 4 + 2;
        indicies[i * 6 + 4] = i * 4 + 1;
        indicies[i * 6 + 5] = i * 4 + 3;
    }
}
@end
