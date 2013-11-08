//
//  Identicon.m
//  identicon
//
//  Created by 藤賀 雄太 on 11/8/13.
//  Copyright (c) 2013 Evgeniy Yurtaev. All rights reserved.
//

#import "Identicon.h"

@implementation Identicon
//toga
+ (UIImage *)identiconWithString:(NSString *)string size:(CGSize)size{
    [self stringToRGBDictionaryArray:string];
    NSArray *colorPosArray = [NSArray array];
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //get width rate array
    NSArray *widthRateArray = [self stringToWidthRateArray:string];
    NSArray *originArray = [self widthRateArrayToOriginArray:widthRateArray size:size];
    //get color array
    NSArray *RGBDictionaryArray = [self stringToRGBDictionaryArray:string];
    NSLog(@"originArray %@", originArray.description);
    NSLog(@"colorPosArray.description %@", colorPosArray.description);
    for (int i = 0; i<string.length; i++) {
        UIColor * color = [UIColor colorWithRed:[[[RGBDictionaryArray objectAtIndex:i] objectForKey:@"R"] floatValue]/255.0f
                                          green:[[[RGBDictionaryArray objectAtIndex:i] objectForKey:@"G"] floatValue]/255.0f
                                           blue:[[[RGBDictionaryArray objectAtIndex:i] objectForKey:@"B"] floatValue]/255.0f
                                          alpha:1.0f];
        NSLog(@"color: %@", color);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, CGRectMake([[originArray objectAtIndex:i] floatValue],
                                              0,
                                              [[originArray objectAtIndex:i+1] floatValue]-[[originArray objectAtIndex:i] floatValue],
                                              size.height));
    }
    UIImage *identiconImage = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"colorPosArray.description%@", colorPosArray.description);
    //delete me
    [self widthRateArrayToOriginArray:widthRateArray size:size];
    return identiconImage;
}

+ (NSArray*)widthRateArrayToOriginArray:(NSArray*)widthRateArray size:(CGSize)size{
    NSMutableArray *originArray = [NSMutableArray array];
    int currentOrigin = 0;
    for (int i= 0; i<widthRateArray.count-1; i++) {
        currentOrigin += [[widthRateArray objectAtIndex:i] floatValue]*size.width;
        [originArray addObject:[NSNumber numberWithInteger: (int)currentOrigin]];
    }
    [originArray insertObject:[NSNumber numberWithFloat:0.0f] atIndex:0];
    [originArray addObject:[NSNumber numberWithInteger:(int)size.width]];
    
    NSLog(@"originArray %@", originArray);
    return originArray;
}

+(NSArray *)stringToRGBDictionaryArray:(NSString *)string{
    NSArray *numberArray = [self stringToNumberArray:string];
    NSMutableArray *RGBDictionaryArray = [NSMutableArray array];
    for (int i = 0; i<string.length; i++) {
        NSDictionary *dictionary;
        if (i<string.length-2) {
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithFloat:[[numberArray objectAtIndex:i] floatValue]/62.0f*255.0f], @"R",
                          [NSNumber numberWithFloat:[[numberArray objectAtIndex:i+1] floatValue]/62.0f*255.0f], @"G",
                          [NSNumber numberWithFloat:[[numberArray objectAtIndex:i+2] floatValue]/62.0f*255.0f], @"B",
                          nil];
        }else if (i == string.length-2){
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithFloat:[[numberArray objectAtIndex:i] floatValue]/62.0f*255.0f], @"R",
                          [NSNumber numberWithFloat:[[numberArray objectAtIndex:i+1] floatValue]/62.0f*255.0f], @"G",
                          [NSNumber numberWithFloat:[[numberArray objectAtIndex:0] floatValue]/62.0f*255.0f], @"B",
                          nil];
        }else if (i == string.length-1){
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithFloat:[[numberArray objectAtIndex:i] floatValue]/62.0f*255.0f], @"R",
                          [NSNumber numberWithFloat:[[numberArray objectAtIndex:0] floatValue]/62.0f*255.0f], @"G",
                          [NSNumber numberWithFloat:[[numberArray objectAtIndex:1] floatValue]/62.0f*255.0f], @"B",
                          nil];
        }else{
            NSLog(@"error: something wrong! in stringToRGBDictionaryArray");
        }
        [RGBDictionaryArray addObject:dictionary];
    }
    NSLog(@"RGBDictionaryArray %@", RGBDictionaryArray);
    return RGBDictionaryArray;
}


+ (NSArray *)stringToWidthRateArray:(NSString *)string{
    NSArray *numberArray = [self stringToNumberArray:string];
    NSNumber *sum = [numberArray valueForKeyPath:@"@sum.self"];
    NSMutableArray *widthRateArray = [NSMutableArray array];
    for (int i = 0; i<string.length; i++) {
        [widthRateArray addObject: [NSNumber numberWithFloat:[[numberArray objectAtIndex:i] intValue]/[sum floatValue]]];
    }
    NSLog(@"widthRateArray %@", widthRateArray);
    return widthRateArray;
}


+ (NSArray *)stringToNumberArray:(NSString *)string{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<string.length; i++) {
        [array addObject:[NSNumber numberWithInteger:[self stringToNumber:[string substringWithRange:NSMakeRange(i,1)]]]];
    }
    return array;
}

+ (int)stringToNumber:(NSString *)string{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInteger:1] , @"0",
                                [NSNumber numberWithInteger:2] , @"1",
                                [NSNumber numberWithInteger:3] , @"2",
                                [NSNumber numberWithInteger:4] , @"3",
                                [NSNumber numberWithInteger:5] , @"4",
                                [NSNumber numberWithInteger:6] , @"5",
                                [NSNumber numberWithInteger:7] , @"6",
                                [NSNumber numberWithInteger:8] , @"7",
                                [NSNumber numberWithInteger:9] , @"8",
                                [NSNumber numberWithInteger:10] , @"9",
                                [NSNumber numberWithInteger:11] , @"a",
                                [NSNumber numberWithInteger:12] , @"b",
                                [NSNumber numberWithInteger:13] , @"c",
                                [NSNumber numberWithInteger:14] , @"d",
                                [NSNumber numberWithInteger:15] , @"e",
                                [NSNumber numberWithInteger:16] , @"f",
                                [NSNumber numberWithInteger:17] , @"g",
                                [NSNumber numberWithInteger:18] , @"h",
                                [NSNumber numberWithInteger:19] , @"i",
                                [NSNumber numberWithInteger:20] , @"j",
                                [NSNumber numberWithInteger:21] , @"k",
                                [NSNumber numberWithInteger:22] , @"l",
                                [NSNumber numberWithInteger:23] , @"m",
                                [NSNumber numberWithInteger:24] , @"n",
                                [NSNumber numberWithInteger:25] , @"o",
                                [NSNumber numberWithInteger:26] , @"p",
                                [NSNumber numberWithInteger:27] , @"q",
                                [NSNumber numberWithInteger:28] , @"r",
                                [NSNumber numberWithInteger:29] , @"s",
                                [NSNumber numberWithInteger:30] , @"t",
                                [NSNumber numberWithInteger:31] , @"u",
                                [NSNumber numberWithInteger:32] , @"v",
                                [NSNumber numberWithInteger:33] , @"w",
                                [NSNumber numberWithInteger:34] , @"x",
                                [NSNumber numberWithInteger:35] , @"y",
                                [NSNumber numberWithInteger:36] , @"z",
                                [NSNumber numberWithInteger:37] , @"A",
                                [NSNumber numberWithInteger:38] , @"B",
                                [NSNumber numberWithInteger:39] , @"C",
                                [NSNumber numberWithInteger:40] , @"D",
                                [NSNumber numberWithInteger:41] , @"E",
                                [NSNumber numberWithInteger:42] , @"F",
                                [NSNumber numberWithInteger:43] , @"G",
                                [NSNumber numberWithInteger:44] , @"H",
                                [NSNumber numberWithInteger:45] , @"I",
                                [NSNumber numberWithInteger:46] , @"J",
                                [NSNumber numberWithInteger:47] , @"K",
                                [NSNumber numberWithInteger:48] , @"L",
                                [NSNumber numberWithInteger:49] , @"M",
                                [NSNumber numberWithInteger:50] , @"N",
                                [NSNumber numberWithInteger:51] , @"O",
                                [NSNumber numberWithInteger:52] , @"P",
                                [NSNumber numberWithInteger:53] , @"Q",
                                [NSNumber numberWithInteger:54] , @"R",
                                [NSNumber numberWithInteger:55] , @"S",
                                [NSNumber numberWithInteger:56] , @"T",
                                [NSNumber numberWithInteger:57] , @"U",
                                [NSNumber numberWithInteger:58] , @"V",
                                [NSNumber numberWithInteger:59] , @"W",
                                [NSNumber numberWithInteger:60] , @"X",
                                [NSNumber numberWithInteger:61] , @"Y",
                                [NSNumber numberWithInteger:62] , @"Z",
                                nil];
    return [[dictionary objectForKey:string] intValue];
}
@end
