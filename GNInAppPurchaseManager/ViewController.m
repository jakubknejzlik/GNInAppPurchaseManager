//
//  ViewController.m
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 18/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "ViewController.h"

#import "GNInAppPurchaseManager.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateLabelSuccessText:@"Already purchased..."];
}

-(void)updateLabelSuccessText:(NSString *)text{
    if ([[GNInAppPurchaseManager sharedInstance] isProductPurchased:self.textField.text]) {
        self.label.text = [NSString stringWithFormat:@"%@ %dx",text,[[GNInAppPurchaseManager sharedInstance] totalProductPurchases:self.textField.text]];
    }else{
        self.label.text = @"Buy purchase";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)purchase:(id)sender {
    [[GNInAppPurchaseManager sharedInstance] buyProductWithIdentifier:self.textField.text quantity:1 success:^(SKProduct *product) {
        [self updateLabelSuccessText:@"Purchased!"];
        [[[UIAlertView alloc] initWithTitle:@"Thanks, You just bought" message:[product.localizedTitle stringByAppendingFormat:@"\n%@",product.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error retrieving info" message:[NSString stringWithFormat:@"Could not retrieve info about %@",self.textField.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}
- (IBAction)showInfo:(id)sender {
    [[GNInAppPurchaseManager sharedInstance] loadProductWithIdentifier:self.textField.text success:^(SKProduct *product) {
        [[[UIAlertView alloc] initWithTitle:@"Info" message:[product.localizedTitle stringByAppendingFormat:@"\n%@",product.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error retrieving info" message:[NSString stringWithFormat:@"Could not retrieve info about %@",self.textField.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}
- (IBAction)restore:(id)sender {
    [[GNInAppPurchaseManager sharedInstance] restoreCompletedTransactionsWithSuccess:^{
        [self updateLabelSuccessText:@"Purchased by restore..."];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error restoring purchases" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

@end
