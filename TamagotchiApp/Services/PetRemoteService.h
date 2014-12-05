//
//  PetRemoteService.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/5/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "Pet.h"

@interface PetRemoteService : NSObject

+ (void)getPetFromServerWithCode:(NSString*)code success:(Success)success failure:(Failure)failure;

@end
