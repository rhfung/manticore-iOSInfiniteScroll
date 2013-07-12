//
//  MCInfiniteScrollDelegate.h
//  Manticore iOSInfiniteScroll
//
//  Created by Richard Fung on 7/12/2013.
//  Copyright (c) 2013 Yeti LLC. All rights reserved.
//

@class MCPaginationHelper;

@protocol MCInfiniteScrollDelegate <NSObject>

@optional
-(void)infiniteScrollDidLoad:(MCPaginationHelper*)scrollManager withAppendedContents:(NSArray*)appendedContents;

@end