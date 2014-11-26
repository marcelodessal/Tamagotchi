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

@implementation Pet
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

- (NSDictionary*) getJSON {
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.code, @"code",
                          self.petName, @"name",
                          [NSNumber numberWithInt:self.petEnergy], @"energy",
                          [NSNumber numberWithInt:self.petLevel], @"level",
                          [NSNumber numberWithInt:self.petExperience ], @"experience",
                          nil];
    return json;
}

@end
