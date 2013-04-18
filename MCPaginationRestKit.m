//
//  MCPaginationRestKit.m
//  Manticore iOSInfiniteScroll
//
//  Created by Richard Fung on 3/11/13.
//  Copyright (c) 2013 Yeti LLC. All rights reserved.
//

#import "MCPaginationHelper.h"
#import <RestKit/RestKit.h>

@implementation MCPaginationHelper(RestKit)

+(void)setupMapping:(RKObjectManager*)manager {
    NSIndexSet *successCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    NSIndexSet *failCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
    NSIndexSet *serverFailCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError);
    NSIndexSet *redirectCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassRedirection);

    // RestKit object mappings

    RKObjectMapping* MCMetaResponseMapping = [RKObjectMapping mappingForClass:[MCMeta class]];
    [MCMetaResponseMapping addAttributeMappingsFromDictionary:@{
                                                   @"next":@"next",
                                                   @"total_count":@"total_count",
                                                   @"offset":@"offset",
                                                   @"limit":@"limit",
                                                   @"previous":@"previous"}];


    // Responses applied to any URL

    RKResponseDescriptor* MCMeta_Response_n = [RKResponseDescriptor responseDescriptorWithMapping:MCMetaResponseMapping pathPattern:nil keyPath:@"meta" statusCodes:successCodes];

    // Configure RestKit to handle requests and responses

    [manager addResponseDescriptorsFromArray:@[MCMeta_Response_n]];
}

// use this method to filter out the Meta object before passing values back to the caller
+(id)firstObjectWithoutMetaBlock:(NSArray*)restKitArray {
  if (restKitArray.count == 0)
    return nil;
  else{
    if ([[restKitArray objectAtIndex:0] isKindOfClass:[MCMeta class]]){
      if (restKitArray.count > 1)
        return [restKitArray objectAtIndex:1];
      else
        return nil;
    }
    else{
      return [restKitArray objectAtIndex:0];
    }
  }
}


@end
