//
//  KOAttacks.h
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

@import UIKit;
@import SpriteKit;

#include "KOSharedFunctions.h"


#define kAttackName @"kAttackName"
#define kAttackElement @"kAttackType"
#define kAttackPower @"kAttackPower"

@interface KOAttack : NSObject

@property (nonatomic) SKEmitterNode *emitter;
@property (nonatomic) NSDictionary *properties;

+(KOAttack *)flamethrower;

@end
