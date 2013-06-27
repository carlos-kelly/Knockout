//
//  KOMathFunctions.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOSharedFunctions.h"

@implementation KOSharedFunctions

CGFloat KODistanceBetweenPoints(CGPoint firstPoint, CGPoint secondPoint) {
    return hypotf(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y);
}

CGFloat KORadiansBetweenPoints(CGPoint firstPoint, CGPoint secondPoint) {
    return atan2f(secondPoint.y - firstPoint.y, secondPoint.x - firstPoint.x);
}

CGFloat KORadiansToPolar(CGFloat radians) {
    return radians + M_PI_2;
}

CGFloat KOStatForLevel(NSInteger baseStat, NSInteger level) {
    return ((((31.0 + (2.0 * (CGFloat)baseStat) + (252.0 / 4.0) + 100.0) * (CGFloat)level) / 100.0) + 5.0);
}

CGFloat KOHitPointsForLevel(NSInteger baseStat, NSInteger level) {
    return ((((31.0 + (2.0 * (CGFloat)baseStat) + (252.0 / 4.0) + 100.0) * (CGFloat)level) / 100.0) + 10.0);
}

void *KOCreateGameMap(CGImageRef mapImage) {
    CGContextRef contextRef = NULL;
    CGColorSpaceRef colorSpaceRef = NULL;
    CGBitmapInfo bitmapInfo = (CGBitmapInfo)kCGImageAlphaPremultipliedLast;
    void *bitmapData = NULL;
    void *gameMapData = NULL;
    
    size_t pixelWidth = CGImageGetWidth(mapImage);
    size_t pixelHeight = CGImageGetHeight(mapImage);
    size_t bitsPerComponent = 8;
    
    int bitmapBytesPerRow = (int)(pixelWidth * 4);
    int bitmapByteCount = (int)(bitmapBytesPerRow * pixelHeight);
    
    CGRect mapSize = CGRectMake(0.0, 0.0, pixelWidth, pixelHeight);

    colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    bitmapData = malloc((size_t)bitmapByteCount);
    
    if (!colorSpaceRef) {
        fprintf(stderr, "Cannot create device color space reference.");
        return NULL;
    }
    
    if (!bitmapData) {
        CGColorSpaceRelease(colorSpaceRef);
        fprintf(stderr, "Cannot allocate memory for bitmap data.");
        return NULL;
    }
    
    contextRef = CGBitmapContextCreate(bitmapData,
                                       pixelWidth,
                                       pixelHeight,
                                       bitsPerComponent,
                                       bitmapBytesPerRow,
                                       colorSpaceRef,
                                       bitmapInfo);
    
    if (!contextRef) {
        fprintf(stderr, "Cannot create bitmap context from image.");
        free(bitmapData);
        return NULL;
    }
    
    CGColorSpaceRelease(colorSpaceRef);
    CGContextDrawImage(contextRef, mapSize, mapImage);

    gameMapData = CGBitmapContextGetData(contextRef);
    
    CGContextRelease(contextRef);
    
    return gameMapData;
}

KOGameMapRef KOGameMapRefForLocation(KOGameMapRef gameMapRef, CGPoint location) {
    return &gameMapRef[(((int)location.y) * kGameMapSize + ((int)location.x))];
}


@end
