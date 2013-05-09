//
//  MCMeta.m
//  manticore-iOSInfiniteScroll
//
//  Created by the Manticore Manticom (iOS Communication) on 2013-04-18.
//  Copyright (c) 2013 manticore-iOSInfiniteScroll. All rights reserved.
//

#import "MCMeta.h"


@implementation MCMeta

@synthesize next;
@synthesize total_count;
@synthesize offset;
@synthesize limit;
@synthesize previous;

-(id)copyWithZone:(NSZone *)zone{
  MCMeta* m = [[MCMeta allocWithZone:zone] init];
  m.next = self.next;
  m.total_count = self.total_count;
  m.offset = self.offset;
  m.limit = self.limit;
  m.previous = self.previous;
  
  return m;
}

@end
