//
//  KOElements.h
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kElementName @"kElementName"
#define kDamageMultiplier @"kDamageMultiplier"

typedef NSDictionary KOElement;

@interface KOElements : NSObject

+(KOElement *)fire;
+(KOElement *)water;
+(KOElement *)grass;
+(KOElement *)normal;

@end
