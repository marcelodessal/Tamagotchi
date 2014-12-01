//
//  Pet.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/21/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "Pet.h"

@interface Pet()

@property (strong, nonatomic) NSArray *pets;

@end

@implementation Pet

- (instancetype)initWithDictionary:(NSDictionary*) dict {
    self = [super init];
    if (self) {
        self.code = [dict objectForKey:@"code"];
        self.petName = [dict objectForKey:@"name"];
        self.petType = [[dict objectForKey:@"pet_type"] intValue];
        self.petStringType = [self getStringType:self.petType];
        self.petEnergy = [[dict objectForKey:@"energy"] intValue];
        self.petLevel = [[dict objectForKey:@"level"] intValue];
        self.petExperience = [[dict objectForKey:@"experience"] intValue];
        self.petLatitude = [[dict objectForKey:@"position_lat"] floatValue];
        self.petLongitude = [[dict objectForKey:@"position_lon"] floatValue];
        
        self.petImage = [self getDefaultImageForType:self.petType];
    }
    return self;
}


- (NSString*)getStringType:(int) type {
    
    switch (type) {
        case Ciervo:
            return @"ciervo";
            break;
        case Gato:
            return @"gato";
            break;
        case Leon:
            return @"leon";
            break;
        case Jirafa:
            return @"jirafa";
            break;
        default:
            break;
    }
    return @"";
}

- (UIImage*) getDefaultImageForType:(int) type {
    NSString *imageName = [NSString stringWithFormat:@"%@_comiendo_1", [self getStringType:type]];
    return [UIImage imageNamed:imageName];
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
    
    if ([self.petStringType isEqualToString:@"ciervo"]){
        petTypeValue = [NSNumber numberWithInt:Ciervo];
    } else if ([self.petStringType isEqualToString:@"gato"]){
        petTypeValue = [NSNumber numberWithInt:Gato];
    } else if ([self.petStringType isEqualToString:@"leon"]){
        petTypeValue = [NSNumber numberWithInt:Leon];
    } else if ([self.petStringType isEqualToString:@"jirafa"]){
        petTypeValue = [NSNumber numberWithInt:Jirafa];
    }
    
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.code, @"code",
                          self.petName, @"name",
                          petTypeValue, @"pet_type",
                          [NSNumber numberWithInt:self.petEnergy], @"energy",
                          [NSNumber numberWithInt:self.petLevel], @"level",
                          [NSNumber numberWithInt:self.petExperience], @"experience",
                          [NSNumber numberWithFloat:self.petLatitude], @"position_lat",
                          [NSNumber numberWithFloat:self.petLongitude], @"position_lon",
                          nil];
    return json;
}

- (void)restoreValuesfromJSON:(NSDictionary *)dict {
    self.petName = [dict objectForKey:@"name"];
    self.petType = [[dict objectForKey:@"pet_type"] intValue];
    self.petStringType = [self getStringType:self.petType];
    self.petEnergy = [[dict objectForKey:@"energy"] intValue];
    self.petLevel = [[dict objectForKey:@"level"] intValue];
    self.petExperience = [[dict objectForKey:@"experience"] intValue];
    self.petLatitude = [[dict objectForKey:@"position_lat"] floatValue];
    self.petLongitude = [[dict objectForKey:@"position_lon"] floatValue];

}

@end
