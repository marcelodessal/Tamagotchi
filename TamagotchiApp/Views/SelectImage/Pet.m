//
//  Pet.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/21/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "Pet.h"

@interface Pet ()
@property int petEnergy;
@property int petLevel;

@end

@implementation Pet

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (instancetype)setInitialName:(NSString*) name andImage:(UIImage*) image andType:(NSString *) type{

    self.petName = name;
    self.petImage = image;
    self.petType = type;
    self.petEnergy = 100;
    self.petLevel = 1;
    
    return self;
}

- (void) eat {
    self.petEnergy = 100;
}

- (void) exercise {
    self.petEnergy -= 10;
    if (self.petEnergy <= 0) {
        self.petEnergy = 0;
    }
}

- (int) getEnergy {
    return self.petEnergy;
}

- (BOOL)canExercise {
    return self.petEnergy;
}

@end
