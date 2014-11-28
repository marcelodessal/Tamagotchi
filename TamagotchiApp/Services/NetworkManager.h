//
//  NetworkManager.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/26/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^Success)(NSURLSessionDataTask *task, id responseObject);
typedef void(^Failure)(NSURLSessionDataTask *task, NSError *error);

@interface NetworkManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

@end
