//
//  DHTextTraceTraceAttributes.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/15/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextTraceTraceMesh.h"
#import <CoreText/CoreText.h>
#import <OpenGLES/ES3/glext.h>
typedef struct {
    GLKVector3 position;
    GLKVector4 color;
    GLKVector2 offset;
    GLfloat startTime;
    GLfloat disappearTime;
}DHTextTraceTraceAttributes;

typedef struct {
    GLKVector2 position;
    CGPathElementType elementType;
}DHTextTracePositionInfo;

@interface DHTextTraceUserInfo : NSObject
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic) CGSize offset;
@end

@implementation DHTextTraceUserInfo


@end

@interface DHTextTraceTraceMesh () {
}
@property (nonatomic) CGGlyph glyph;
@property (nonatomic) CTFontRef font;
@property (nonatomic, strong) NSMutableData *verticesData;
@property (nonatomic) CGSize offset;
@property (nonatomic) GLKVector4 colorComponents;
@end

@implementation DHTextTraceTraceMesh

- (instancetype) initWithGlyph:(CGGlyph)glyph font:(CTFontRef)font color:(UIColor *)color offset:(CGSize)offset
{
    self = [super init];
    if (self) {
        self.glyph = glyph;
        self.font = font;
        self.offset = offset;
        self.colorComponents = [self colorComponentsFromColor:color];
        self.verticesData = [NSMutableData data];
    }
    return self;
}

-(GLKVector4) colorComponentsFromColor:(UIColor *) color
{
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return GLKVector4Make(red, green, blue, alpha);
}

- (void) generateMeshesData
{
    CGPathRef path = CTFontCreatePathForGlyph(self.font, self.glyph, NULL);
    NSMutableData *positionData = [NSMutableData data];
    DHTextTraceUserInfo *userInfo = [[DHTextTraceUserInfo alloc] init];
    userInfo.data = positionData;
    CGPathApply(path, (void *)userInfo, constructPath);
    NSInteger numberOfPoints = [positionData length] / sizeof(DHTextTracePositionInfo);
    for (int i = 0; i < numberOfPoints; i++) {
        DHTextTracePositionInfo * verts = (DHTextTracePositionInfo *)[positionData bytes];
        DHTextTracePositionInfo vertex = verts[i];
        
        DHTextTraceTraceAttributes attribute;
        attribute.position = GLKVector3Make(vertex.position.x, vertex.position.y, 0);
        attribute.offset = GLKVector2Make(self.offset.width, self.offset.height);
        attribute.color = self.colorComponents;
        attribute.startTime = self.duration / 2 * i / numberOfPoints;
        attribute.disappearTime = self.duration / 2 + self.duration / 2 * i / numberOfPoints;
        [self.verticesData appendBytes:&attribute length:sizeof(DHTextTraceTraceAttributes)];
    }
    self.vertexData = self.verticesData;
    [self prepareToDraw];
}


void constructPath(void *info, const CGPathElement *element) {
    DHTextTraceUserInfo *userInfo = (__bridge DHTextTraceUserInfo *)info;
    NSMutableData *data = userInfo.data;
    GLKVector2 offset = GLKVector2Make(userInfo.offset.width, userInfo.offset.height);
    CGPoint pathStartPoint, currentPoint;
    switch (element->type) {
        case kCGPathElementMoveToPoint: {
            DHTextTracePositionInfo attributes;
            attributes.position.x = element->points->x;
            attributes.position.y = element->points->y;
            attributes.elementType = kCGPathElementMoveToPoint;
            [data appendBytes:&attributes length:sizeof(DHTextTracePositionInfo)];
            pathStartPoint = CGPointMake(element->points->x, element->points->y);
            currentPoint = CGPointMake(element->points->x, element->points->y);
        }
            break;
        case kCGPathElementAddLineToPoint:{
            DHTextTracePositionInfo *points = (DHTextTracePositionInfo *)[data bytes];
            DHTextTracePositionInfo lastPoint = points[[data length] / sizeof(DHTextTracePositionInfo) - 1];
            addLineToPoint(lastPoint.position.x, lastPoint.position.y, element->points->x, element->points->y, data, offset);
            currentPoint = CGPointMake(element->points->x, element->points->y);
        }
            break;
        case kCGPathElementAddCurveToPoint: {
            DHTextTracePositionInfo *points = (DHTextTracePositionInfo *)[data bytes];
            DHTextTracePositionInfo lastPoint = points[[data length] / sizeof(DHTextTracePositionInfo) - 1];
            CGPoint cp1 = element->points[0];
            CGPoint cp2 = element->points[1];
            CGPoint target = element->points[2];
            cubicBezierCurve(lastPoint.position.x, lastPoint.position.y, cp1.x, cp1.y, cp2.x, cp2.y, target.x, target.y, data, offset);
            currentPoint = CGPointMake(element->points[2].x, element->points[2].y);
        }
            break;
        case kCGPathElementAddQuadCurveToPoint: {
            DHTextTracePositionInfo *points = (DHTextTracePositionInfo *)[data bytes];
            DHTextTracePositionInfo lastPoint = points[[data length] / sizeof(DHTextTracePositionInfo) - 1];
            CGPoint cp1 = element->points[0];
            CGPoint target = element->points[1];
            quadraticBezierCurve(lastPoint.position.x, lastPoint.position.y, cp1.x, cp1.y, target.x, target.y, data, offset);
            currentPoint = CGPointMake(element->points[1].x, element->points[1].y);
        }
            break;
        case kCGPathElementCloseSubpath: {
            addLineToPoint(currentPoint.x, currentPoint.y, pathStartPoint.x, pathStartPoint.y, data, offset);
        }
            break;
        default:
            break;
    }
}

void addLineToPoint(CGFloat startX, CGFloat startY, CGFloat targetX, CGFloat targetY, NSMutableData *data, GLKVector2 offset) {
    
    GLKVector2 start = GLKVector2Make(startX, startY);
    GLKVector2 target = GLKVector2Make(targetX, targetY);
    GLKVector2 line = GLKVector2Subtract(target, start);
    GLKVector2 direction = GLKVector2Normalize(line);
    for (int i = 0; i <= GLKVector2Length(line) * 2; i++) {
        DHTextTracePositionInfo attributes;
        attributes.position.x = start.x + direction.x * i / 2.f;
        attributes.position.y = start.y + direction.y * i / 2.f;
        attributes.elementType = kCGPathElementAddLineToPoint;
        [data appendBytes:&attributes length:sizeof(DHTextTracePositionInfo)];
        
        DHTextTracePositionInfo attributes2;
        attributes2.position.x = start.x + direction.x * (i + 1) / 2.f;
        attributes2.position.y = start.y + direction.y * (i + 1) / 2.f;
        attributes2.elementType = kCGPathElementAddLineToPoint;
        [data appendBytes:&attributes2 length:sizeof(DHTextTracePositionInfo)];
    }
}

void cubicBezierCurve(CGFloat originX, CGFloat originY, CGFloat cp1x, CGFloat cp1y, CGFloat cp2x, CGFloat cp2y, CGFloat targetX, CGFloat targetY, NSMutableData *data, GLKVector2 offset)
{
    for (CGFloat t = 0; t <= 1; t += 0.01) {
        DHTextTracePositionInfo attributes;
        attributes.position.x = pow(1 - t, 3) * originX + 3 * t * (1 - t) * (1 - t) * cp1x + 3 * t * t * (1 - t) * cp2x + pow(t, 3) * targetX;
        attributes.position.y = pow(1 - t, 3) * originY + 3 * t * (1 - t) * (1 - t) * cp1y + 3 * t * t * (1 - t) * cp2y + pow(t, 3) * targetY;
        attributes.elementType = kCGPathElementAddCurveToPoint;
        [data appendBytes:&attributes length:sizeof(DHTextTracePositionInfo)];
    }
}

void quadraticBezierCurve(CGFloat originX, CGFloat originY, CGFloat cp1x, CGFloat cp1y, CGFloat targetX, CGFloat targetY, NSMutableData *data, GLKVector2 offset)
{
    for (CGFloat t = 0; t <=1; t += 0.01) {
        DHTextTracePositionInfo attributes;
        attributes.position.x = (1 - t) * (1 - t) * originX + 2 * (1 - t) * t * cp1x + t * t * targetX;
        attributes.position.y = (1 - t) * (1 - t) * originY + 2 * (1 - t) * t * cp1y + t * t * targetY;
        attributes.elementType = kCGPathElementAddQuadCurveToPoint;
        [data appendBytes:&attributes length:sizeof(DHTextTracePositionInfo)];
    }
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0 && [self.vertexData length] > 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.vertexData length], [self.vertexData bytes], GL_STATIC_DRAW);
        glGenVertexArrays(1, &vertexArray);
    }
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHTextTraceTraceAttributes), NULL + offsetof(DHTextTraceTraceAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(DHTextTraceTraceAttributes), NULL + offsetof(DHTextTraceTraceAttributes, color));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(DHTextTraceTraceAttributes), NULL + offsetof(DHTextTraceTraceAttributes, offset));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHTextTraceTraceAttributes), NULL + offsetof(DHTextTraceTraceAttributes, startTime));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHTextTraceTraceAttributes), NULL + offsetof(DHTextTraceTraceAttributes, disappearTime));
    
    glBindVertexArray(0);
}

- (void) drawEntireMesh
{
    glBindVertexArray(vertexArray);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.vertexData length] / sizeof(DHTextTraceTraceAttributes));
}
@end
