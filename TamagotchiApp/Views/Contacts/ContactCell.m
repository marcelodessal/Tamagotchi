//
//  ContactCell.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/5/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "ContactCell.h"

@interface ContactCell()

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnPhoneCall;

@end

@implementation ContactCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) fillDataWithContact:(Contact*) contact {
    self.lblName.text = contact.name;
    self.lblCompany.text = contact.company;
    
    if (contact.emails.count){
        self.lblEmail.text = contact.emails[0];
        [self.btnEmail setAlpha:1];
        [self.btnEmail setEnabled:YES];
    } else {
        self.lblEmail.text = @"";
        [self.btnEmail setAlpha:0];
        [self.btnEmail setEnabled:NO];
    }

    if (contact.phones.count){
        self.lblPhone.text = contact.phones[0];
        [self.btnPhoneCall setHidden:YES];
        [self.btnPhoneCall setEnabled:YES];
    } else {
        self.lblPhone.text = @"";
        [self.btnPhoneCall setHidden:YES];
        [self.btnPhoneCall setEnabled:NO];
    }

}

- (IBAction)sendEmail:(id)sender {
    [self.delegate didSelectEmail:self.lblEmail.text];
}

- (IBAction)Call:(id)sender {
    NSLog(@"Phone call selected");
    [self.delegate didSelectPhoneCall:self.lblPhone.text];
}

@end
