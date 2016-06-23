//
//  DHTextEffectRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/19/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextEffectRenderer.h"
#import "TextureHelper.h"
#import "OpenGLHelper.h"
#import "DHTimingFunctionHelper.h"
@interface DHTextEffectRenderer()

@end

@implementation DHTextEffectRenderer

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    program = [OpenGLHelper loadProgramWithVertexShaderSrc:[self vertexShaderName] fragmentShaderSrc:[self fragmentShaderName]];
    
    mvpLoc = glGetUniformLocation(program, "u_mvpMatrix");
    percentLoc = glGetUniformLocation(program, "u_percent");
    eventLoc = glGetUniformLocation(program, "u_event");
    samplerLoc = glGetUniformLocation(program, "s_tex");
    timeLoc = glGetUniformLocation(program, "u_time");
    [self setupExtraUniforms];
    
    glClearColor(0, 0, 0, 1);
}

- (void) setupTexture
{
    texture = [TextureHelper setupTextureWithAttributedString:self.attributedString];
}

- (void) prepareAnimationWithSettings:(DHTextAnimationSettings *)settings
{
    self.animationView = settings.animationView;
    self.context = self.animationView.context;
    self.duration = settings.duration;
    self.timingFunction = [DHTimingFunctionHelper functionForTimingFunction:settings.timingFunction];
    self.attributedString = settings.attributedText;
    self.origin = settings.origin;
    self.event = settings.event;
    self.completion = settings.completion;
    self.direction = settings.direction;
    self.containerView = settings.containerView;
    self.textContainerView = settings.textContainerView;
    self.elapsedTime = 0.f;
    self.percent = 0.f;
    self.animationView.delegate = self;
    self.beforeAnimationAction = settings.beforeAnimationAction;
    
    [self setupGL];
    [self setupTexture];
    [self setupMeshes];
    [self setupMvpMatrixWithView:self.animationView];
    
    [self.animationView display];
    if (self.beforeAnimationAction) {
        self.beforeAnimationAction();
    }
}

- (void) startAnimation
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        self.percent = self.timingFunction(self.elapsedTime * 1000, 0, 1, self.duration * 1000);
        [self.mesh updateWithElapsedTime:self.elapsedTime percent:self.percent];
        [self updateWithElapsedTime:self.elapsedTime percent:self.percent];
        [self.animationView display];
    } else {
        self.percent = 1.f;
        [self.mesh updateWithElapsedTime:self.duration percent:self.percent];
        [self.animationView display];
        [self.displayLink invalidate];
        if (self.completion) {
            self.completion();
        }
        [self tearDownGL];
    }
}

- (void) tearDownGL
{
    
}

- (void) setupMvpMatrixWithView:(UIView *)view
{
    GLKMatrix4 modelView = GLKMatrix4MakeTranslation(-view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    GLfloat aspect = view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 projectioin = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(projectioin, modelView);
    
    self.mvpMatrix = mvpMatrix;
}

#pragma mark - For Override
- (NSString *) vertexShaderName
{
    return @"";
}

- (NSString *) fragmentShaderName
{
    return @"";
}

- (void) setupExtraUniforms
{
    
}

- (void) setupMeshes
{
    
}

- (void) prepareDrawingContext
{
    
}

- (void) drawFrame
{
    
}

- (void) tearDownExtraOpenGLResource
{
    
}

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(CGFloat)percent
{
    
}

#pragma mark - GLKViewDelegate
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
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
    
    [self drawFrame];
}
@end
