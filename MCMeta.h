//
//  MCMeta.h
//  manticore-iOSInfiniteScroll
//
//  Created by the Manticore Manticom (iOS Communication) on 2013-04-18.
//  Copyright (c) 2013 manticore-iOSInfiniteScroll. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCMeta : NSObject

@property(nonatomic, retain) NSString* next;
@property(nonatomic, retain) NSNumber* total_count;
@property(nonatomic, retain) NSNumber* offset;
@property(nonatomic, retain) NSNumber* limit;
@property(nonatomic, retain) NSString* previous;

@end
