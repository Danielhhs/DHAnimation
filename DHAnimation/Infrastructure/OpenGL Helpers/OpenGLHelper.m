 //
 //  ProgramLoader.m
 //  StartAgain
 //
 //  Created by Huang Hongsen on 5/11/15.
 //  Copyright (c) 2015 com.microstrategy. All rights reserved.
 //
 
#import "OpenGLHelper.h"
 
@implementation OpenGLHelper

+ (GLuint) loadProgramWithVertexShaderSrc:(NSString *)vertexShaderSrc fragmentShaderSrc:(NSString *)fragmentShaderSrc
{
    GLuint program = glCreateProgram();
    
    GLuint vertexShader = [OpenGLHelper loadShaderWithType:GL_VERTEX_SHADER sourceFileName:vertexShaderSrc];
    GLuint fragmentShader = [OpenGLHelper loadShaderWithType:GL_FRAGMENT_SHADER sourceFileName:fragmentShaderSrc];
    
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);
    int status = 0;
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status != GL_TRUE) {
        int errorLogLength;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &errorLogLength);
        char *errorLog = malloc(sizeof(char) * errorLogLength);
        glGetProgramInfoLog(program, errorLogLength, NULL, errorLog);
    }
    
    return program;
}

+ (GLuint) loadShaderWithType:(GLenum)type sourceFileName:(NSString *)sourceFileName
{
    GLuint shader = glCreateShader(type);
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *srcPath = [[bundle resourcePath] stringByAppendingPathComponent:sourceFileName];
    
    const char *src = [[NSString stringWithContentsOfFile:srcPath encoding:NSUTF8StringEncoding error:NULL] cStringUsingEncoding:NSUTF8StringEncoding];
    glShaderSource(shader, 1, &src, NULL);
    glCompileShader(shader);
    
    int status = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status != GL_TRUE) {
        int errorlogLength = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &errorlogLength);
        char *errorLog = malloc(errorlogLength * sizeof(char));
        glGetShaderInfoLog(shader, errorlogLength, NULL, errorLog);
        NSLog(@"Fail to compile shader for : %s", errorLog);
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

+ (UIImage *) highResolutionSnapshotForView:(UIView *)view
{
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (GLuint) setupTextureWithView:(UIView *)view
                   textureWidth:(size_t)textureWidth
                  textureHeight:(size_t)textureHeight
                    screenScale:(CGFloat)screenScale
{
    return [OpenGLHelper setupTextureWithView:view textureWidth:textureWidth textureHeight:textureHeight screenScale:screenScale flipVertical:YES];
}

+ (GLuint) setupTextureWithView:(UIView *)view textureWidth:(size_t)textureWidth textureHeight:(size_t)textureHeight screenScale:(CGFloat)screenScale flipVertical:(BOOL)flipVertical
{
    GLuint texture = [OpenGLHelper generateTexture];
    [OpenGLHelper drawView:view onTexture:texture textureWidth:textureWidth textureHeight:textureHeight screenScale:screenScale flipVertical:flipVertical];
    return texture;
}

+ (GLuint) setupTextureWithImage:(UIImage *)image
                    textureWidth:(size_t)textureWidth
                   textureHeight:(size_t)textureHeight
                     screenScale:(CGFloat)screenScale
{
    GLuint texture = [OpenGLHelper generateTexture];
    [OpenGLHelper drawImage:image onTexture:texture textureWidth:textureWidth textureHeight:textureHeight screenScale:screenScale];
    return texture;
}

+ (GLuint) generateTexture
{
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    return texture;
}

+ (void) drawOnTexture:(GLuint)texture
                 width:(CGFloat)width
                height:(CGFloat)height
          textureWidth:(CGFloat)textureWidth
         textureHeight:(CGFloat)textureHeight
             drawBlock:(void (^)(CGContextRef))drawBlock
{
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = textureWidth * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, textureWidth, textureHeight, bitsPerComponent, bytesPerRow, colorSpace, 1);
    CGColorSpaceRelease(colorSpace);
    CGRect area = CGRectMake(0, 0, width, height);
    CGContextClearRect(context, area);
    CGContextSaveGState(context);
    drawBlock(context);
    CGContextRestoreGState(context);
    
    GLubyte *textureData = (GLubyte *)CGBitmapContextGetData(context);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureWidth, textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
    CGContextRelease(context);
}

+ (void) drawView:(UIView *)view onTexture:(GLuint)texture textureWidth:(size_t)textureWidth textureHeight:(size_t)textureHeight screenScale:(CGFloat)screenScale flipVertical:(BOOL) flipVertical
{
    [self drawView:view onTexture:texture textureWidth:textureWidth textureHeight:textureHeight screenScale:screenScale flipHorizontal:NO flipVertical:flipVertical];
}

+ (void) drawView:(UIView *)view onTexture:(GLuint)texture textureWidth:(CGFloat)textureWidth textureHeight:(CGFloat)textureHeight screenScale:(CGFloat)screenScale flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL) flipVertical
{
    [self drawOnTexture:texture width:view.bounds.size.width height:view.bounds.size.height textureWidth:textureWidth textureHeight:textureHeight drawBlock:^(CGContextRef context) {
        if (flipHorizontal) {
            CGFloat verticalTranslation = 0;
            CGFloat verticalScale = screenScale;
            if (flipVertical) {
                verticalTranslation = view.bounds.size.height * screenScale;
                verticalScale = -screenScale;
            }
            CGContextTranslateCTM(context, view.bounds.size.width * screenScale, verticalTranslation);
            CGContextScaleCTM(context, -screenScale, verticalScale);
        } else {
            if (flipVertical) {
                CGContextTranslateCTM(context, 0, view.bounds.size.height * screenScale);
                CGContextScaleCTM(context, screenScale, -screenScale);
            } else {
                CGContextScaleCTM(context, screenScale, screenScale);
            }
        }
        CGFloat horizontalScale = sqrtl(view.transform.a * view.transform.a + view.transform.b * view.transform.b);
        CGFloat verticalScale = sqrtl(view.transform.c * view.transform.c + view.transform.d * view.transform.d);
        CGContextScaleCTM(context, horizontalScale, verticalScale);
        [view.layer renderInContext:context];
    }];
}

+ (void) drawImage:(UIImage *)image onTexture:(GLuint) texture textureWidth:(size_t)textureWidth textureHeight:(size_t)textureHeight screenScale:(CGFloat)screenScale
{
    [self drawImage:image onTexture:texture textureWidth:textureWidth textureHeight:textureHeight screenScale:screenScale flipHorizontal:NO];
}

+ (void) drawImage:(UIImage *)image onTexture:(GLuint)texture textureWidth:(size_t)textureWidth textureHeight:(size_t)textureHeight screenScale:(CGFloat)screenScale flipHorizontal:(BOOL)flipHorizontal
{
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    [self drawOnTexture:texture width:width height:height textureWidth:textureWidth textureHeight:textureHeight drawBlock:^(CGContextRef context) {
        if (flipHorizontal) {
            CGContextTranslateCTM(context, width, height);
            CGContextScaleCTM(context, -1, -1);
        } else {
            CGContextTranslateCTM(context, 0, height);
            CGContextScaleCTM(context, 1, -1);
        }
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    }];
}
@end

