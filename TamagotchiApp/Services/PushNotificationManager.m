//
//  PushNotificationManager.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/28/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "PushNotificationManager.h"

@implementation PushNotificationManager

+ (void)pushNotification:(NSDictionary*) data {
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:@"PeleaDeMascotas"];
    [push setData:data];
    [push sendPushInBackground];
}

@end
