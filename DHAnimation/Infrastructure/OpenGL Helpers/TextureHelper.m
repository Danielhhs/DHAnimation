//
//  TextureHelper.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 3/3/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "TextureHelper.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@implementation TextureHelper

+ (GLuint) setupTextureWithView:(UIView *)view
{
    return [TextureHelper setupTextureWithView:view inRect:view.bounds];
}

+ (GLuint) setupTextureWithView:(UIView *)view rotate:(BOOL)rotate
{
    return [TextureHelper setupTextureWithView:view inRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) flipHorizontal:NO flipVertical:NO rotate:rotate];
}

+ (GLuint) setupTextureWithView:(UIView *)view flipHorizontal:(BOOL)flipHorizontal
{
    return [TextureHelper setupTextureWithView:view inRect:view.bounds flipHorizontal:flipHorizontal];
}

+ (GLuint) setupTextureWithView:(UIView *)view flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL)flipVertical
{
    return [TextureHelper setupTextureWithView:view inRect:view.bounds flipHorizontal:flipHorizontal flipVertical:flipVertical];
}

+ (GLuint) setupTextureWithView:(UIView *)view inRect:(CGRect)rect
{
    return [TextureHelper setupTextureWithView:view inRect:rect flipHorizontal:NO];
}

+ (GLuint) setupTextureWithView:(UIView *)view inRect:(CGRect)rect flipHorizontal:(BOOL)flipHorizontal
{
    return [TextureHelper setupTextureWithView:view inRect:rect flipHorizontal:flipHorizontal flipVertical:NO];
}

+ (GLuint) setupTextureWithView:(UIView *)view inRect:(CGRect)rect flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL)flipVertical
{
    return [TextureHelper setupTextureWithView:view inRect:rect flipHorizontal:flipHorizontal flipVertical:flipVertical rotate:NO];
}

+ (GLuint) setupTextureWithView:(UIView *)view inRect:(CGRect)rect flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL)flipVertical rotate:(BOOL)rotate
{
    GLuint texture = [TextureHelper generateTexture];
    
    [TextureHelper drawRect:rect inView:view onTexture:texture flipHorizontal:flipHorizontal flipVertical:flipVertical rotate:rotate];
    
    return texture;
}

+ (GLuint) setupTextureWithImage:(UIImage *)image
{
    return [TextureHelper setupTextureWithImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];
}

+ (GLuint) setupTextureWithImage:(UIImage *)image flipHorizontal:(BOOL)flipHorizontal
{
    return [TextureHelper setupTextureWithImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height) flipHorizontal:flipHorizontal];
}


+ (GLuint) setupTextureWithImage:(UIImage *)image flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL)flipVertical
{
    return [TextureHelper setupTextureWithImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height) flipHorizontal:flipHorizontal flipVertical:flipVertical];
}

+ (GLuint) setupTextureWithImage:(UIImage *)image inRect:(CGRect)rect
{
    return [TextureHelper setupTextureWithImage:image inRect:rect flipHorizontal:NO];
}

+ (GLuint) setupTextureWithImage:(UIImage *)image inRect:(CGRect)rect flipHorizontal:(BOOL)flipHorizontal
{
    return [TextureHelper setupTextureWithImage:image inRect:rect flipHorizontal:flipHorizontal flipVertical:NO];
}

+ (GLuint) setupTextureWithImage:(UIImage *)image inRect:(CGRect)rect flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL)flipVertical
{
    
    GLuint texture = [TextureHelper generateTexture];
    [TextureHelper drawRect:rect inImage:image onTexture:texture flipHorizontal:flipHorizontal flipVertical:flipVertical];
    return texture;
}

+ (GLuint) generateTexture
{
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    return texture;
}

+ (void) drawRect:(CGRect)rect inImage:(UIImage *)image onTexture:(GLuint)texture flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL)flipVertical
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat textureWidth = rect.size.width * screenScale;
    CGFloat textureHeight = rect.size.height * screenScale;
    CGImageRef tmpImage = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(rect.origin.x * screenScale, rect.origin.y * screenScale, rect.size.width * screenScale, rect.size.height * screenScale));
    UIImage *imageToDraw = [UIImage imageWithCGImage:tmpImage];
    CGImageRelease(tmpImage);
    [self drawRect:rect onTexture:texture textureWidth:textureWidth textureHeight:textureHeight drawBlock:^(CGContextRef context) {
        if (flipHorizontal) {
            CGContextTranslateCTM(context, textureWidth, 0);
            CGContextScaleCTM(context, -1, 1);
        }
        if (flipVertical) {
            CGContextTranslateCTM(context, 0, textureHeight);
            CGContextScaleCTM(context, 1, -1);
        }
        CGContextDrawImage(context, CGRectMake(0, 0, textureWidth, textureHeight), imageToDraw.CGImage);
    }];
}

+ (void) drawRect:(CGRect)rect inView:(UIView *)view onTexture:(GLuint)texture flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL)flipVertical rotate:(BOOL)rotate
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat textureWidth = rect.size.width * screenScale;
    CGFloat textureHeight = rect.size.height * screenScale;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, screenScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (rotate) {
        CGFloat angle = atan(-view.transform.c / view.transform.a);
        if (angle > -M_PI && angle < 0) {
            CGContextTranslateCTM(context, 0, fabs(view.bounds.size.width * sin(angle)));
        } else {
            CGContextTranslateCTM(context, view.bounds.size.height * sin(angle), 0);
        }
        CGContextRotateCTM(context, angle);
    }
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height) afterScreenUpdates:YES];
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef tmpImage = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(rect.origin.x * screenScale, rect.origin.y * screenScale, rect.size.width * screenScale, rect.size.height * screenScale));
    image = [UIImage imageWithCGImage:tmpImage];
    CGImageRelease(tmpImage);
    UIGraphicsEndImageContext();
    [self drawRect:rect onTexture:texture textureWidth:textureWidth textureHeight:textureHeight drawBlock:^(CGContextRef context) {
        if (flipHorizontal) {
            CGContextTranslateCTM(context, textureWidth, 0);
            CGContextScaleCTM(context, -1, 1);
        }
        if (flipVertical) {
            CGContextTranslateCTM(context, 0, textureHeight);
            CGContextScaleCTM(context, 1, -1);
        }
        CGContextDrawImage(context, CGRectMake(0, 0, textureWidth, textureHeight), image.CGImage);
    }];
}

+ (void) drawRect:(CGRect)rect onTexture:(GLuint)texture textureWidth:(CGFloat)textureWidth textureHeight:(CGFloat)textureHeight drawBlock:(void (^)(CGContextRef context))drawBlock
{
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = (size_t)textureWidth * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, (size_t)textureWidth, (size_t)textureHeight, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextSaveGState(context);
    drawBlock(context);
    CGContextRestoreGState(context);
    
    GLubyte *data = CGBitmapContextGetData(context);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureWidth, textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    CGContextRelease(context);
}

+ (GLuint) setupTextureWithAttributedString:(NSAttributedString *)attrString
{
    GLfloat scale = [UIScreen mainScreen].scale;
    GLuint texture = [TextureHelper generateTexture];
    GLfloat textureWidth = attrString.size.width * scale;
    GLfloat textureHeight = ceil(attrString.size.height) * scale;
    
    [TextureHelper drawRect:CGRectMake(0, 0, textureWidth, textureHeight) onTexture:texture textureWidth:textureWidth textureHeight:textureHeight drawBlock:^(CGContextRef context) {
        CGContextScaleCTM(context, scale, scale);
        CGContextSetTextPosition(context, 0, 0);
        CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
        CTLineDraw(line, context);
    }];
    
    return texture;
}

@end
