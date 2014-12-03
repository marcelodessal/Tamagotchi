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
        self.petEnergy = [[dict objectForKey:@"energy"] intValue];
        self.petLevel = [[dict objectForKey:@"level"] intValue];
        self.petExperience = [[dict objectForKey:@"experience"] intValue];
        self.petLatitude = [[dict objectForKey:@"position_lat"] floatValue];
        self.petLongitude = [[dict objectForKey:@"position_lon"] floatValue];
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

- (NSString*)getStringType {
    return [self getStringType:self.petType];
}


- (UIImage*) getDefaultImageForType:(int) type {
    NSString *imageName = [NSString stringWithFormat:@"%@_comiendo_1", [self getStringType:type]];
    return [UIImage imageNamed:imageName];
}

- (UIImage*) getDefaultImage {
    return [self getDefaultImageForType:self.petType];
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
    
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.code, @"code",
                          self.petName, @"name",
                          [NSNumber numberWithInt:self.petType], @"pet_type",
                          [NSNumber numberWithInt:self.petEnergy], @"energy",
                          [NSNumber numberWithInt:self.petLevel], @"level",
                          [NSNumber numberWithInt:self.petExperience], @"experience",
                          [NSNumber numberWithFloat:self.petLatitude], @"position_lat",
                          [NSNumber numberWithFloat:self.petLongitude], @"position_lon",
                          nil];
    return json;
}

- (void)restoreValuesfromJSON:(NSDictionary *)dict {
    self.code = [dict objectForKey:@"code"];
    self.petName = [dict objectForKey:@"name"];
    self.petType = [[dict objectForKey:@"pet_type"] intValue];
    self.petEnergy = [[dict objectForKey:@"energy"] intValue];
    self.petLevel = [[dict objectForKey:@"level"] intValue];
    self.petExperience = [[dict objectForKey:@"experience"] intValue];
    self.petLatitude = [[dict objectForKey:@"position_lat"] floatValue];
    self.petLongitude = [[dict objectForKey:@"position_lon"] floatValue];

}

@end
