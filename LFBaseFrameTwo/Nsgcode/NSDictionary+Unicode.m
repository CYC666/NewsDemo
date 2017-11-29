//
//  NSDictionary+Unicode.m
//  LFBaseFrameTwo
//
//  Created by maco on 2017/5/5.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "NSDictionary+Unicode.h"

@implementation NSDictionary (Unicode)

- (NSString*)my_description
{
    NSString *desc = [self my_description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

@end
