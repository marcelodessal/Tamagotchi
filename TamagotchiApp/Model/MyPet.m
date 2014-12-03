//
//  MyPet.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/1/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "MyPet.h"
#import <CoreLocation/CoreLocation.h>
#import "PetDatabaseHelper.h"

NSString* const GET_EXHAUSTED = @"GET_EXHAUSTED";
NSString* const GET_RECOVERED = @"GET_RECOVERED";
NSString* const GET_PROMOTED = @"GET_PROMOTED";

NSString* const NAME_SELECTED = @"NAME_SELECTED";
NSString* const IMAGE_SELECTED = @"IMAGE_SELECTED";

@implementation MyPet

/*
 Pet gains 15 points of experience per each call to exercise
 Pet is promoted to the next level when experience reaches 100 times current level ^ 2
 When pet get exhausted or get recovered, notifies this new condition
 */

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        NSString *path = [MyPet pathForDataFile];
        _sharedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_sharedObject) {
            _sharedObject = [[super alloc] init];
            [_sharedObject setInitialValues];
        }
    });
    
    return _sharedObject;
}

- (void) setInitialValues {
    self.code = @"MD8462";
    self.petEnergy = [NSNumber numberWithInt:100];
    self.petLevel = [NSNumber numberWithInt:1];
    self.petType = [NSNumber numberWithInt:-1];

}

- (void) setLocation:(CLLocation*) location {
    self.petLatitude = [NSNumber numberWithFloat:location.coordinate.latitude];
    self.petLongitude = [NSNumber numberWithFloat:location.coordinate.longitude];
}

- (void) eatFood:(Food*)foodItem {
    if (self.isExhausted)
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_RECOVERED object:nil];
    self.petEnergy = [NSNumber numberWithInt:[self.petEnergy intValue] + foodItem.foodEnergy];
    
    if ([self.petEnergy intValue] > 100)
        self.petEnergy = [NSNumber numberWithInt:100];
}

- (void) exercise {
    self.petEnergy = [NSNumber numberWithInt:[self.petEnergy intValue] - 10];
    
    if ([self.petEnergy intValue] <= 0) {
        self.petEnergy = [NSNumber numberWithInt:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_EXHAUSTED object:nil];
    }
    
    self.petExperience = [NSNumber numberWithInt:[self.petExperience intValue] + 15];
    int experienceForPromotion = 100 * [self.petLevel intValue] * [self.petLevel intValue];
    NSLog(@"Experience: %i - Needed to promotion: %i", [self.petExperience intValue], experienceForPromotion);
    
    if ([self.petExperience intValue] >= experienceForPromotion) {
        self.petLevel = [NSNumber numberWithInt:[self.petLevel intValue] + 1];
        NSLog(@"Level: %i", [self.petLevel intValue]);
        self.petExperience = [NSNumber numberWithInt:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_PROMOTED object:nil];
    }
    
}

- (BOOL)canExercise {
    return self.petEnergy;
}

- (BOOL) isExhausted {
    BOOL result = ![self canExercise];
    return result;
}

- (void)postToServer {
    NSDictionary *parameters = [self getServerJSON];

    [[NetworkManager sharedInstance] POST:@"/pet" parameters:parameters
                                 success:[self getSuccessHandler]
                                 failure:[self getErrorHandler]];
}

- (Success) getSuccessHandler {

    return ^(NSURLSessionDataTask *task, id responseObject) {
        // Do something
    };
}

- (Failure) getErrorHandler {

    return ^(NSURLSessionDataTask *task, NSError *error) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", error];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    };
}

#pragma mark - NSCoding protocol implementation

- (instancetype)initWithCoder:(NSCoder *) coder {
    self = [super init];
    if (self) {
        [self setCode:[coder decodeObjectForKey:@"code"]];
        [self setPetName:[coder decodeObjectForKey:@"name"]];
        [self setPetType:[coder decodeObjectForKey:@"pet_type"]];
        [self setPetEnergy:[coder decodeObjectForKey:@"energy"]];
        [self setPetLevel:[coder decodeObjectForKey:@"level"]];
        [self setPetExperience:[coder decodeObjectForKey:@"experience"]];
        [self setPetLatitude:[coder decodeObjectForKey:@"position_lat"]];
        [self setPetLongitude:[coder decodeObjectForKey:@"position_lon"]];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *) coder {
    [coder encodeObject: self.code forKey:@"code"];
    [coder encodeObject:self.petName forKey:@"name"];
    [coder encodeObject:self.petType forKey:@"pet_type"];
    [coder encodeObject:self.petEnergy forKey:@"energy"];
    [coder encodeObject:self.petLevel forKey:@"level"];
    [coder encodeObject:self.petExperience forKey:@"experience"];
    [coder encodeObject:self.petLatitude forKey:@"position_lat"];
    [coder encodeObject:self.petLongitude forKey:@"position_lon"];
}


+ (NSString *) pathForDataFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folder = @"~/Library/Application Support/TamagotchiApp/";
    folder = [folder stringByExpandingTildeInPath];
    
    if ([fileManager fileExistsAtPath: folder] == NO) {
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = @"TamagotchiApp.data";
    return [folder stringByAppendingPathComponent: fileName];
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
