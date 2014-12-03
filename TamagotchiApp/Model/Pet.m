//
//  Pet.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/21/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "Pet.h"
#import "PetDatabaseHelper.h"

@interface Pet()

@property (strong, nonatomic) NSArray *pets;

@end

@implementation Pet

@synthesize code, petName, petImage, petType, petEnergy, petLevel, petExperience, petLatitude, petLongitude, pets;


- (instancetype)initWithDictionary:(NSDictionary*) dict {
    NSManagedObjectContext *context = [[DatabaseHelper sharedInstance] managedObjectContext];
    self = [NSEntityDescription insertNewObjectForEntityForName:@"Pet" inManagedObjectContext:context];
    
    if (self) {
        code = [dict objectForKey:@"code"];
        petName = [dict objectForKey:@"name"];
        petType = [dict objectForKey:@"pet_type"];
        petEnergy = [dict objectForKey:@"energy"];
        petLevel = [dict objectForKey:@"level"];
        petExperience = [dict objectForKey:@"experience"];
        petLatitude = [dict objectForKey:@"position_lat"];
        petLongitude = [dict objectForKey:@"position_lon"];
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
                          code, @"code",
                          petName, @"name",
                          petLevel, @"level",
                          nil];
    return json;
}

- (NSDictionary*) getServerJSON {
    
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          code, @"code",
                          petName, @"name",
                          petType, @"pet_type",
                          petEnergy, @"energy",
                          petLevel, @"level",
                          petExperience, @"experience",
                          petLatitude, @"position_lat",
                          petLongitude, @"position_lon",
                          nil];
    return json;
}

- (void)restoreValuesfromJSON:(NSDictionary *)dict {
    code = [dict objectForKey:@"code"];
    petName = [dict objectForKey:@"name"];
    petType = [dict objectForKey:@"pet_type"];
    petEnergy = [dict objectForKey:@"energy"];
    petLevel = [dict objectForKey:@"level"];
    petExperience = [dict objectForKey:@"experience"];
    petLatitude = [dict objectForKey:@"position_lat"];
    petLongitude = [dict objectForKey:@"position_lon"];

}

@end
