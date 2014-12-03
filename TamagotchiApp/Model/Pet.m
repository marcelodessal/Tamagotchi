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

@synthesize code;
@synthesize petName;
@synthesize petImage;
@synthesize petType;
@synthesize petEnergy;
@synthesize petLevel;
@synthesize petExperience;
@synthesize petLatitude;
@synthesize petLongitude;
@synthesize pets;


- (instancetype)initWithDictionary:(NSDictionary*) dict {
    self = [super init];
    if (self) {
        self.code = [dict objectForKey:@"code"];
        self.petName = [dict objectForKey:@"name"];
        self.petType = [dict objectForKey:@"pet_type"];
        self.petEnergy = [dict objectForKey:@"energy"];
        self.petLevel = [dict objectForKey:@"level"];
        self.petExperience = [dict objectForKey:@"experience"];
        self.petLatitude = [dict objectForKey:@"position_lat"];
        self.petLongitude = [dict objectForKey:@"position_lon"];
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
    return [self getStringType:[self.petType intValue]];
}


- (UIImage*) getDefaultImageForType:(int) type {
    NSString *imageName = [NSString stringWithFormat:@"%@_comiendo_1", [self getStringType:type]];
    return [UIImage imageNamed:imageName];
}

- (UIImage*) getDefaultImage {
    return [self getDefaultImageForType:[self.petType intValue]];
}


- (NSDictionary*) getNotificationJSON {
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.code, @"code",
                          self.petName, @"name",
                          self.petLevel, @"level",
                          nil];
    return json;
}

- (NSDictionary*) getServerJSON {
    
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.code, @"code",
                          self.petName, @"name",
                          self.petType, @"pet_type",
                          self.petEnergy, @"energy",
                          self.petLevel, @"level",
                          self.petExperience, @"experience",
                          self.petLatitude, @"position_lat",
                          self.petLongitude, @"position_lon",
                          nil];
    return json;
}

- (void)restoreValuesfromJSON:(NSDictionary *)dict {
    self.code = [dict objectForKey:@"code"];
    self.petName = [dict objectForKey:@"name"];
    self.petType = [dict objectForKey:@"pet_type"];
    self.petEnergy = [dict objectForKey:@"energy"];
    self.petLevel = [dict objectForKey:@"level"];
    self.petExperience = [dict objectForKey:@"experience"];
    self.petLatitude = [dict objectForKey:@"position_lat"];
    self.petLongitude = [dict objectForKey:@"position_lon"];

}

@end
