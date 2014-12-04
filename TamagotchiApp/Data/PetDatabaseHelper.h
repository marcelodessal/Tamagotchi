//
//  PetDatabaseHelper.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/3/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "DatabaseHelper.h"

@interface PetDatabaseHelper : NSObject

+ (void) insertPet:(Pet*) pet;
+ (void) deleteAllPets;
+ (NSArray*) getPetRanking;

@end
