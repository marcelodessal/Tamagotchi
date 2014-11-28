//
//  NetworkManager.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/26/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworkActivityIndicatorManager.h"


NSString* const testBaseURLString = @"http://echo.jsontest.com";
NSString* const baseURLString = @"http://tamagotchi.herokuapp.com";

@implementation NetworkManager

+ (instancetype)sharedInstance {
    static NetworkManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Network activity indicator manager setup
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        // Session configuration setup
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPAdditionalHeaders = [NetworkManager getAdditionalHeaders];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024 // 10MB. memory cache
                                                          diskCapacity:50 * 1024 * 1024 // 50MB. on disk cache
                                                              diskPath:nil];
        sessionConfiguration.URLCache = cache;
        sessionConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        sessionConfiguration.timeoutIntervalForRequest = 20.0;
        
        // Initialize the session
        NSURL *baseURL = [NSURL URLWithString:baseURLString]; // change to testBaseURLString for testing purposes
        _sharedInstance = [[NetworkManager alloc] initWithBaseURL:baseURL sessionConfiguration:sessionConfiguration];
        
        //Setup a default JSONSerializer for all request/responses.
        _sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer]; });
    
    return _sharedInstance;
}

+ (NSDictionary*)getAdditionalHeaders {
    return @{@"Content-Type": @"application/json"};
}

@end
