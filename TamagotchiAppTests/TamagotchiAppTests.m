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
#import "PetRemoteService.h"

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

- (void)test1PostPetToServer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test1PostPetToServer"];
    
    MyPet *pet = [MyPet sharedInstance];
    [PetRemoteService postPetWithDictionary:[pet getServerJSON] success:^(NSURLSessionDataTask *task, id responseObject) {
        [expectation fulfill];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        XCTFail(@"FAIL:Post pet data to server failed in \"%s\" test", __PRETTY_FUNCTION__);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) { if (error) {
        NSLog(@"Timeout Error: %@", error); }
    }];
}

- (void)test2GetPetFromServer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test2GetPetFromServer"];
    
    NSString* code = @"MD8462";
    
    [PetRemoteService getPetWithCode:code success:^(NSURLSessionDataTask *task, id responseObject) {
        Pet *pet = [[Pet alloc] initWithDictionary:responseObject];
        XCTAssertTrue([code isEqualToString:pet.code], @"FAIL: expected return value was %@ but received %@ instead.", code, pet.code);
        if ([code isEqualToString:pet.code])
            [expectation fulfill];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        XCTFail(@"FAIL:Get pet data from server failed in \"%s\" test", __PRETTY_FUNCTION__);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) { if (error) {
        NSLog(@"Timeout Error: %@", error); }
    }];
}

- (void)test2GetPetListFromServer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test2GetPetListFromServer"];
    
    [PetRemoteService getAllPets:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = [[NSArray alloc] initWithArray:responseObject];
        if (array.count > 0)
            [expectation fulfill];
        else
            XCTFail(@"FAIL:Get pet list from server returned no data in \"%s\" test", __PRETTY_FUNCTION__);
            
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        XCTFail(@"FAIL:Get pet list from server failed in \"%s\" test", __PRETTY_FUNCTION__);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) { if (error) {
        NSLog(@"Timeout Error: %@", error); }
    }];
}

@end
