//
//  Food.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/20/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {pan, helado, hamburguesa, tarta, fruta, pollo, torta, pescado, salchicha} FoodType;

@interface Food : NSObject
@property (strong, nonatomic) NSString *foodImage;
@property (strong, nonatomic) NSString *foodName;
@property FoodType foodType;
@property int foodEnergy;
- (instancetype)initWithName:(NSString*) name withImage:(NSString*) image;

@end
