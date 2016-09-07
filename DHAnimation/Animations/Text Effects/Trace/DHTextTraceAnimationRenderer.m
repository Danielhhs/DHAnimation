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
    GLuint traceProgram, traceMvpLoc, traceOffsetLoc, traceTimeLoc;
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
    traceTimeLoc = glGetUniformLocation(traceProgram, "u_time");
    self.animationView.drawableMultisample = GLKViewDrawableMultisample4X;
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
        UIColor *color = ((__bridge NSDictionary *)runAttributes)[NSForegroundColorAttributeName];
        CFIndex glyphIndex = 0;
        for (CFIndex j = 0; j < glyphCount; j++, glyphIndex++) {
            CGSize offset;
            offset.width = positions[glyphIndex].x;
            offset.height = positions[glyphIndex].y;
            DHTextTraceTraceMesh *traceMesh = [[DHTextTraceTraceMesh alloc] initWithGlyph:glyphs[j] font:font color:color offset:offset];
            traceMesh.duration = self.duration;
            [traceMesh generateMeshesData];
            [self.traceMeshes addObject:traceMesh];
        }
    }
}

- (void) drawFrame {
    
    [EAGLContext setCurrentContext:self.context];
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    [self prepareDrawingContext];
    
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(percentLoc, self.percent);
    glUniform1f(eventLoc, self.event);
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(durationLoc, self.duration);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
    
    glUseProgram(traceProgram);
    glUniformMatrix4fv(traceMvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    CGFloat height = (self.textContainerView == nil) ? self.attributedString.size.height : self.textContainerView.frame.size.height;
    float y = self.containerView.frame.size.height - self.origin.y - ceil(height);
    glUniform2f(traceOffsetLoc, self.origin.x, y);
    glUniform1f(traceTimeLoc, self.elapsedTime);
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
