//
//  Contact.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/6/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* company;
@property (strong, nonatomic) NSArray* phones;
@property (strong, nonatomic) NSArray* emails;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
