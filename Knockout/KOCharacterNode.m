//
//  KOCharacterNode.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOCharacterNode.h"

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
    
    self.hitPoints = hitPointsForLevel(kBaseStatDefault, self.level);
    self.currentHitPoints = self.hitPoints;
    
    self.isMoving = NO;
    self.isAttacking = NO;
}

-(void)setPhysicsBodyCategory:(uint8_t)categoryBitMask collision:(uint8_t)collisionBitMask contact:(uint8_t)contactBitMask {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.width];
    self.physicsBody.categoryBitMask = categoryBitMask;
    self.physicsBody.collisionBitMask = collisionBitMask;
    self.physicsBody.contactTestBitMask = contactBitMask;
}

-(void)moveToPosition:(CGPoint)position {
    CGPoint oldPosition = [self position];
    CGFloat distance = distanceBetweenPoints(position, oldPosition);
    CGFloat angle = radiansToPolar(radiansBetweenPoints(position, oldPosition));
    CGFloat speed = statForLevel(kBaseStatDefault, self.level);
    NSTimeInterval duration = (distance / speed) * 1;
        
    self.isMoving = YES;
    
    SKAction *rotateAction = [SKAction rotateToAngle:angle duration:0.10];
    SKAction *moveAction = [SKAction moveTo:position duration:duration];
    
    [self runAction:[SKAction sequence:@[rotateAction, moveAction]]
         completion:^{
        self.isMoving = NO;
    }];
}

-(void)launchAttackAtNode:(SKNode *)node; {
    KOAttack *attack = [self.attacks firstObject];
    SKEmitterNode *attackNode = [[attack emitter] copy];
    
    self.isAttacking = YES;
    
    [self addChild:attackNode];

    [attackNode runAction:[SKAction sequence:@[[SKAction waitForDuration:1.5],
                                               [SKAction runBlock:^{
                                                    attackNode.particleBirthRate = 0;
                                                }],
                                               [SKAction waitForDuration:attackNode.particleLifetime + attackNode.particleLifetimeRange],
                                               [SKAction removeFromParent]]]
               completion:^{
                   self.isAttacking = NO;
               }];
}

@end
