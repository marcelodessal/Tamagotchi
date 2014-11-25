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
        
        if ([name isEqualToString:@"Tarta"]) {
            self.foodType = tarta;
            self.foodEnergy = 20;
        } else if ([name isEqualToString:@"Torta"]) {
            self.foodType = torta;
            self.foodEnergy = 30;
        } else if ([name isEqualToString:@"Helado"]) {
            self.foodType = helado;
            self.foodEnergy = 30;
        } else if ([name isEqualToString:@"Pollo"]) {
            self.foodType = pollo;
            self.foodEnergy = 60;
        } else if ([name isEqualToString:@"Hamburguesa"]) {
            self.foodType = hamburguesa;
            self.foodEnergy = 50;
         } else if ([name isEqualToString:@"Pescado"]) {
            self.foodType = pescado;
            self.foodEnergy = 50;
        } else if ([name isEqualToString:@"Fruta"]) {
            self.foodType = fruta;
            self.foodEnergy = 60;
        } else if ([name isEqualToString:@"Salchicha"]) {
            self.foodType = salchicha;
            self.foodEnergy = 40;
        } else if ([name isEqualToString:@"Pan"]) {
            self.foodType = pan;
            self.foodEnergy = 50;
        }
    }
    return self;
}

@end
