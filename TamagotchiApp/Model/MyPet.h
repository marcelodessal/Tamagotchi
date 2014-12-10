//
//  MyPet.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/1/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "Food.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

extern NSString* const GET_EXHAUSTED;
extern NSString* const GET_RECOVERED;
extern NSString* const GET_PROMOTED;

extern NSString* const NAME_SELECTED;
extern NSString* const IMAGE_SELECTED;

@interface MyPet : NSObject <NSCoding>

// Copied from Pet.h
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *petName;
@property (strong, nonatomic) UIImage *petImage;
@property (strong, nonatomic) NSNumber *petType;
@property (strong, nonatomic) NSNumber *petEnergy;
@property (strong, nonatomic) NSNumber *petLevel;
@property (strong, nonatomic) NSNumber *petExperience;
@property (strong, nonatomic) NSNumber *petLatitude;
@property (strong, nonatomic) NSNumber *petLongitude;

- (NSDictionary*) getServerJSON;
- (void) restoreValuesfromJSON:(NSDictionary*) values;
- (NSDictionary*) getNotificationJSON;
- (UIImage*) getDefaultImageForType:(int) type;
- (UIImage*) getDefaultImage;
- (NSString*) getStringType:(int) type;
- (NSString*) getStringType;
//

+ (instancetype) sharedInstance;
+ (NSString*) pathForDataFile;
- (void) setInitialValues;
- (void) eatFood:(Food*)foodItem;
- (void) exercise;
- (BOOL) canExercise;
- (BOOL) isExhausted;
- (void) setLocation:(CLLocation*) location;
- (void) postMeToServer;
- (void) saveMeToDisk;
- (CGPoint) getMouthOriginPosition;

@end
