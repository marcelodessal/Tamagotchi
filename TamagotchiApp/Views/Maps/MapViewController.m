//
//  MapViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/2/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    MKCoordinateRegion region;
    region.center.latitude = self.pet.petLatitude;
    region.center.longitude = self.pet.petLongitude;
    region.span.latitudeDelta = 0.02;
    region.span.longitudeDelta = 0.02;
    [mapView setRegion:region animated:YES];
}

@end
