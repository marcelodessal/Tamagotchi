//
//  PetRemoteService.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/5/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "PetRemoteService.h"


@implementation PetRemoteService

+ (void)getPetWithCode:(NSString*)code success:(Success)success failure:(Failure)failure {
    
    NSString *restoreURLString = [NSString stringWithFormat:@"/pet/%@", code];
    
    [[NetworkManager sharedInstance] GET:restoreURLString parameters:nil
                                 success:success
                                 failure:failure];
}

+ (void)postPetWithDictionary:(NSDictionary*)dict success:(Success)success failure:(Failure)failure {
    
    [[NetworkManager sharedInstance] POST:@"/pet" parameters:dict
                                  success:success
                                  failure:failure];
}

+ (void)getAllPets:(Success)success failure:(Failure)failure {
    
    NSString *rankingURLString = @"/pet/all";
    
    [[NetworkManager sharedInstance] GET:rankingURLString parameters:nil
                                 success:success
                                 failure:failure];
}


@end
