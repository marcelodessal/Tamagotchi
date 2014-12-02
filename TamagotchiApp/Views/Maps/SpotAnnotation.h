//
//  SpotAnnotation.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/2/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SpotAnnotation : NSObject <MKAnnotation>
@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;
@property (readonly, copy, nonatomic) NSString *title;
@property (readonly, copy, nonatomic) NSString *subtitle;

-(id) initWithTitle:(NSString *) title AndSubtitle:(NSString*) subtitle AndCoordinate:(CLLocationCoordinate2D)coordinate;

@end
