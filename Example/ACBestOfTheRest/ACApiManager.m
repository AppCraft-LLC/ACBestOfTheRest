//
//  ApiManager.m
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 16/10/2016.
//  Copyright © 2016 AppCraft. All rights reserved.
//

#import "ACApiManager.h"

static AFHTTPSessionManager *apiSessionManager = nil;
static NSString *apiURL;

@implementation ACApiManager

+ (void)initialize {
    
    apiURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"API URL"];
    NSAssert(apiURL, @"Please specify API URL key in your Info.plist");
    
    apiSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:apiURL]];
    apiSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    apiSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    apiSessionManager.responseSerializer.acceptableContentTypes = [apiSessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    apiSessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    apiSessionManager.securityPolicy.allowInvalidCertificates = YES;
    apiSessionManager.securityPolicy.validatesDomainName = NO;
}

+ (void)init {}

+ (void)get:(NSString *)request parameters:(NSDictionary *)parameters completion:(requestCompletionBlock)completionBlock {
    [apiSessionManager GET:request parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
        NSLog(@"Error: %@", error);
    }];
}

@end
