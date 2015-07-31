//
//  CartTableViewController.m
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 31/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import "CartTableViewController.h"
#import "CartProductTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CartProduct.h"
#import "Product.h"
#import "Constants.h"

@interface CartTableViewController ()

@property (nonatomic, retain) NSArray *products;

@end

@implementation CartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CartProductTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartCreated:) name:CART_CREATED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChanged:) name:CART_CHANGED_NOTIFICATION object:nil];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.products = [self.cartProvider getProductsInCart];
    [self setTotal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    CartProduct *cartProduct = [self.products objectAtIndex:indexPath.row];
    cell.nameLabel.text = cartProduct.product.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ %@", cartProduct.unitPrice, cartProduct.product.currency];
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:cartProduct.product.pictureUrl]];
    cell.quantityLabel.text = [NSString stringWithFormat:@"%d", [cartProduct.quantity intValue]];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        CartProduct *cartProduct = [self.products objectAtIndex:indexPath.row];
        [self.cartProvider removeProduct:cartProduct];
        self.products = [self.cartProvider getProductsInCart];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)checkoutTapped:(id)sender {
    if (self.products.count > 0) {
        [self.cartProvider checkout];
    }
}

- (void)cartCreated:(NSNotification *)notification {
    self.products = [self.cartProvider getProductsInCart];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self setTotal];
}

- (void)cartChanged:(NSNotification *)notification {
    [self setTotal];
}

- (void)setTotal {
    double total = 0;
    NSString *currency = @"";
    for (CartProduct *cartProduct in self.products) {
        total += [cartProduct.quantity intValue] * [cartProduct.unitPrice doubleValue];
        if (cartProduct.product) {
            currency = cartProduct.product.currency;
        }
    }
    self.totalLabel.text = [NSString stringWithFormat:@"Total: %.2F %@", total, currency];
}

@end
