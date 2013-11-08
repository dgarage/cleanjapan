//
//  Identicon.h
//  identicon
//
//  Created by 藤賀 雄太 on 11/8/13.
//  Copyright (c) 2013 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Identicon : NSObject
+ (UIImage *)identiconWithString:(NSString *)string size:(CGSize)size;
@end
