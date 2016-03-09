//
//  TextureHelper.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 3/3/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "TextureHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextureHelper

+ (GLuint) setupTextureWithView:(UIView *)view
{
    return [TextureHelper setupTextureWithView:view inRect:view.bounds];
}

+ (GLuint) setupTextureWithView:(UIView *)view inRect:(CGRect)rect
{
    GLuint texture = [TextureHelper generateTexture];
    
    [TextureHelper drawRect:rect inView:view onTexture:texture];
    
    return texture;
}

+ (GLuint) setupTextureWithImage:(UIImage *)image
{
    return [TextureHelper setupTextureWithImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height)];
}

+ (GLuint) setupTextureWithImage:(UIImage *)image inRect:(CGRect)rect
{
    GLuint texture = [TextureHelper generateTexture];
    [TextureHelper drawRect:rect inImage:image onTexture:texture];
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

+ (void) drawRect:(CGRect)rect inImage:(UIImage *)image onTexture:(GLuint)texture
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat textureWidth = rect.size.width * screenScale;
    CGFloat textureHeight = rect.size.height * screenScale;
    UIImage *imageToDraw = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(rect.origin.x * screenScale, rect.origin.y * screenScale, rect.size.width * screenScale, rect.size.height * screenScale))];
    [self drawRect:rect onTexture:texture textureWidth:textureWidth textureHeight:textureHeight drawBlock:^(CGContextRef context) {
        CGContextDrawImage(context, CGRectMake(0, 0, textureWidth, textureHeight), imageToDraw.CGImage);
    }];
}

+ (void) drawRect:(CGRect)rect inView:(UIView *)view onTexture:(GLuint)texture
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat textureWidth = rect.size.width * screenScale;
    CGFloat textureHeight = rect.size.height * screenScale;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, screenScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(rect.origin.x * screenScale, rect.origin.y * screenScale, rect.size.width * screenScale, rect.size.height * screenScale))];
    [self drawRect:rect onTexture:texture textureWidth:textureWidth textureHeight:textureHeight drawBlock:^(CGContextRef context) {
        CGContextDrawImage(context, CGRectMake(0, 0, textureWidth, textureHeight), image.CGImage);
    }];
}

+ (void) drawRect:(CGRect)rect onTexture:(GLuint)texture textureWidth:(CGFloat)textureWidth textureHeight:(CGFloat)textureHeight drawBlock:(void (^)(CGContextRef context))drawBlock
{
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = textureWidth * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, textureWidth, textureHeight, bitsPerComponent, bytesPerRow, colorSpace, 1);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, rect);
    CGContextSaveGState(context);
    drawBlock(context);
    CGContextRestoreGState(context);
    
    GLubyte *data = CGBitmapContextGetData(context);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureWidth, textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    CGContextRelease(context);
}

@end
