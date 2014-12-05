//
//  LocationManager.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/1/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "LocationManager.h"
#import "MyPet.h"

@implementation LocationManager

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void)startUpdates {
    
    if (self.locationManager == nil)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer; // Presición
    self.locationManager.distanceFilter = 10; // Distancia mínima de updates
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    MyPet *myPet = [MyPet sharedInstance];
    [myPet setLocation:newLocation];
    [myPet postMeToServer];
    
 }

- (void)stopUpdates {
    [self.locationManager stopUpdatingLocation];
}



@end
