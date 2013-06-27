//
//  KOBattleScene.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/12/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOBattleScene.h"

@implementation KOBattleScene


-(id)initWithSize:(CGSize)aSize {
    if (self = [super initWithSize:aSize]) {
        self.backgroundColor = [SKColor colorWithWhite:0.2 alpha:1.0];
        self.physicsWorld.gravity = CGPointZero;
        self.physicsWorld.contactDelegate = self;
        self.opponentNodes = [[NSMutableArray alloc] init];
        self.anchorPoint = CGPointMake(0.5, 0.5);        
    }
    
    return self;
}

-(void)createPlayerCharacter {
    SKTexture *playerTexture = [SKTexture textureWithImageNamed:@"PlayerSprite"];
    KOElement *playerElement = [KOElements electric];
    CGSize playerSize = CGSizeMake(32.0, 32.0);
    
    KOCharacterNode *playerNode = [[KOCharacterNode alloc] initWithTexture:playerTexture
                                                         color:playerElement[kElementTintColor]
                                                          size:playerSize];
    
    NSArray *playerAttacks = @[
                               KOAttackNodeElectric,
                               KOAttackNodeFire,
                               KOAttackNodeGrass,
                               KOAttackNodeWater
                               ];
    
    self.attackSegmentedControl.tintColor = [KOAttackNode attackDataForIdentifier:playerAttacks[0]][kAttackDataElement][kElementTintColor];
    
    [playerAttacks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.attackSegmentedControl setImage:[UIImage imageNamed:[[KOAttackNode attackDataForIdentifier:obj][kAttackDataElement][kElementName] stringByAppendingString:@"Icon"]]
                            forSegmentAtIndex:idx];
    }];
            
    [playerNode setCharacterProperties:@{ kCharacterName: @"Carlos",
                                          kCharacterLevel: @10,
                                          kCharacterElement: playerElement,
                                          kCharacterAttacks: playerAttacks }];
            
    [playerNode setPhysicsBodyCategory:KONodeTypePlayer
                                  collision:KONodeTypeBarrier | KONodeTypeOpponent
                                    contact:KONodeTypeAttack];
    
    self.playerNameLabel.text = playerNode.name;
    self.playerElementImageView.image = [[UIImage imageNamed:[playerNode.element[kElementName] stringByAppendingString:@"Icon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.playerElementImageView.tintColor = playerNode.element[kElementTintColor];
    self.playerHealthBar.tintColor = playerNode.element[kElementTintColor];
    self.playerHealthBar.progress = playerNode.currentHitPoints / playerNode.hitPoints;
    
    [[self childNodeWithName:@"world"] addChild:playerNode];
    
    for (size_t idx_x = 0; idx_x < kGameMapSize; idx_x++) {
        for (size_t idx_y = 0; idx_y < kGameMapSize; idx_y++) {
            if (KOGameMapRefForLocation(_gameMapRef, CGPointMake(idx_x, idx_y))->playerLocation > 250) {
                playerNode.position = CGPointMake(idx_x * kNodeSize, idx_y * kNodeSize);
            }
        }
    }
    
    self.playerNode = playerNode;
}

-(void)update:(NSTimeInterval)currentTime {
//    if ([self.opponentNodes count] < MAX_OPPONENT_NODES)
//        [self createOpponent];
//    
//    CGPoint playerPosition = self.playerNode.position;
//    
//    for (KOCharacterNode *opponentNode in self.opponentNodes)
//        [opponentNode rotateToPosition:playerPosition];
    
}

-(void)createOpponent {
    SKTexture *opponentTexture = [SKTexture textureWithImageNamed:@"PlayerSprite"];
    KOElement *opponentElement = [KOElements normal];
    CGSize opponentSize = CGSizeMake(32.0, 32.0);
    
    KOCharacterNode *opponentNode = [[KOCharacterNode alloc] initWithTexture:opponentTexture
                                                                       color:opponentElement[kElementTintColor]
                                                                        size:opponentSize];
    
    NSArray *opponentAttacks = @[ KOAttackNodeWater,
                                  KOAttackNodeFire,
                                  KOAttackNodeGrass,
                                  KOAttackNodeElectric ];
    
    [opponentNode setCharacterProperties:@{ kCharacterName: @"Opponent",
                                            kCharacterLevel: @10,
                                            kCharacterElement: opponentElement,
                                            kCharacterAttacks: opponentAttacks }];
        
    opponentNode.position = CGPointMake(((arc4random() % 320) + self.playerNode.position.x - 160),
                                        (64 + self.playerNode.position.y));
    
    [opponentNode setPhysicsBodyCategory:KONodeTypeOpponent
                               collision:KONodeTypeBarrier | KONodeTypePlayer | KONodeTypeOpponent
                                 contact:KONodeTypeAttack];
    
    
    
    [opponentNode setScale:0.0];
    [opponentNode setAlpha:0.0];
    [[self childNodeWithName:@"world"] addChild:opponentNode];
        
    [opponentNode runAction:[SKAction group:@[
                                              [SKAction fadeAlphaTo:1.0 duration:1.0],
                                              [SKAction scaleTo:1.0 duration:1.0],
                                              ]]];
    
    [self.opponentNodes addObject:opponentNode];
}

-(void)createGameMap {
    _gameMapRef = KOCreateGameMap([UIImage imageNamed:@"game-map"].CGImage);
    
    
    for (size_t idx_x = 0; idx_x < kGameMapSize; idx_x++) { 
        for (size_t idx_y = 0; idx_y < kGameMapSize; idx_y++) {
            if (KOGameMapRefForLocation(_gameMapRef, CGPointMake(idx_x, idx_y))->barrier > 250) {
                SKSpriteNode *barrierNode = [SKSpriteNode node];
                barrierNode.color = [SKColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
                barrierNode.position = CGPointMake(idx_x * kNodeSize, idx_y *kNodeSize);
                barrierNode.colorBlendFactor = 1.0;
                barrierNode.size = CGSizeMake(kNodeSize, kNodeSize);
                barrierNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(kNodeSize, kNodeSize)];
                barrierNode.physicsBody.categoryBitMask = KONodeTypeBarrier;
                barrierNode.physicsBody.dynamic = NO;
                
                [[self childNodeWithName:@"world"] addChild:barrierNode];
            }
        }
    }
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1 && !self.playerNode.isMoving && !self.playerNode.isAttacking) {
        [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            UITouch *touch = (UITouch *)obj;
            CGPoint location = [touch locationInNode:self];
            
            __block BOOL shouldPerformAttack = NO;
            __block KOCharacterNode *targetNode = nil;
            
            [[self nodesAtPoint:[touch locationInNode:self]]
             enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 KOCharacterNode *node = (KOCharacterNode *)obj;
                 if (node.physicsBody.categoryBitMask & KONodeTypePlayer) {
                     targetNode = node;
                     shouldPerformAttack = YES;
                     *stop = YES;
                 }
             }];
            
            if (shouldPerformAttack)
                [self performAttackFromNode:targetNode];
            else
                [self.playerNode moveToPosition:location];
    
        }];
    }
}

-(void)performAttackFromNode:(KOCharacterNode *)characterNode {
    KOAttackNode *attackNode = [KOAttackNode attackNodeForIdentifier:characterNode.attacks[self.attackSegmentedControl.selectedSegmentIndex]];
    characterNode.isAttacking = YES;
    
    CGFloat angle = KORadiansToPolar(characterNode.zRotation);
    CGFloat distance = 100.0;
    CGPoint endPoint = CGPointMake(characterNode.position.x + distance * cosf(angle),
                                   characterNode.position.y + distance * sinf(angle));
    
    attackNode.position = characterNode.position;
    attackNode.zRotation = characterNode.zRotation;
    
    SKPhysicsBody *targetPhysicsBody = [self.physicsWorld bodyAlongRayStart:characterNode.position end:endPoint];
    
    if (targetPhysicsBody) {
        endPoint = targetPhysicsBody.node.position;
        attackNode.physicsBody.contactTestBitMask = targetPhysicsBody.categoryBitMask;
        [attackNode setDamageForNodeA:characterNode toNodeB:(KOCharacterNode *)targetPhysicsBody.node];
    }

    [[self childNodeWithName:@"world"] addChild:attackNode];
    [attackNode runAction:[SKAction sequence:@[
                                               [SKAction moveTo:endPoint duration:1.25],
                                               [SKAction runBlock:^{
                                                    attackNode.emitterNode.particleBirthRate = 0;
                                                }],
                                               [SKAction waitForDuration:1.0]
                                               ]]
               completion:^{
                   [attackNode removeFromParent];
                   characterNode.isAttacking = NO;
               }];
}

-(void)attackSegmentedControlDidChangeSelection:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    segmentedControl.tintColor = [KOAttackNode attackDataForIdentifier:self.playerNode.attacks[segmentedControl.selectedSegmentIndex]][kAttackDataElement][kElementTintColor];
}

-(void)didMoveToView:(SKView *)view {
    SKNode *worldNode = [SKNode node];
    worldNode.name = @"world";
    [self addChild:worldNode];
    
    [self createGameMap];
    [self createPlayerCharacter];
//    [self createOpponent];    
    [self.attackSegmentedControl addTarget:self
                                    action:@selector(attackSegmentedControlDidChangeSelection:)
                          forControlEvents:UIControlEventValueChanged];
}

-(void)centerOnNode:(SKNode *)node {
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,
                                       node.parent.position.y - cameraPositionInScene.y);
}

-(void)didSimulatePhysics {
    [self centerOnNode:self.playerNode];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {   
    KOCharacterNode *targetNode;
    KOAttackNode *attackNode;
        
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        targetNode = (KOCharacterNode *)contact.bodyA.node;
        attackNode = (KOAttackNode *)contact.bodyB.node;
    } else {
        targetNode = (KOCharacterNode *)contact.bodyB.node;
        attackNode = (KOAttackNode *)contact.bodyA.node;
    }
    
    if (targetNode.physicsBody.categoryBitMask & attackNode.physicsBody.contactTestBitMask) {
        NSLog(@"targetNode: %@", targetNode);
        NSLog(@"attackNode: %@", attackNode);
        NSLog(@"attackNode.damage: %f", attackNode.damage);
        [targetNode applyDamage:attackNode.damage];
    }
}

@end
