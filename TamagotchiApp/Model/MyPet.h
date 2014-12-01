//
//  MyPet.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/1/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "Pet.h"
#import "Food.h"
#import "NetworkManager.h"
#import <CoreLocation/CoreLocation.h>

extern NSString* const GET_EXHAUSTED;
extern NSString* const GET_RECOVERED;
extern NSString* const GET_PROMOTED;

@interface MyPet : Pet

+ (instancetype) sharedInstance;
- (void) setInitialValues;
- (void) eatFood:(Food*)foodItem;
- (void) exercise;
- (BOOL) canExercise;
- (BOOL) isExhausted;
- (void) setLocation:(CLLocation*) location;
- (void) postToServer;

@end
