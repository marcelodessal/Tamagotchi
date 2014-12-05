//
//  TamagotchiAppTests.m
//  TamagotchiAppTests
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MyPet.h"
#import "NetworkManager.h"

@interface TamagotchiAppTests : XCTestCase

@end

@implementation TamagotchiAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEnergyDecreaseWithExercise {
    // This is an example of a functional test case.
    MyPet *pet = [MyPet sharedInstance];
    pet.petEnergy = [NSNumber numberWithInt:20];
    [pet exercise];
    
    if ([pet.petEnergy intValue] == 10)
        return;

    XCTFail(@"FAIL:Energy wasn't correctly updated in \"%s\" test", __PRETTY_FUNCTION__);
}

- (void)testExperienceIncrementWithExercise {
    // This is an example of a functional test case.
    MyPet *pet = [MyPet sharedInstance];
    pet.petExperience = [NSNumber numberWithInt:20];
    [pet exercise];
    
    if ([pet.petExperience intValue] == 35)
        return;
    
    XCTFail(@"FAIL:Experience wasn't correctly updated in \"%s\" test", __PRETTY_FUNCTION__);
}

- (void)testLevelPromotion {
    // This is an example of a functional test case.
    MyPet *pet = [MyPet sharedInstance];
    pet.petLevel = [NSNumber numberWithInt:2];
    pet.petExperience = [NSNumber numberWithInt:395];
    [pet exercise];
    
    if ([pet.petLevel intValue] != 3)
        XCTFail(@"FAIL:Level wasn't correctly updated in \"%s\" test", __PRETTY_FUNCTION__);
    
    if ([pet.petExperience intValue] != 10)
        XCTFail(@"FAIL:Experience wasn't correctly updated in \"%s\" test", __PRETTY_FUNCTION__);
    
}

- (void)test1PostToServer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test1PostToServer"];
    
    MyPet *pet = [MyPet sharedInstance];
    [pet postToServerWithSuccessBlock:^(NSURLSessionDataTask *task, id responseObject) {
        [expectation fulfill];}
                      AndFailureBlock:^(NSURLSessionDataTask *task, NSError *error) {
                          XCTFail(@"FAIL:Post data to server failed in \"%s\" test", __PRETTY_FUNCTION__);
                      }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) { if (error) {
        NSLog(@"Timeout Error: %@", error); }
    }];
}


@end
