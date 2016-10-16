//
//  BOTRCore.m
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 15/10/2016.
//  Copyright © 2016 AppCraft. All rights reserved.
//

#import "BOTRCore.h"
#import "BOTRTableView.h"
#import "BOTRCollectionView.h"

static id ApiManager;

@implementation UIView (SubviewsByClass)

- (NSArray *)subviewsOfClass:(Class)c {
    NSMutableArray *results = [NSMutableArray new];
    NSMutableArray *queue = [[NSMutableArray alloc] initWithObjects:self, nil];
    while (queue.count) {
        UIView *view = queue[0];
        [queue removeObjectAtIndex:0];
        if ([view isKindOfClass:c])
            [results addObject:view];
        else
            [queue addObjectsFromArray:view.subviews];
    }
    return results;
}

@end

@implementation BOTRCore

+ (void)initialize {
    
    NSString *apiManagerClassString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"API Manager Class"];
    NSAssert(apiManagerClassString, @"Please specify API Manager Class key in your Info.plist");

    Class apiManagerClass = NSClassFromString(apiManagerClassString);
    if ([(id)apiManagerClass respondsToSelector:@selector(get:parameters:completion:)])
        ApiManager = apiManagerClass;
    else {
        SEL sharedInstanceSelector = NSSelectorFromString(@"sharedInstance");
        if ([(id)apiManagerClass respondsToSelector:sharedInstanceSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id sharedInstance = [(id)apiManagerClass performSelector:sharedInstanceSelector];
#pragma clang diagnostic pop
            if ([sharedInstance respondsToSelector:@selector(get:parameters:completion:)])
                ApiManager = sharedInstance;
        }
    }
    NSAssert(ApiManager, @"Specified API Manager Class doesn't response to get:parameters:completion: method");
}

+ (NSArray *)extractDataArrayFromObject:(id)obj fromPath:(NSString *)path {
    if (obj == nil) return nil;
    if ([obj isKindOfClass:[NSArray class]]) return (NSArray *)obj;
    if (path == nil) return nil;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        id entity = (NSDictionary *)obj;
        NSArray *steps = [path componentsSeparatedByString:@"/"];
        for (NSString *step in steps)
            if (entity && [entity isKindOfClass:[NSDictionary class]] && entity[step])
                entity = entity[step];
        return (entity && [entity isKindOfClass:[NSArray class]]) ? (NSArray *)entity : nil;
    }
    return nil;
}

+ (void)mapRequest:(NSString *)request parameters:(NSDictionary *)parameters onTableView:(BOTRTableView *)tableView dataArray:(NSMutableArray *)dataArray arrayExtractor:(arrayExtractorBlock)arrayExtractor animated:(BOOL)animated {
    if (animated)
        [tableView beginLoading];
    [self get:request parameters:parameters completion:^(id response) {
        if (animated)
            [tableView endLoading];
        if (response) {
            [dataArray removeAllObjects];
            [dataArray addObjectsFromArray:arrayExtractor(response)];
        }
        [tableView reloadData];
    }];
}

+ (void)mapRequest:(NSString *)request parameters:(NSDictionary *)parameters onCollectionView:(BOTRCollectionView *)collectionView dataArray:(NSMutableArray *)dataArray arrayExtractor:(arrayExtractorBlock)arrayExtractor animated:(BOOL)animated {
    if (animated)
        [collectionView beginLoading];
    [self get:request parameters:parameters completion:^(id response) {
        if (animated)
            [collectionView endLoading];
        if (response) {
            [dataArray removeAllObjects];
            [dataArray addObjectsFromArray:arrayExtractor(response)];
        }
        [collectionView reloadData];
    }];
}

+ (void)mapDictionary:(NSDictionary *)dictionary onView:(UIView *)view {
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) return;
    NSArray *labels = [view subviewsOfClass:[BOTRLabel class]];
    for (BOTRLabel *label in labels)
        if (label.key) [label setRemoteValue:dictionary[label.key]];
    NSArray *remoteImageViews = [view subviewsOfClass:[BOTRImageView class]];
    for (BOTRImageView *imageView in remoteImageViews)
        if (imageView.key) [imageView setRemoteValue:dictionary[imageView.key]];
}

+ (void)get:(NSString *)request parameters:(NSDictionary *)parameters completion:(requestCompletionBlock)completionBlock {
    [ApiManager get:request parameters:parameters completion:completionBlock];
}

+ (NSString *)stringFromNumeral:(NSNumber *)num usingNouns:(NSArray *)nouns {
    static const Byte cases[6] = {2, 0, 1, 1, 1, 2};
    NSAssert(num, @"You should specify a number");
    NSAssert(nouns, @"You should specify nouns array");
    NSAssert(nouns.count >= 2, @"Number of elements in noun array should be at least 2");
    int n = abs(num.intValue);
    return nouns.count == 2 ? nouns[n > 1 ? 1 : 0] : nouns[(n % 100 > 4 && n % 100 < 20) ? 2 : cases[MIN(n % 10, 5)]];
}

@end

