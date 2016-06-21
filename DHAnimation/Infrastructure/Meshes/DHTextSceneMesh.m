//
//  DHTextSceneMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextSceneMesh.h"

@implementation DHTextSceneMesh

- (instancetype) initWithAttributedText:(NSAttributedString *)attributedText origin:(CGPoint)origin containerView:(UIView *)containerView
{
    self = [super init];
    if (self) {
        _text = attributedText.string;
        _origin = CGPointMake(origin.x, containerView.frame.size.height - origin.y - attributedText.size.height);
        _containerView = containerView;
        _attributedText = attributedText;
        [self generateMeshesData];
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
    
}

- (void) printVerticesTextureCoords
{
    
}
@end
