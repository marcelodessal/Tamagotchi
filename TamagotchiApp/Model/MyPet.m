//
//  MyPet.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/1/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "MyPet.h"
#import <CoreLocation/CoreLocation.h>

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
            _sharedObject = [[self alloc] init];
            [_sharedObject setInitialValues];
        }
    });
    
    return _sharedObject;
}

- (void) setInitialValues {
    self.code = @"MD8462";
    self.petEnergy = 100;
    self.petLevel = 1;
    self.petType = -1;
}

- (void) setLocation:(CLLocation*) location {
    self.petLatitude = location.coordinate.latitude;
    self.petLongitude = location.coordinate.longitude;
}

- (void) eatFood:(Food*)foodItem {
    if (self.isExhausted)
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_RECOVERED object:nil];
    self.petEnergy += foodItem.foodEnergy;
    if (self.petEnergy > 100)
        self.petEnergy = 100;
    
}

- (void) exercise {
    self.petEnergy -= 10;
    if (self.petEnergy <= 0) {
        self.petEnergy = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_EXHAUSTED object:nil];
    }
    self.petExperience += 15;
    NSLog(@"Experience: %i - Needed to promotion: %i", self.petExperience, 100*self.petLevel*self.petLevel);
    
    if (self.petExperience >= 100*self.petLevel*self.petLevel) {
        self.petLevel++;
        NSLog(@"Level: %i", self.petLevel);
        self.petExperience = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_PROMOTED object:nil];
    }
    
}

- (BOOL)canExercise {
    return self.petEnergy;
}

- (BOOL) isExhausted {
    return ![self canExercise];
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
        [self setPetType:[coder decodeIntForKey:@"pet_type"]];
        [self setPetEnergy:[coder decodeIntForKey:@"energy"]];
        [self setPetLevel:[coder decodeIntForKey:@"level"]];
        [self setPetExperience:[coder decodeIntForKey:@"experience"]];
        [self setPetLatitude:[coder decodeFloatForKey:@"position_lat"]];
        [self setPetLongitude:[coder decodeFloatForKey:@"position_lon"]];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *) coder {
    [coder encodeObject: self.code forKey:@"code"];
    [coder encodeObject:self.petName forKey:@"name"];
    [coder encodeInt:self.petType forKey:@"pet_type"];
    [coder encodeInt:self.petEnergy forKey:@"energy"];
    [coder encodeInt:self.petLevel forKey:@"level"];
    [coder encodeInt:self.petExperience forKey:@"experience"];
    [coder encodeFloat:self.petLatitude forKey:@"position_lat"];
    [coder encodeFloat:self.petLongitude forKey:@"position_lon"];
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


@end
