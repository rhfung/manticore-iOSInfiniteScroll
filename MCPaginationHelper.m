//
//  MCPaginationHelper.m
//  Manticore Utilities
//
//  Created by Richard Fung on 3/11/13.
//  Copyright (c) 2013 Yeti LLC. All rights reserved.
//

#import "MCPaginationHelper.h"
#import <AFNetworking-TastyPie/AFNetworking+ApiKeyAuthentication.h>
#import <SVPullToRefresh/UIScrollView+SVInfiniteScrolling.h>
#import <RestKit/RestKit.h>
#import <Manticore-iOSViewFactory/ManticoreViewFactory.h>

@interface MCPaginationHelper(Extension)

-(void)setMeta:(MCMeta*)newMeta;
-(void)setObjects:(NSMutableArray*)array;

@end

// inspired by Brad Larson's solution:
// http://stackoverflow.com/questions/5662360/gcd-to-perform-task-in-main-thread
void iosinfinitescroll_runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
  if ([NSThread isMainThread])
  {
    block();
  }
  else
  {
    dispatch_sync(dispatch_get_main_queue(), block);
  }
}

@implementation MCPaginationHelper

@synthesize meta = _meta;
@synthesize objects = _objects;

+(MCPaginationHelper*)helper{
  MCPaginationHelper* obj = [MCPaginationHelper new];
  obj.meta = [MCMeta new];
  obj.objects = [NSMutableArray array];
  
  obj->m_username = nil;
  obj->m_apikey = nil;
  obj->m_urlPrefix = nil;
  
  return obj;
}

+(MCPaginationHelper*)helperWithRestKit:(RKMappingResult*)mappingResult {
  MCPaginationHelper* obj = [MCPaginationHelper new];
  obj.meta = [MCMeta new];
  obj.objects = [NSMutableArray array];
  
  obj->m_username = nil;
  obj->m_apikey = nil;
  obj->m_urlPrefix = nil;
  
  [obj loadRestKitArray:mappingResult.array andTableView:nil infiniteScroll:NO];
  
  return obj;
}

+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix {
  MCPaginationHelper* obj = [MCPaginationHelper helper];
  
  obj->m_username = username;
  obj->m_apikey = apiKey;
  obj->m_urlPrefix = urlPrefix;
  
  return obj;
}

+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix restKit:(RKMappingResult*)result   {
  MCPaginationHelper* obj = [MCPaginationHelper helperWithUsername:username apikey:apiKey urlPrefix:urlPrefix];
  [obj loadRestKitArray:result.array andTableView:nil infiniteScroll:NO];
  return obj;
}


+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix restKitArray:(NSArray*)array   {
  MCPaginationHelper* obj = [MCPaginationHelper helperWithUsername:username apikey:apiKey urlPrefix:urlPrefix];
  [obj loadRestKitArray:array andTableView:nil infiniteScroll:NO];
  return obj;
}

+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix restKit:(RKMappingResult*)result andTableView:(UITableView*)tableView infiniteScroll:(BOOL)infiniteScroll {
  MCPaginationHelper* obj = [MCPaginationHelper helperWithUsername:username apikey:apiKey urlPrefix:urlPrefix];
  [obj loadRestKitArray:result.array andTableView:tableView infiniteScroll:infiniteScroll];
  return obj;
}


+(MCPaginationHelper*)helperWithUsername:(NSString*)username apikey:(NSString*)apiKey urlPrefix:(NSString*)urlPrefix restKitArray:(NSArray*)array andTableView:(UITableView*)tableView infiniteScroll:(BOOL)infiniteScroll {
  MCPaginationHelper* obj = [MCPaginationHelper helperWithUsername:username apikey:apiKey urlPrefix:urlPrefix];
  [obj loadRestKitArray:array andTableView:tableView infiniteScroll:infiniteScroll];
  return obj;
}

+(MCPaginationHelper*)helperWithPaginator:(MCPaginationHelper*)oldPaginator andTableView:(UITableView*)tableView infiniteScroll:(BOOL)scrollSetting {
  MCPaginationHelper* obj = [MCPaginationHelper helperWithUsername:[oldPaginator->m_username copy] apikey:[oldPaginator->m_apikey copy] urlPrefix:[oldPaginator->m_urlPrefix copy]];
  [obj loadMeta:[oldPaginator->_meta copy] andObjects:[NSMutableArray arrayWithArray:oldPaginator->_objects] tableView:tableView infiniteScroll:scrollSetting];
  
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
  
  MCMeta* newMeta = nil;
  NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:array.count];
  for (int i = 0; i < array.count; i++){
    NSObject* sample = [array objectAtIndex:i];
    
    if (sample == nil){
      // remove null
    }else if ([sample isKindOfClass:[MCMeta class]]){
      newMeta = (MCMeta*) sample;
    }else{
      [newArray addObject:sample];
    }
  }
  
  [self loadMeta:newMeta andObjects:newArray tableView:scrollView infiniteScroll:infiniteScroll];
}

-(void)loadMeta:(MCMeta*)meta andObjects:(NSMutableArray*)objects tableView:(UITableView*)scrollView infiniteScroll:(BOOL)infiniteScroll {
  _meta = meta;
  _objects = objects;
  
  // determine if scroll down is needed
  
  if (scrollView && infiniteScroll) {
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
  
  // verify that keys are assigned
  if (!m_username || !m_apikey || !m_urlPrefix){
    NSAssert(!m_username || !m_apikey || !m_urlPrefix, @"Infinite scroll requires a constructor with username, apikey, and url prefix");
  }
  
  isLoading = YES;

  
  // set up RestKit 0.20
  RKObjectManager* sharedMgr = [ RKObjectManager sharedManager];
  [sharedMgr.HTTPClient setAuthorizationHeaderWithTastyPieUsername:m_username andToken:m_apikey];
  
  // this line should remove the api/ prefix from the URLs returned from the server
  NSAssert([[_meta.next substringToIndex:m_urlPrefix.length] isEqualToString:m_urlPrefix], @"All URLs returned from the server should be prefixed by API_URL");
  NSString* modURL = [_meta.next substringFromIndex:m_urlPrefix.length];
  if ([modURL characterAtIndex:0] == '/'){ // auto remove the path prefix (/)
    modURL = [modURL substringFromIndex:1];
  }
  
//  NSLog(@"Infinite scroll is hitting %@", modURL);
  UITableView* savedTableView = tableView;
  
  [sharedMgr getObjectsAtPath:modURL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    // erase the old meta object, we will load another one
    self.meta = nil;
    
    // filter out the Meta object from the result list and add to the meta property
    for (int i = 0; i < mappingResult.array.count; i++){
      NSObject* sample = [mappingResult.array objectAtIndex:i];
      if (sample && ![sample isKindOfClass:[MCMeta class]]){
        [_objects addObject:sample];
      }else if ([sample isKindOfClass:[MCMeta class]]){
        self.meta = (MCMeta*)sample;
//          NSLog(@"Infinite scroll found a new limit %@ and offset %@ and next page `%@`", self.meta.limit, self.meta.offset, self.meta.next);
      }
    }
    
    // assumption: infinite scrolling is already turned on
    if (savedTableView){
      [savedTableView.infiniteScrollingView stopAnimating];
      
      iosinfinitescroll_runOnMainQueueWithoutDeadlocking(
        ^(void){
          [savedTableView reloadData];

          if (!self.meta || !self.meta.next){
            savedTableView.showsInfiniteScrolling = NO;
          }
          else{
            savedTableView.showsInfiniteScrolling = YES;
          }
          });
    }
    
    isLoading = NO;
    

   
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    [[MCViewModel sharedModel] setErrorTitle:@"Infinite Scroll" andDescription:error.localizedDescription];
    
    if (savedTableView){
      savedTableView.showsInfiniteScrolling = NO;
      [savedTableView.infiniteScrollingView stopAnimating];
    }

    isLoading = NO;
  }];
  
}


@end
