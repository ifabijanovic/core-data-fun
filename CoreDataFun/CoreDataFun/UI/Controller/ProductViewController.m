//
//  ProductViewController.m
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 30/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import "ProductViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CartTableViewController.h"

@interface ProductViewController ()

@property (nonatomic, assign) int quantity;

@end

@implementation ProductViewController

@synthesize quantity = _quantity;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.quantity = 1;
    
    self.title = self.product.name;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:self.product.pictureUrl]];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %@", self.product.price, self.product.currency];
    self.weightLabel.text = [NSString stringWithFormat:@"%@ grams", self.product.unitWeight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setQuantity:(int)quantity {
    _quantity = quantity;
    self.quantityLabel.text = [NSString stringWithFormat:@"%d", _quantity];
}

- (IBAction)addToCartTapped:(id)sender {
    [self.cartProvider addProduct:self.product quantity:self.quantity];
    self.quantity = 1;
}

- (IBAction)quantityValueChanged:(UIStepper *)sender {
    self.quantity = (int)sender.value;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"cart"]) {
        CartTableViewController *controller = (CartTableViewController *)segue.destinationViewController;
        controller.cartProvider = self.cartProvider;
    }
}

@end
