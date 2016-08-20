//
//  DHTextTraceAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/15/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextTraceAnimationRenderer.h"
#import "DHTextTraceTextMesh.h"
#import "DHTextTraceTraceMesh.h"
#import "OpenGLHelper.h"
#import <CoreText/CoreText.h>

@interface DHTextTraceAnimationRenderer () {
    GLuint durationLoc;
    GLuint traceProgram, traceMvpLoc, traceOffsetLoc;
}
@property (nonatomic, strong) NSMutableArray *traceMeshes;
@end

@implementation DHTextTraceAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"TextTraceTextVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"TextTraceTextFragment.glsl";
}

- (void) setupExtraUniforms
{
    durationLoc = glGetUniformLocation(program, "u_duration");
    
    traceProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"TextTraceTraceVertex.glsl" fragmentShaderSrc:@"TextTraceTraceFragment.glsl"];
    glUseProgram(traceProgram);
    traceMvpLoc = glGetUniformLocation(traceProgram, "u_mvpMatrix");
    traceOffsetLoc = glGetUniformLocation(traceProgram, "u_offset");
}

- (void) setupMeshes
{
    self.mesh = [[DHTextTraceTextMesh alloc] initWithAttributedText:self.attributedString origin:self.origin textContainerView:self.textContainerView containerView:self.containerView];
    [self.mesh generateMeshesData];
    
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
    CFArrayRef glyphRuns = CTLineGetGlyphRuns(line);
    CFIndex glyphRunCount = CFArrayGetCount(glyphRuns);
    
    for (int i = 0; i < glyphRunCount; i++) {
        CTRunRef run = CFArrayGetValueAtIndex(glyphRuns, i);
        CFIndex glyphCount = CTRunGetGlyphCount(run);
        CGGlyph glyphs[glyphCount];
        CGPoint positions[glyphCount];
        
        CTRunGetGlyphs(run, CFRangeMake(0, 0), glyphs);
        CTRunGetPositions(run, CFRangeMake(0, 0), positions);
        CFDictionaryRef runAttributes = CTRunGetAttributes(run);
        CTFontRef font = CFDictionaryGetValue(runAttributes, kCTFontAttributeName);
        CGColorRef color = CFDictionaryGetValue(runAttributes, kCTForegroundColorAttributeName);
        CFIndex glyphIndex = 0;
        for (CFIndex j = 0; j < glyphCount; j++, glyphIndex++) {
            CGSize offset;
            offset.width = positions[glyphIndex].x;
            offset.height = positions[glyphIndex].y;
            DHTextTraceTraceMesh *traceMesh = [[DHTextTraceTraceMesh alloc] initWithGlyph:glyphs[j] font:font color:[UIColor colorWithCGColor:color] offset:offset];
            [traceMesh generateMeshesData];
            [self.traceMeshes addObject:traceMesh];
        }
    }
}

- (void) drawFrame {
//    [super drawFrame];
//    glUniform1f(durationLoc, self.duration);
//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, texture);
//    glUniform1i(samplerLoc, 0);
//    [self.mesh drawEntireMesh];
    glUseProgram(traceProgram);
    glUniformMatrix4fv(traceMvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform2f(traceOffsetLoc, self.origin.x, self.origin.y);
    for (DHTextTraceTraceMesh *traceMesh in self.traceMeshes) {
        [traceMesh drawEntireMesh];
    }
}

- (NSMutableArray *)traceMeshes
{
    if (!_traceMeshes) {
        _traceMeshes = [NSMutableArray array];
    }
    return _traceMeshes;
}

@end
