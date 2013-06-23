//
//  KOAttackNode.h
//  Knockout
//
//  Created by Carlos Paelinck on 6/22/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

@import SpriteKit;

#import "KOSharedFunctions.h"

@interface KOAttackNode : SKSpriteNode

@property (nonatomic) NSInteger power;
@property (nonatomic) SKEmitterNode *emitterNode;
@property (nonatomic) NSString *name;

+(instancetype)fireAttackNode;

@end
