//
//  MapViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/2/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "MapViewController.h"
#import "SpotAnnotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *title = self.pet.petName;
    NSString *subtitle = [NSString stringWithFormat:@"Nivel: %i", [self.pet.petLevel intValue]];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.pet.petLatitude floatValue], [self.pet.petLongitude floatValue]);
    
    SpotAnnotation *spot = [[SpotAnnotation alloc] initWithTitle:title AndSubtitle:subtitle AndCoordinate:coordinate];
    
    [self.mapView addAnnotation:spot];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    MKCoordinateRegion region;
    region.center.latitude = [self.pet.petLatitude floatValue];
    region.center.longitude = [self.pet.petLongitude floatValue];
    region.span.latitudeDelta = 0.02;
    region.span.longitudeDelta = 0.02;
    [mapView setRegion:region animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (![annotation isKindOfClass:[SpotAnnotation class]]) return nil;
    static NSString *dqref = @"SpotAnnotation";
    MKAnnotationView* av = [mapView dequeueReusableAnnotationViewWithIdentifier:dqref];
    if (nil == av) {
        av = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:dqref];
    }
    av.image = [self.pet getDefaultImage];
    [av setBounds:CGRectMake(0, 0, 40, 40)];
    [av setCanShowCallout:YES];

    return av;
}

@end
