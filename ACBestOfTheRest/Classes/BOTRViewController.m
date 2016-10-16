//
//  BOTRViewController.m
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 15/10/2016.
//  Copyright © 2016 AppCraft. All rights reserved.
//

#import "BOTRViewController.h"

@interface BOTRViewController ()

@property (strong, nonatomic) IBOutletCollection(BOTRTableView) NSArray *tableViews;

@property (strong, nonatomic) IBOutletCollection(BOTRCollectionView) NSArray *collectionViews;

@end

@implementation BOTRViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (BOTRTableView *tableView in self.tableViews) {
        
        tableView.dataArray = [NSMutableArray new];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
        [tableView loadData];
    }
}

#pragma mark - Table Views

- (NSInteger)tableView:(BOTRTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(BOTRTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BOTRCell" forIndexPath:indexPath];
    [BOTRCore mapDictionary:tableView.dataArray[indexPath.row] onView:cell];
    if (tableView.dataArray.count - indexPath.item == 5) [tableView needMoreData];
    return cell;
}

#pragma mark - Collection Views

- (NSInteger)collectionView:(BOTRCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(BOTRCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BOTRCell" forIndexPath:indexPath];
    [BOTRCore mapDictionary:collectionView.dataArray[indexPath.item] onView:cell];
    if (collectionView.dataArray.count - indexPath.item == 5) [collectionView needMoreData];
    return cell;
}

#pragma mark - BOTR Views Delegates

- (NSString *)convertValue:(id)value forLabel:(BOTRLabel *)label { return @""; }

- (NSString *)convertValue:(id)value forImageView:(BOTRImageView *)imageView { return nil; }

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SEL setItemSelector = NSSelectorFromString(@"setItem:");
    if ([sender isKindOfClass:[UITableViewCell class]] && [segue.destinationViewController respondsToSelector:setItemSelector]) {
        id view = [(UITableViewCell *)sender superview];
        while (view && ![view isKindOfClass:[UITableView class]]) view = [view superview];
        UITableView *tableView = (UITableView *)view;
        if (tableView && [tableView isKindOfClass:[BOTRTableView class]]) {
            NSDictionary *item = ((BOTRTableView *)tableView).dataArray[[tableView indexPathForCell:sender].row];
            if (![item isKindOfClass:[NSDictionary class]]) item = [NSDictionary new];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [segue.destinationViewController performSelector:setItemSelector withObject:item];
#pragma clang diagnostic pop
        }
    }
    else
        if ([sender isKindOfClass:[UICollectionViewCell class]] && [segue.destinationViewController respondsToSelector:setItemSelector]) {
            id view = [(UICollectionViewCell *)sender superview];
            while (view && ![view isKindOfClass:[UICollectionView class]]) view = [view superview];
            UICollectionView *collectionView = (UICollectionView *)view;
            if (collectionView && [collectionView isKindOfClass:[BOTRCollectionView class]]) {
                NSDictionary *item = ((BOTRCollectionView *)collectionView).dataArray[[collectionView indexPathForCell:sender].item];
                if (![item isKindOfClass:[NSDictionary class]]) item = [NSDictionary new];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [segue.destinationViewController performSelector:setItemSelector withObject:item];
#pragma clang diagnostic pop
            }
        }
}

@end
