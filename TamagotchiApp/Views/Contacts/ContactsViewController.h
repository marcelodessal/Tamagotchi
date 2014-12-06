//
//  ContactsViewController.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/5/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ContactCell.h"

@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ContactCellDelegate, MFMailComposeViewControllerDelegate>

@end
