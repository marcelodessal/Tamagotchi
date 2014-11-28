//
//  PushNotificationManager.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/28/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PushNotificationManager : NSObject

+ (void)pushNotification:(NSDictionary*) message;
@end
