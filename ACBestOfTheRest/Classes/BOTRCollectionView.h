//
//  UIRemoteCollectionView.h
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 30.11.14.
//  Copyright (c) 2014 AppCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOTRCore.h"

@interface BOTRCollectionView : UICollectionView

@property (nonatomic, strong) IBInspectable NSString *urlPath;
@property (nonatomic, strong) IBInspectable NSString *dataPath;
@property (nonatomic) IBInspectable NSUInteger chunkSize;
@property (nonatomic) IBInspectable BOOL showLoading;
@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic) BOOL placeholderIsHidden;

@property (nonatomic, weak) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *queryParams;

- (void)loadData;
- (void)needMoreData;

- (void)beginLoading;
- (void)endLoading;

@end
