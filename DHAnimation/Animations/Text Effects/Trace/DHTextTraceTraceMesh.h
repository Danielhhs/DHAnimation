//
//  DHTextTraceTraceAttributes.h
//  DHAnimation
//
//  Created by Huang Hongsen on 8/15/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextSceneMesh.h"
#import <CoreText/CoreText.h>

@interface DHTextTraceTraceMesh : DHTextSceneMesh

- (instancetype) initWithGlyph:(CGGlyph)glyph font:(CTFontRef)font color:(UIColor *)color offset:(CGSize)offset;

@property (nonatomic) NSTimeInterval duration;
@end
