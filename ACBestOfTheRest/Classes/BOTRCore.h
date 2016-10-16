//
//  BOTRCore.h
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 15/10/2016.
//  Copyright © 2016 AppCraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BOTRLabel.h"
#import "BOTRImageView.h"

typedef void (^requestCompletionBlock)(id response);
typedef NSArray *(^arrayExtractorBlock)(id response);

@class BOTRTableView, BOTRCollectionView;

@interface UIView (SubviewsByClass)

- (NSArray *)subviewsOfClass:(Class)c;

@end

@interface BOTRCore : NSObject

+ (NSArray *)extractDataArrayFromObject:(id)obj fromPath:(NSString *)path;

+ (void)mapRequest:(NSString *)request parameters:(NSDictionary *)parameters onTableView:(BOTRTableView *)tableView dataArray:(NSMutableArray *)dataArray arrayExtractor:(arrayExtractorBlock)arrayExtractor animated:(BOOL)animated;

+ (void)mapRequest:(NSString *)request parameters:(NSDictionary *)parameters onCollectionView:(BOTRCollectionView *)collectionView dataArray:(NSMutableArray *)dataArray arrayExtractor:(arrayExtractorBlock)arrayExtractor animated:(BOOL)animated;

+ (void)mapDictionary:(NSDictionary *)dictionary onView:(UIView *)view;

+ (void)get:(NSString *)request parameters:(NSDictionary *)parameters completion:(requestCompletionBlock)completionBlock;

+ (NSString *)stringFromNumeral:(NSNumber *)num usingNouns:(NSArray *)nouns;

@end
