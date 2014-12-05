//
//  AttributesTests.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/5/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MyPet.h"
#import "Food.h"

@interface AttributesTests : XCTestCase

@end

@implementation AttributesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEnergyIncrementWhenEating {
    MyPet *myPet = [MyPet sharedInstance];
    Food *apples = 
    myPet.petEnergy = [NSNumber numberWithInt:20];
    [[myPet eatFood:[Food alloc] init]]
    
    

}

- (void)testExperienceIncrementWhenExercising {
    
}


@end
