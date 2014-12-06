//
//  ContactsViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/5/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactManager.h"
#import "MyPet.h"

@interface ContactsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* contacts;
@property (strong, nonatomic) MFMailComposeViewController *mailComposer;
@property (strong, nonatomic) NSString *mailRecipient;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contacts = [[ContactManager sharedInstance] getContactList];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"contactCell"];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *contactCellIdentifier = @"contactCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:contactCellIdentifier];
    
    if (!cell) {
        cell = [[ContactCell alloc] init];
    }
    
    // Populate each cell
    [cell fillDataWithContact:self.contacts[indexPath.row]];
    cell.delegate = self;
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

#pragma mark - ContactCellDelegate
- (void) didSelectEmail:(NSString*)emailAddress {
    self.mailRecipient = emailAddress;
    [self sendMail];
}

- (void) didSelectPhoneCall:(NSString*)phoneNumber {
    phoneNumber = [@"tel://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

#pragma mark - Email message methods

- (void)sendMail {
    NSString* petName = [[MyPet sharedInstance] petName];
    NSString *emailTitle = @"Que app copada";
    NSString *messageBody = [NSString stringWithFormat:@"Buenas! Soy %@, cómo va? Quería comentarte que estuve usando la App TamagotchiApp para comerme todo y está genial. Bajatela YA!!   Saludos", petName];
    
    self.mailComposer = [[MFMailComposeViewController alloc] init];
    self.mailComposer.mailComposeDelegate = self;
    [self.mailComposer setSubject:emailTitle];
    [self.mailComposer setToRecipients:[[NSArray alloc] initWithObjects:self.mailRecipient, nil]];
    [self.mailComposer setMessageBody:messageBody isHTML:NO];
    
    // Present mail view controller on screen
    [self presentViewController:self.mailComposer animated:YES completion:nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    UIAlertView *alert;
    switch (result) {
        case MFMailComposeResultCancelled:
            alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"Has cancelado el mensaje" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultSaved:
            alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"El mensaje ha sido guardado como borrador." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultSent:
            alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"El mensaje fue enviado exitosamente." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"El envio ha fallado." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
