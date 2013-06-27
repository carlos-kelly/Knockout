//
//  KOCharacterNode.h
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//


@import SpriteKit;

#import "KOSharedFunctions.h"
#import "KOElements.h"

#define kCharacterName @"kCharacterName"
#define kCharacterLevel @"kCharacterLevel"
#define kCharacterElement @"kCharacterElement"
#define kCharacterAttacks @"kCharacterAttacks"

#define kBaseStatDefault 95

@interface KOCharacterNode : SKSpriteNode


@property (nonatomic) NSString *name;
@property (nonatomic) KOElement *element;
@property (nonatomic) NSArray *attacks;

@property (nonatomic) NSInteger level;
@property (nonatomic) CGFloat hitPoints;
@property (nonatomic) CGFloat currentHitPoints;

@property (nonatomic) BOOL isMoving;
@property (nonatomic) BOOL isAttacking;

-(void)setCharacterProperties:(NSDictionary *)properties;
-(void)setPhysicsBodyCategory:(uint8_t)categoryBitMask collision:(uint8_t)collisionBitMask contact:(uint8_t)contactBitMask;
-(void)rotateToPosition:(CGPoint)position;
-(void)moveToPosition:(CGPoint)position;
-(void)applyDamage:(CGFloat)damage;
-(void)faint;

@end
