//
//  ProductViewController.h
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 30/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;

@property (nonatomic, retain) Product *product;

- (IBAction)quantityValueChanged:(UIStepper *)sender;
- (IBAction)addToCartTapped:(id)sender;

@end
