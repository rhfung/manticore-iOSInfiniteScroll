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
#import <RestKit/RestKit.h>
#import "MCInfiniteScrollDelegate.h"

@interface MCPaginationHelper : NSObject {
  volatile BOOL isLoading;
  
  NSString* m_username;
  NSString* m_apikey;
  NSString* m_urlPrefix;
  
}

@property (nonatomic,retain,readonly) MCMeta* meta;
@property (nonatomic,retain,readonly) NSMutableArray* objects;

@property (weak,nonatomic) UITableView* tableView;
@property (weak,nonatomic) id<MCInfiniteScrollDelegate> delegate; // Delegate is not copied on helperWithPaginator:andTableView:infiniteScroll:

// call this method to create an empty helper
+(MCPaginationHelper*)helper;

// call this method to create a helper bound to RestKit
+(MCPaginationHelper*)helperWithRestKit:(RKMappingResult*)mappingResult;

// call this method when the Meta and objects need separation and there is no GUI. username and apiKey can be nil.
+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix restKit:(RKMappingResult*)result;

// call this method when objects have GUI. After creating an object, [tableView reloadData] should be called. username and apiKey can be nil.
+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix restKit:(RKMappingResult*)result andTableView:(UITableView*)tableView infiniteScroll:(BOOL)infiniteScroll;

// Call this method to switch the ownership of infinite scroll data from one table to another table. Delegate is not copied.
+(MCPaginationHelper*)helperWithPaginator:(MCPaginationHelper*)oldPaginator andTableView:(UITableView*)tableView infiniteScroll:(BOOL)scrollSetting;

//// deprecated
//+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix restKitArray:(NSArray*)array __attribute__((deprecated));
//
//// deprecated
//+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix restKitArray:(NSArray*)array andTableView:(UITableView*)tableView infiniteScroll:(BOOL)infiniteScroll __attribute__((deprecated));


// call to load more data manually
-(void)loadMoreData;

@end
