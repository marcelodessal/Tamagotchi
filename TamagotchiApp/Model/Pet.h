//
//  Pet.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/21/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef enum {Ciervo, Gato, Leon, Jirafa} PetType;

@interface Pet : NSManagedObject
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *petName;
@property (strong, nonatomic) UIImage *petImage;
@property (strong, nonatomic) NSNumber *petType;
@property (strong, nonatomic) NSNumber *petEnergy;
@property (strong, nonatomic) NSNumber *petLevel;
@property (strong, nonatomic) NSNumber *petExperience;
@property (strong, nonatomic) NSNumber *petLatitude;
@property (strong, nonatomic) NSNumber *petLongitude;

- (instancetype)initWithDictionary:(NSDictionary*) dict;
- (NSDictionary*) getServerJSON;
- (void) restoreValuesfromJSON:(NSDictionary*) values;
- (NSDictionary*) getNotificationJSON;
- (UIImage*) getDefaultImageForType:(int) type;
- (UIImage*) getDefaultImage;
- (NSString*) getStringType:(int) type;
- (NSString*) getStringType;

@end
