//
//  MCPaginationHelper.h
//  Manticore Utilities
//
//  Created by Richard Fung on 3/11/13.
//  Copyright (c) 2013 Yeti LLC. All rights reserved.
//
//  Infinite scroll is added automatically

#import <Foundation/Foundation.h>
#import "MCMeta.h"

@interface MCPaginationHelper : NSObject {
  NSMutableArray* newArray;
  BOOL isLoading;
}

@property (nonatomic,retain,readonly) MCMeta* meta;
@property (nonatomic,retain,readonly) NSMutableArray* objects;

// call this method to create a dummy helper
+(MCPaginationHelper*)helper;

// call this method when the Meta and objects need separation and there is no GUI
+(MCPaginationHelper*)helperWithRestKitArray:(NSArray*)array ;

// call this method when objects have GUI. After creating an object, [tableView reloadData] should be called.
+(MCPaginationHelper*)helperWithRestKitArray:(NSArray*)array andTableView:(UITableView*)tableView infiniteScroll:(BOOL)infiniteScroll;

// call to load more data manually
-(void)loadMoreData;

// call to load more data manually for a table view with infinite scroll
-(void)loadMoreData:(UITableView*)tableView;

@end
