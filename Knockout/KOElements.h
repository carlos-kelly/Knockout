//
//  KOElements.h
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

@import Foundation;
@import SpriteKit;

#define kElementName @"kElementName"
#define kElementDamageMultiplier @"kElementDamageMultiplier"
#define kElementTintColor @"kElementTintColor"

typedef NSDictionary KOElement;

@interface KOElements : NSObject

+(KOElement *)fire;
+(KOElement *)water;
+(KOElement *)grass;
+(KOElement *)electric;
+(KOElement *)ice;
+(KOElement *)ground;

@end
