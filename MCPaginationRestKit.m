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

-(void)setupMapping:(RKObjectManager*)manager {
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


@end
