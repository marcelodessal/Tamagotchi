//
//  PetRemoteService.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/5/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "PetRemoteService.h"


@implementation PetRemoteService

+ (void)getPetFromServerWithCode:(NSString*)code success:(Success)success failure:(Failure)failure {
    
    NSString *restoreURLString = [NSString stringWithFormat:@"/pet/%@", code];
    
    [[NetworkManager sharedInstance] GET:restoreURLString parameters:nil
                                 success:success
                                 failure:failure];
}

@end
