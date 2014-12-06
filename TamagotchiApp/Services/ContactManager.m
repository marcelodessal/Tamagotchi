//
//  ContactManager.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/6/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "ContactManager.h"
#import "Contact.h"

@interface ContactManager()

@property (strong, nonatomic) NSMutableArray* contacts;

@end

@implementation ContactManager

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

-(NSMutableArray*) getContactList {
    self.contacts = [[NSMutableArray alloc] init];
    [self requestAccess];
    return self.contacts;
}

-(void) requestAccess {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusDenied) {
        // if you got here, user had previously denied/revoked permission for your
        // app to access the contacts, and all you can do is handle this gracefully,
        // perhaps telling the user that they have to go to settings to grant access
        // to contacts
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (error) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        if (addressBook) CFRelease(addressBook);
        return;
    }
    
    if (status == kABAuthorizationStatusNotDetermined) {
        
        // present the user the UI that requests permission to contacts ...
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (error) {
                NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
            }
            
            if (granted) {
                // if they gave you permission, then just carry on
                
                [self listPeopleInAddressBook:addressBook];
            } else {
                // however, if they didn't give you permission, handle it gracefully, for example...
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                    
                    [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                });
            }
            
            if (addressBook) CFRelease(addressBook);
        });
        
    } else if (status == kABAuthorizationStatusAuthorized) {
        [self listPeopleInAddressBook:addressBook];
        if (addressBook) CFRelease(addressBook);
    }
}

- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook {
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName  = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        NSString *company = (__bridge NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        
        ABMultiValueRef emailProperty = ABRecordCopyValue(person, kABPersonEmailProperty);
        NSArray *emails = (__bridge NSArray*)ABMultiValueCopyArrayOfAllValues(emailProperty);
        
        ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSArray *phones = (__bridge NSArray*)ABMultiValueCopyArrayOfAllValues(phoneNumberProperty);
        
        
        //Load the contact dictionary with the data and add it to the contacts array
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        if(name) dict[@"name"] = name;
        if(company) dict[@"company"] = company;
        if(emails) dict[@"emails"] = emails;
        if(phones) dict[@"phones"] = phones;
        
        [self.contacts addObject:[[Contact alloc] initWithDictionary:dict]];
    }
}
@end
