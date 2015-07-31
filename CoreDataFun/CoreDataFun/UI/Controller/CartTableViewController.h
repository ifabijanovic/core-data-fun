//
//  CartTableViewController.h
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 31/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartProvider.h"

@interface CartTableViewController : UITableViewController

@property (nonatomic, retain) CartProvider *cartProvider;

@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
- (IBAction)checkoutTapped:(id)sender;

@end
