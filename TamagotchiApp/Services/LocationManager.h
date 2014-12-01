//
//  LocationManager.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/1/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

+ (instancetype) sharedInstance;
- (void)startUpdates;
- (void)stopUpdates;

@end
