//
//  UIRemoteLabel.h
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 30.09.14.
//  Copyright (c) 2014 AppCraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BOTRLabelConvertorProtocol;

@interface BOTRLabel : UILabel

@property (nonatomic, strong) IBInspectable NSString *key;
@property (nonatomic, strong) IBInspectable NSString *defaultValue;
@property (weak, nonatomic) IBOutlet id <BOTRLabelConvertorProtocol> convertor;

- (void)setRemoteValue:(id)value;

@end

@protocol BOTRLabelConvertorProtocol <NSObject>

- (NSString *)convertValue:(id)value forLabel:(BOTRLabel *)label;

@end
