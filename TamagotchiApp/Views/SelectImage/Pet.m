//
//  Pet.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/21/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "Pet.h"

@implementation Pet

- (instancetype)initWithName:(NSString*) name withImage:(UIImage*) image withType:(NSString *) type{
    
    self = [super init];
    if (self) {
        self.petName = name;
        self.petImage = image;
        self.petType = type;
    }
    return self;
}

@end
