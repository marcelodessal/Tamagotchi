//
//  Pet.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/21/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "Pet.h"

NSString* const GET_EXHAUSTED = @"GET_EXHAUSTED";
NSString* const GET_RECOVERED = @"GET_RECOVERED";
NSString* const GET_PROMOTED = @"GET_PROMOTED";

@interface Pet ()
@property int petEnergy;
@property int petLevel;
@property int petExperience;
@end

@implementation Pet {
    
    NSDictionary *pets;
    NSArray *petsArray;
    
}
/*
Pet gains 15 points of experience per each call to exercise
Pet is promoted to the next level when experience reaches 100 times current level ^ 2
When pet get exhausted or get recovered, notifies this new condition
*/

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void) setInitialValues {
    self.code = @"MD8462";
    self.petEnergy = 100;
    self.petLevel = 1;
    petsArray = @[@"ciervo",  @"gato", @"leon", @"jirafa"];
    pets = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:Ciervo], @"ciervo",
            [NSNumber numberWithInt:Gato], @"gato",
            [NSNumber numberWithInt:Leon], @"leon",
            [NSNumber numberWithInt:Jirafa], @"jirafa",
            nil];
}

- (void) eatFood:(Food*)foodItem {
    if (self.isExhausted)
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_RECOVERED object:nil];
    self.petEnergy += foodItem.foodEnergy;
}

- (void) exercise {
    self.petEnergy -= 10;
    if (self.petEnergy <= 0) {
        self.petEnergy = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_EXHAUSTED object:nil];
    }
    self.petExperience += 15;
    NSLog(@"Experience: %i - Needed to promotion: %i", self.petExperience, 100*self.petLevel*self.petLevel);
    
    if (self.petExperience >= 100*self.petLevel*self.petLevel) {
        self.petLevel++;
        NSLog(@"Level: %i", self.petLevel);
        self.petExperience = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_PROMOTED object:nil];
    }
    
}

- (int) getEnergy {
    return self.petEnergy;
}

- (int) getLevel {
    return self.petLevel;
}

- (BOOL)canExercise {
    return self.petEnergy;
}

- (BOOL) isExhausted {
    return ![self canExercise];
}

- (NSDictionary*) getNotificationJSON {
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.code, @"code",
                          self.petName, @"name",
                          [NSNumber numberWithInt:self.petLevel], @"level",
                          nil];
    return json;
}

- (NSDictionary*) getServerJSON {
    
    NSNumber *petTypeValue;
    
    if ([self.petType isEqualToString:@"ciervo"]){
        petTypeValue = [NSNumber numberWithInt:Ciervo];
    } else if ([self.petType isEqualToString:@"gato"]){
        petTypeValue = [NSNumber numberWithInt:Gato];
    } else if ([self.petType isEqualToString:@"leon"]){
        petTypeValue = [NSNumber numberWithInt:Leon];
    } else if ([self.petType isEqualToString:@"jirafa"]){
        petTypeValue = [NSNumber numberWithInt:Jirafa];
    }
    
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.code, @"code",
                          self.petName, @"name",
                          petTypeValue, @"pet_type",
                          [NSNumber numberWithInt:self.petEnergy], @"energy",
                          [NSNumber numberWithInt:self.petLevel], @"level",
                          [NSNumber numberWithInt:self.petExperience ], @"experience",
                          nil];
    return json;
}

- (void)restoreValuesfromJSON:(NSDictionary *)dict {
    self.petName = [dict objectForKey:@"name"];
    int index = [[dict objectForKey:@"pet_type"] intValue];
    self.petType = petsArray[index];
    self.petEnergy = [[dict objectForKey:@"energy"] intValue];
    self.petLevel = [[dict objectForKey:@"level"] intValue];
    self.petExperience = [[dict objectForKey:@"experience"] intValue];
}

@end
