//
//  KOBattleScene.h
//  Knockout
//
//  Created by Carlos Paelinck on 6/12/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

@import SpriteKit;

#import "KOCharacterNode.h"
#import "KOAttackNode.h"

#define MAX_OPPONENT_NODES 3

@interface KOBattleScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) NSMutableArray *opponentNodes;
@property (nonatomic) KOCharacterNode *playerNode;
@property (nonatomic) KOGameMapRef gameMapRef;
@property (weak, nonatomic) UISegmentedControl *attackSegmentedControl;
@property (weak, nonatomic) UIImageView *playerElementImageView;
@property (weak, nonatomic) UILabel *playerNameLabel;
@property (weak, nonatomic) UIProgressView *playerHealthBar;

-(void)createPlayerCharacter;
-(void)createOpponent;
-(void)createGameMap;
-(void)centerOnNode:(SKNode *)node;
-(void)performAttackFromNode:(KOCharacterNode *)characterNode;
-(void)attackSegmentedControlDidChangeSelection:(id)sender;

@end
