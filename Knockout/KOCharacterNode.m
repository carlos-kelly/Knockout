//
//  KOCharacterNode.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOCharacterNode.h"
#import "KOBattleScene.h"

@implementation KOCharacterNode

-(id)initWithTexture:(SKTexture *)texture color:(SKColor *)color size:(CGSize)size {
    if (self = [super initWithTexture:texture color:color size:size]) {        
        self.color = color;
        self.colorBlendFactor = 1.0;
        self.blendMode = SKBlendModeAlpha;
    }
    
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@, Lv.%ld, %@, [%f/%f] HP",
            self.name, (long)self.level, self.element[kElementName], self.currentHitPoints, self.hitPoints];
}

-(void)setCharacterProperties:(NSDictionary *)properties {
    self.name = properties[kCharacterName];
    self.level = [properties[kCharacterLevel] integerValue];
    self.element = properties[kCharacterElement];
    self.attacks = properties[kCharacterAttacks];
    
    self.hitPoints = KOHitPointsForLevel(kBaseStatDefault, self.level);
    self.currentHitPoints = self.hitPoints;
    
    self.isMoving = NO;
    self.isAttacking = NO;
}

-(void)setPhysicsBodyCategory:(uint8_t)categoryBitMask collision:(uint8_t)collisionBitMask contact:(uint8_t)contactBitMask {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.width / 2];
    self.physicsBody.categoryBitMask = categoryBitMask;
    self.physicsBody.collisionBitMask = collisionBitMask;
    self.physicsBody.contactTestBitMask = contactBitMask;
}

-(void)rotateToPosition:(CGPoint)position {
    self.zRotation = KORadiansToPolar(KORadiansBetweenPoints(position, self.position));
}

-(void)moveToPosition:(CGPoint)position {
    CGPoint newPosition = CGPointMake(position.x + self.position.x, position.y + self.position.y);
    CGFloat distance = KODistanceBetweenPoints(newPosition, self.position);
    CGFloat angle = KORadiansToPolar(KORadiansBetweenPoints(newPosition, self.position));
    CGFloat speed = KOStatForLevel(kBaseStatDefault, self.level);
    NSTimeInterval duration = (distance / speed) * 1;
    
    [self runAction:[SKAction group:@[[SKAction runBlock:^{
                                            self.isMoving = YES;
                                        }],
                                      [SKAction repeatAction:[SKAction sequence:@[
                                                                                  [SKAction scaleTo:1.15
                                                                                           duration:0.1],
                                                                                  [SKAction scaleTo:1.0
                                                                                           duration:0.1]
                                                                                  ]]
                                                       count:(duration / 0.2)],
                                      [SKAction sequence:@[
                                                           [SKAction rotateToAngle:angle
                                                                          duration:0],
                                                           [SKAction moveTo:newPosition
                                                                   duration:duration]
                                                           ]]
                                      ]]
         completion:^{
             self.isMoving = NO;
         }];
}

-(void)applyDamage:(CGFloat)damage {
    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:0.25],
                                         [SKAction repeatAction:[SKAction sequence:
                                                                 @[
                                                                   [SKAction moveByX:5.0
                                                                                   y:0.0
                                                                            duration:0.05],
                                                                   [SKAction moveByX:-10.0
                                                                                   y:0.0
                                                                            duration:0.05],
                                                                   [SKAction moveByX:5.0
                                                                                   y:0.0
                                                                            duration:0.05]
                                                                   ]]
                                                          count:3]
                                         ]]
         completion:^{
             self.currentHitPoints -= damage;
             if (self.currentHitPoints < 1.0) {
                 [self faint];
             }
         }];
}

-(void)faint {
    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:0.5],
                                         [SKAction scaleTo:1.25 duration:0.1],
                                         [SKAction group:@[
                                                           [SKAction fadeAlphaTo:0.0 duration:1.0],
                                                           [SKAction scaleTo:0.0 duration:1.0]
                                                           ]]
                                         ]]
         completion:^{
             if (self.physicsBody.categoryBitMask & KONodeTypeOpponent &&
                 [self.scene respondsToSelector:@selector(setOpponentNodes:)])
                 [[(KOBattleScene *)self.scene opponentNodes] removeObject:self];
             
             [self removeFromParent];
         }];
}

@end
