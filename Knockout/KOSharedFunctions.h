//
//  KOMathFunctions.h
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

@import UIKit;
@import SpriteKit;

@interface KOSharedFunctions : NSObject

#define kGameMapSize 24
#define kNodeSize 32
#define kAttackZoneDistance 100

typedef enum : uint8_t {
    KONodeTypePlayer = 0x1 << 0,
    KONodeTypeOpponent = 0x1 << 1,
    KONodeTypeBarrier = 0x1 << 2,
    KONodeTypeAttack = 0x1 << 3
    
} KONodeType;

typedef enum : uint8_t {
    KOWorldLayerGround = 0,
    KOWorldLayerCharacters,
    KOWorldLayerTop,
    kWorldLayersCount
} KOWorldLayer;

typedef struct {
    uint8_t red, green, blue, alpha;
} KOGameMap;

typedef KOGameMap *KOGameMapRef;

CGFloat KODistanceBetweenPoints(CGPoint firstPoint, CGPoint secondPoint);
CGFloat KORadiansBetweenPoints(CGPoint firstPoint, CGPoint secondPoint);
CGFloat KORadiansToPolar(CGFloat radians);
CGFloat KOStatForLevel(NSInteger baseStat, NSInteger level);
CGFloat KOHitPointsForLevel(NSInteger baseStat, NSInteger level);
void *KOCreateGameMap(CGImageRef mapImage);
KOGameMapRef KOGameMapRefForLocation(KOGameMapRef gameMapRef, CGPoint location);

@end
