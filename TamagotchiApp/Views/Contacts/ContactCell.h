//
//  ContactCell.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/5/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@protocol ContactCellDelegate <NSObject>

- (void)didSelectEmail:(NSString*)emailAddress;
- (void)didSelectPhoneCall:(NSString*)phoneNumber;

@end

@interface ContactCell : UITableViewCell

@property (weak, nonatomic) id <ContactCellDelegate> delegate;

-(void) fillDataWithContact:(Contact*) contact;


@end
