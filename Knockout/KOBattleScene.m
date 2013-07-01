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
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        _opponentNodes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)createPlayerCharacter {
    SKTexture *playerTexture = [SKTexture textureWithImageNamed:@"PlayerSprite"];
    KOElement *playerElement = [KOElements grass];
    CGSize playerSize = CGSizeMake(32.0, 32.0);
    
    KOCharacterNode *playerNode = [[KOCharacterNode alloc] initWithTexture:playerTexture
                                                         color:playerElement[kElementTintColor]
                                                          size:playerSize];
    
    NSArray *playerAttacks = [KOAttackNode attackIdentifiersForElement:playerElement[kElementName]];
    
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
    
    [self addNode:playerNode toLayer:KOWorldLayerCharacters];
    
    for (size_t idx_x = 0; idx_x < kGameMapSize; idx_x++) {
        for (size_t idx_y = 0; idx_y < kGameMapSize; idx_y++) {
            if (KOGameMapRefForLocation(_gameMapRef, CGPointMake(idx_x, idx_y))->green > 250) {
                playerNode.position = CGPointMake(idx_x * kNodeSize, idx_y * kNodeSize);
            }
        }
    }
    
    _playerNode = playerNode;
}

-(void)update:(NSTimeInterval)currentTime {   
    for (KOCharacterNode *opponentNode in self.opponentNodes)
        if ([self playerNodeWithinRangeOfOpponentNode:opponentNode]) {
            [opponentNode rotateToPosition:_playerNode.position];
            
            if (!opponentNode.isAttacking &&
                opponentNode.currentHitPoints > 0 &&
                _playerNode.currentHitPoints > 0)
                [self performAttack:[KOAttackNode attackNodeForIdentifier:
                                     [self preferredAttackIdentifierFromNode:opponentNode
                                                                      toNode:_playerNode]]
                           fromNode:opponentNode
                         afterDelay:1.25];
        }
    
}

-(void)createOpponents {
    for (size_t idx_x = 0; idx_x < kGameMapSize; idx_x++)
        for (size_t idx_y = 0; idx_y < kGameMapSize; idx_y++)
            if (KOGameMapRefForLocation(_gameMapRef, CGPointMake(idx_x, idx_y))->blue > 250)
                [self createOpponentAtPosition:CGPointMake(idx_x * kNodeSize, idx_y * kNodeSize)];
}

-(void)createOpponentAtPosition:(CGPoint)position {
    SKTexture *opponentTexture = [SKTexture textureWithImageNamed:@"PlayerSprite"];
    KOElement *opponentElement = @[ [KOElements fire], [KOElements grass], [KOElements water],
                                    [KOElements ice], [KOElements electric], [KOElements ground] ][arc4random_uniform(6)];
    CGSize opponentSize = CGSizeMake(32.0, 32.0);
    
    KOCharacterNode *opponentNode = [[KOCharacterNode alloc] initWithTexture:opponentTexture
                                                                       color:opponentElement[kElementTintColor]
                                                                        size:opponentSize];
    
    NSArray *opponentAttacks = [KOAttackNode attackIdentifiersForElement:opponentElement[kElementName]];
    
    [opponentNode setCharacterProperties:@{ kCharacterName: @"Opponent",
                                            kCharacterLevel: @5,
                                            kCharacterElement: opponentElement,
                                            kCharacterAttacks: opponentAttacks }];
        
    opponentNode.position = position;
    
    [opponentNode setPhysicsBodyCategory:KONodeTypeOpponent
                               collision:KONodeTypeBarrier | KONodeTypePlayer | KONodeTypeOpponent
                                 contact:KONodeTypeAttack];
    
    
    
    [opponentNode setScale:0.0];
    [opponentNode setAlpha:0.0];
    [self addNode:opponentNode toLayer:KOWorldLayerCharacters];
        
    [opponentNode runAction:[SKAction group:@[
                                              [SKAction fadeAlphaTo:1.0 duration:1.0],
                                              [SKAction scaleTo:1.0 duration:1.0],
                                              ]]];
    
    [_opponentNodes addObject:opponentNode];
}

-(void)createGameMap {
    _gameMapRef = KOCreateGameMap([UIImage imageNamed:@"game-map"].CGImage);
    
    for (size_t idx_x = 0; idx_x < kGameMapSize; idx_x++) { 
        for (size_t idx_y = 0; idx_y < kGameMapSize; idx_y++) {
            if (KOGameMapRefForLocation(_gameMapRef, CGPointMake(idx_x, idx_y))->red > 250) {
                
                SKSpriteNode *barrierNode = [SKSpriteNode node];
                barrierNode.color = [SKColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
                barrierNode.position = CGPointMake(idx_x * kNodeSize, idx_y *kNodeSize);
                barrierNode.colorBlendFactor = 1.0;
                barrierNode.size = CGSizeMake(kNodeSize, kNodeSize);
                barrierNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(kNodeSize, kNodeSize)];
                barrierNode.physicsBody.categoryBitMask = KONodeTypeBarrier;
                barrierNode.physicsBody.collisionBitMask = 0;
                barrierNode.physicsBody.dynamic = NO;
                
                [self addNode:barrierNode toLayer:KOWorldLayerGround];
            }
        }
    }
}

-(void)addNode:(SKNode *)node toLayer:(KOWorldLayer)worldLayer {
    [_layers[worldLayer] addChild:node];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1 && !self.playerNode.isMoving) {
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
                [self performAttack:[KOAttackNode attackNodeForIdentifier:self.playerNode.attacks[self.attackSegmentedControl.selectedSegmentIndex]]
                           fromNode:self.playerNode
                         afterDelay:0.0];
            else
                [self.playerNode moveToPosition:location];
    
        }];
    }
}

-(BOOL)playerNodeWithinRangeOfOpponentNode:(KOCharacterNode *)opponentNode {
    return KODistanceBetweenPoints(opponentNode.position, self.playerNode.position) < kAttackZoneDistance;
}

-(void)performAttack:(KOAttackNode *)attackNode fromNode:(KOCharacterNode *)characterNode afterDelay:(NSTimeInterval)delay {
    characterNode.isAttacking = YES;
    
    CGFloat angle = KORadiansToPolar(characterNode.zRotation);
    CGFloat distance = 100.0;
    CGPoint endPoint = CGPointMake(characterNode.position.x + distance * cosf(angle),
                                   characterNode.position.y + distance * sinf(angle));
    
    attackNode.position = characterNode.position;
    attackNode.zRotation = characterNode.zRotation;
    
    SKPhysicsBody *targetPhysicsBody = [self.physicsWorld bodyAlongRayStart:characterNode.position end:endPoint];
    
    if (targetPhysicsBody && (targetPhysicsBody.categoryBitMask & KONodeTypeOpponent ||
                              targetPhysicsBody.categoryBitMask & KONodeTypePlayer)) {
        endPoint = targetPhysicsBody.node.position;
        attackNode.physicsBody.contactTestBitMask = targetPhysicsBody.categoryBitMask;
        [attackNode setDamageForNodeA:characterNode toNodeB:(KOCharacterNode *)targetPhysicsBody.node];
    }

    [self addNode:attackNode toLayer:KOWorldLayerCharacters];
    [attackNode runAction:[SKAction sequence:@[[SKAction waitForDuration:delay],
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

-(NSString *)preferredAttackIdentifierFromNode:(KOCharacterNode *)nodeA toNode:(KOCharacterNode *)nodeB {
    __block NSString *preferredAttackIdentifer = nil;
    __block CGFloat maxDamageMultiplier = 0.0;
    
    [nodeA.attacks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat damageMultiplier = 1.0;
        NSString *attackElementName = [KOAttackNode attackDataForIdentifier:obj][kAttackDataElement][kElementName];
        
        if ([attackElementName isEqualToString:nodeA.element[kElementName]])
            damageMultiplier *= 1.5;
        
        damageMultiplier *= [nodeB.element[kElementDamageMultiplier][attackElementName] floatValue];
        
        if (maxDamageMultiplier <= damageMultiplier) {
            preferredAttackIdentifer = obj;
            maxDamageMultiplier = damageMultiplier;
        }
    }];
    
    return preferredAttackIdentifer;
}

-(void)attackSegmentedControlDidChangeSelection:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    segmentedControl.tintColor = [KOAttackNode attackDataForIdentifier:self.playerNode.attacks[segmentedControl.selectedSegmentIndex]][kAttackDataElement][kElementTintColor];
}

-(void)didMoveToView:(SKView *)view {
    _worldNode = [SKNode node];
    _layers = [NSMutableArray arrayWithCapacity:kWorldLayersCount];
    
    for (size_t idx = 0; idx < kWorldLayersCount; idx++) {
        SKNode *layer = [[SKNode alloc] init];
        layer.zPosition = (CGFloat)kWorldLayersCount - idx;
        [_worldNode addChild:layer];
        [_layers addObject:layer];
    }
    
    [self addChild:_worldNode];
    
    [self createGameMap];
    [self createPlayerCharacter];
    [self createOpponents];
    [_attackSegmentedControl addTarget:self
                                action:@selector(attackSegmentedControlDidChangeSelection:)
                      forControlEvents:UIControlEventValueChanged];
}

-(void)centerOnNode:(SKNode *)node {
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:_worldNode];
    _worldNode.position = CGPointMake(_worldNode.position.x - cameraPositionInScene.x,
                                      _worldNode.position.y - cameraPositionInScene.y);
}

-(void)didSimulatePhysics {
    [self centerOnNode:_playerNode];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {   
    KOCharacterNode *targetNode = nil;
    KOAttackNode *attackNode = nil;
    
    if (contact.bodyA.categoryBitMask & KONodeTypeBarrier ||
        contact.bodyB.categoryBitMask & KONodeTypeBarrier)
        return;
        
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        targetNode = (KOCharacterNode *)contact.bodyA.node;
        attackNode = (KOAttackNode *)contact.bodyB.node;
    } else {
        targetNode = (KOCharacterNode *)contact.bodyB.node;
        attackNode = (KOAttackNode *)contact.bodyA.node;
    }
    
    if (targetNode.physicsBody.categoryBitMask & attackNode.physicsBody.contactTestBitMask) {
        [targetNode applyDamage:attackNode.damage];
        
        if (targetNode.physicsBody.categoryBitMask & KONodeTypePlayer) {
            self.playerHealthBar.progress = (_playerNode.currentHitPoints - attackNode.damage) / _playerNode.hitPoints;
        }
    }
}

-(void)dealloc {
    free(_gameMapRef);
}

@end
