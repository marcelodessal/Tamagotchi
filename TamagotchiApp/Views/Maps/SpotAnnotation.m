//
//  SpotAnnotation.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/2/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "SpotAnnotation.h"

@implementation SpotAnnotation

-(id) initWithTitle:(NSString *) title AndSubtitle:(NSString*) subtitle AndCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    _title = title;
    _subtitle = subtitle;
    _coordinate = coordinate;
    return self;
}
@end
