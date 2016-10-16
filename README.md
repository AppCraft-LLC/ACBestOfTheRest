# ACBestOfTheRest

[![Version](https://img.shields.io/cocoapods/v/ACBestOfTheRest.svg?style=flat)](http://cocoapods.org/pods/ACBestOfTheRest)
[![License](https://img.shields.io/cocoapods/l/ACBestOfTheRest.svg?style=flat)](http://cocoapods.org/pods/ACBestOfTheRest)
[![Platform](https://img.shields.io/cocoapods/p/ACBestOfTheRest.svg?style=flat)](http://cocoapods.org/pods/ACBestOfTheRest)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

[AFNetworking](https://github.com/AFNetworking/AFNetworking) is reqiered for images downloading management.

## Installation

ACBestOfTheRest is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ACBestOfTheRest"
```

## Usage

### 1. Specify API Manager Class 

ACBestOfTheRest assumes you're cool and use some API manager class to handle sessions, auto relogins and so on. With AFNetworking example API manager class can be something like this:

```objective-c
#import <Foundation/Foundation.h>
#import "BOTRCore.h"
#import "AFNetworking.h"

@interface ACApiManager : NSObject

+ (void)init;

@end
```

and

```objective-c
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
```

This class sets some parameters of AFHTTPSessionManager like base URL, serializers, SSL rules and so on and provides REST methods, which should be smart here, e.g. do auto relogin when session token is expired.

ACBestOfTheRest use this class or singletone instance to request data throught API. So as the first you need some kind of API manager class and specify it in your .plist file using `API Manager Class` key: ![Sample 1](http://appcraft.pro/external/botr_scr_01.png)

Notice that in this example public VK API `https://api.vk.com/method` is using as `API URL` key for API manager class.

Either API manager class or it's shared instance should responds to `get:parameters:completion:` method. ACBestOfTheRest check if the class you specefied responds to this method, if no, it tries to get it's shared instance by calling `sharedInstance` method and if even that instance doesn't response to `get:parameters:completion:` method it throws NSAssert exception. So you should implement the method either in your API manager class directly or in it's shared instance. 

### 2. Use BOTRViewController

Inherit your ViewController class from BOTRViewController:

```objective-c
#import <UIKit/UIKit.h>
#import "BOTRViewController.h"

@interface ViewController : BOTRViewController

@end
```

In the ViewController.m file we just initialize API manager class: 

```objective-c
#import "ViewController.h"
#import "ACApiManager.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ACApiManager init];
}

@end
```

### 3. Do Something In Your Storyboard

Drop UITableView on your ViewController's view, set it's class to BOTRTableView and add the table to `tableViews` outlet collection: ![Sample 2](http://appcraft.pro/external/botr_scr_02.png)

After that set `Url Path` and `Data Path` properties of your table: ![Sample 3](http://appcraft.pro/external/botr_scr_03.png)

`Url Path` will be passed to your API manager class. `Data Path` is the path to some array in JSON response. If your JSON response contains just an array, leave this property empty. If your JSON response contains a dictionary, which contains `response` field with desired array, then set it's value to `response`. You can use `\` character to specify more complex path.

Then drop UITableViewCell prototype on your table and set it's reuse identifier property to `BOTRCell`.

Finally, drop some UILabels into cell, set class of them as `BOTRLabel` and specify `Key` and `Dafault Value` properties, where `Key` is just a field of your JSON response.

### 4. That's it

Just run the project at this point and see result: ![Sample 4](http://appcraft.pro/external/botr_scr_04.png)

You can add other labels and set it's `Key` value to show display other fields of JSON response, you can also use BOTRImageView to display images. You can pass elements of array to details controllers and do all stuff you do before, but with less code. Please see example project for more datails.

## Author

[AppCraft LLC](http://appcraft.pro) - mobile development studio (iOS & Android specializaion), support@appcraft.pro. 

## License

ACBestOfTheRest is available under the MIT license. See the LICENSE file for more info.
