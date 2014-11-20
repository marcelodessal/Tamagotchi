//
//  Food.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/20/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "Food.h"

@implementation Food

- (instancetype)initWithName:(NSString*) name withImage:(NSString*) image {
    
    self = [super init];
    if (self) {
        self.foodName = name;
        self.foodImage = image;
    }
    return self;
}

@end
