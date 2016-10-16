//
//  UIRemoteTableView.h
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 29.11.14.
//  Copyright (c) 2016 AppCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOTRCore.h"

@interface BOTRTableView : UITableView

@property (nonatomic, strong) IBInspectable NSString *urlPath;
@property (nonatomic, strong) IBInspectable NSString *dataPath;
@property (nonatomic) IBInspectable NSUInteger chunkSize;
@property (nonatomic) IBInspectable BOOL showLoading;
@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic) BOOL placeholderIsHidden;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *queryParams;

@property (nonatomic) BOOL softReload;

- (void)loadData;
- (void)needMoreData;

- (void)beginLoading;
- (void)endLoading;

@end
