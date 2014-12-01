//
//  Pet.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/21/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {Ciervo, Gato, Leon, Jirafa} PetType;

@interface Pet : NSObject
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *petName;
@property (strong, nonatomic) UIImage *petImage;
@property (strong, nonatomic) NSString *petStringType;
@property int petType;
@property int petEnergy;
@property int petLevel;
@property int petExperience;
@property float petLatitude;
@property float petLongitude;

- (instancetype)initWithDictionary:(NSDictionary*) dict;
- (NSDictionary*) getServerJSON;
- (void) restoreValuesfromJSON:(NSDictionary*) values;
- (NSDictionary*) getNotificationJSON;
- (UIImage*) getDefaultImageForType:(int) type;
- (NSString*) getStringType:(int) type;

@end
