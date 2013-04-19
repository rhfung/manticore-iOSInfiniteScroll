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
  volatile BOOL isLoading;
  
  NSString* m_username;
  NSString* m_apikey;
  NSString* m_urlPrefix;
}

@property (nonatomic,retain,readonly) MCMeta* meta;
@property (nonatomic,retain,readonly) NSMutableArray* objects;

// call this method to create a dummy helper
+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix;

// call this method when the Meta and objects need separation and there is no GUI
+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix restKitArray:(NSArray*)array ;

// call this method when objects have GUI. After creating an object, [tableView reloadData] should be called.
+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix restKitArray:(NSArray*)array andTableView:(UITableView*)tableView infiniteScroll:(BOOL)infiniteScroll;

// call to load more data manually
-(void)loadMoreData;

// call to load more data manually for a table view with infinite scroll
-(void)loadMoreData:(UITableView*)tableView;

@end
