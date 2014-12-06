//
//  Contact.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/6/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (instancetype)initWithDictionary:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        self.name = [dict objectForKey:@"name"];
        self.company = [dict objectForKey:@"company"];
        self.phones = [dict objectForKey:@"phones"];
        self.emails = [dict objectForKey:@"emails"];
    }
    return self;
}

@end
