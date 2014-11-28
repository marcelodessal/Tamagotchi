//
//  Pet.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/21/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <NotificationCenter/NotificationCenter.h>
#import "Food.h"

typedef enum {Ciervo, Gato, Leon, Jirafa} PetType;

extern NSString* const GET_EXHAUSTED;
extern NSString* const GET_RECOVERED;
extern NSString* const GET_PROMOTED;

@interface Pet : NSObject
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *petName;
@property (strong, nonatomic) UIImage *petImage;
@property (strong, nonatomic) NSString *petType;

+ (instancetype) sharedInstance;
-(void) setInitialValues;
- (int) getEnergy;
- (int) getLevel;
- (void) eatFood:(Food*)foodItem;
- (void) exercise;
- (BOOL) canExercise;
- (BOOL) isExhausted;
- (NSDictionary*) getServerJSON;
- (void) restoreValuesfromJSON:(NSDictionary*) values;
- (NSDictionary*) getNotificationJSON;

@end
