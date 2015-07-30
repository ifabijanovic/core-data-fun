//
//  ProductTableViewController.m
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 30/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import "ProductTableViewController.h"
#import "ProductTableViewCell.h"
#import "Product.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"
#import "ProductViewController.h"

@interface ProductTableViewController ()

@property (nonatomic, retain) NSArray *products;

@end

@implementation ProductTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsChanged:) name:PRODUCTS_CHANGED_NOTIFICATION object:nil];
    
    [self performFetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.products ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products ? self.products.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Product *product = [self.products objectAtIndex:indexPath.row];
    cell.nameLabel.text = product.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ %@", product.price, product.currency];
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:product.pictureUrl]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Product *product = [self.products objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detail" sender:product];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        ProductViewController *controller = (ProductViewController *)segue.destinationViewController;
        controller.product = sender;
        controller.cartProvider = self.cartProvider;
    }
}

#pragma mark - Fetch

- (void)performFetch {
    [self.activityIndicatorView startAnimating];
    
    __weak ProductTableViewController *weakSelf = self;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastModified" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:^(NSAsynchronousFetchResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf processFetch:result];
        });
    }];
    
    [self.managedObjectContext performBlock:^{
        [weakSelf.managedObjectContext executeRequest:asynchronousFetchRequest error:nil];
    }];
}

- (void)processFetch:(NSAsynchronousFetchResult *)result {
    if (result.finalResult) {
        self.products = result.finalResult;
        [self.tableView reloadData];
        
        if (result.finalResult.count > 0) {
            [self.activityIndicatorView stopAnimating];
        }
    }
}

- (void)productsChanged:(NSNotification *)notification {
    [self performFetch];
}

@end
