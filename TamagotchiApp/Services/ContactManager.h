//
//  ContactManager.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/6/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactManager : NSObject

+ (instancetype) sharedInstance;
- (NSMutableArray*) getContactList;

@end
