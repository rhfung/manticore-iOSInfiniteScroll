//
//  MCPaginationRestKit.h
//  Manticore iOSInfiniteScroll
//
//  Created by Richard Fung on 3/11/13.
//  Copyright (c) 2013 Yeti LLC. All rights reserved.
//
//  Infinite scroll is added automatically

#import <Foundation/Foundation.h>
#import "MCPaginationHelper.h"
#import <RestKit/RestKit.h>

@interface MCPaginationHelper(RestKit)

+(void)setupMapping:(RKObjectManager*)manager;

+(id)firstObjectWithoutMetaBlock:(NSArray*)restKitArray;

@end
