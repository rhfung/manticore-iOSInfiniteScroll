//
//  MCPaginationHelper.m
//  Manticore Utilities
//
//  Created by Richard Fung on 3/11/13.
//  Copyright (c) 2013 Yeti LLC. All rights reserved.
//

#import "MCPaginationHelper.h"
#import "AFNetworking+ApiKeyAuthentication.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <RestKit/RestKit.h>
#import "AppModel.h"
#import "MCViewModel.h"

@interface MCPaginationHelper(Extension)

-(void)setMeta:(Meta*)newMeta;
-(void)setObjects:(NSMutableArray*)array;

@end

@implementation MCPaginationHelper

@synthesize meta = _meta;
@synthesize objects = _objects;

+(MCPaginationHelper*)helper{
  MCPaginationHelper* obj = [MCPaginationHelper new];
  obj.meta = [Meta new];
  obj.objects = [NSMutableArray array];
  return obj;
}

+(MCPaginationHelper*)helperWithRestKitArray:(NSArray*)array  {
  MCPaginationHelper* obj = [MCPaginationHelper new];
  [obj loadRestKitArray:array andTableView:nil infiniteScroll:NO];
  return obj;
}


+(MCPaginationHelper*)helperWithRestKitArray:(NSArray*)array andTableView:(UITableView*)tableView infiniteScroll:(BOOL)infiniteScroll {
  MCPaginationHelper* obj = [MCPaginationHelper new ];
  [obj loadRestKitArray:array andTableView:tableView infiniteScroll:infiniteScroll];
  return obj;
}

-(void)setMeta:(MCMeta *)newMeta{
  _meta = newMeta;
}

-(void)setObjects:(NSMutableArray *)array{
  _objects = array;
}

-(void)loadRestKitArray:(NSArray*)array andTableView:(UITableView*)scrollView infiniteScroll:(BOOL)infiniteScroll {
  
  isLoading = NO;
  // process data from RestKit
  // extract the Meta object from the rest of the objects
  
  newArray = [NSMutableArray arrayWithCapacity:array.count];
  for (int i = 0; i < array.count; i++){
    NSObject* sample = [array objectAtIndex:i];
    
    if (sample == nil){
      // remove null
    }else if ([sample isKindOfClass:[Meta class]]){
      _meta = (Meta*) sample;
    }else{
      [newArray addObject:sample];
    }
  }
  
  _objects = newArray;
  
  
  // determine if scroll down is needed
  
  if (scrollView && infiniteScroll){
    if (_meta && _meta.next){
      scrollView.showsInfiniteScrolling = YES;
      __weak UITableView* weakScrollView = scrollView;
      [scrollView addInfiniteScrollingWithActionHandler:^{
        
        [self loadMoreData:weakScrollView];
        
        
        
      }];
      
    }else{
      scrollView.showsInfiniteScrolling = NO;
    }
    
    [scrollView reloadData];
  }
  else{
    scrollView.showsInfiniteScrolling = NO;
  }
}

-(void)loadMoreData{
  [self loadMoreData:nil];
}

-(void)loadMoreData:(UITableView*)tableView{
  // guard against multiple reloads
  if (isLoading)
    return;
  
  // nothing to scroll to next, do nothing
  if (!_meta || !_meta.next)
    return;
  
  
  // set up RestKit 0.20
  RKObjectManager* sharedMgr = [ RKObjectManager sharedManager];
  [sharedMgr.HTTPClient setAuthorizationHeaderWithTastyPieUsername:[AppModel sharedModel].user.username andToken:[AppModel sharedModel].apikey];
  
  // this line should remove the api/ prefix from the URLs returned from the server
  NSAssert([[_meta.next substringToIndex:API_PREFIX.length] isEqualToString:API_PREFIX], @"All URLs returned from the server should be prefixed by API_URL");
  NSString* modURL = [_meta.next substringFromIndex:API_PREFIX.length];
  if ([modURL characterAtIndex:0] == '/'){ // auto remove the path prefix (/)
    modURL = [modURL substringFromIndex:1];
  }
  
  isLoading = YES;
  
  [sharedMgr getObjectsAtPath:modURL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    isLoading = NO;
    // erase the old meta object, we will load another one
    self.meta = nil;
    
    // filter out the Meta object from the result list and add to the meta property
    for (int i = 0; i < mappingResult.array.count; i++){
      NSObject* sample = [mappingResult.array objectAtIndex:i];
      if (sample && ![sample isKindOfClass:[Meta class]]){
        [newArray addObject:sample];
      }else if ([sample isKindOfClass:[Meta class]]){
        self.meta = (Meta*)sample;
      }
    }
    
    // assumption: infinite scrolling is already turned on
    if (tableView){
      [tableView.infiniteScrollingView stopAnimating];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
      
        if (!self.meta.next){
          tableView.showsInfiniteScrolling = NO;
          
        }
        else{
          tableView.showsInfiniteScrolling = YES;
        }
      });
      
    
    }
    
    
    
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    isLoading = NO;
    [[MCViewModel sharedModel] setErrorTitle:@"Infinite Scroll" andDescription:error.description];
    
    if (tableView){
      tableView.showsInfiniteScrolling = NO;
      [tableView.infiniteScrollingView stopAnimating];
    }
  }];
  
}


@end
