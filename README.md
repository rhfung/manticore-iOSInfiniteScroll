Manticore iOS Infinite Scroll
=============================

Manticore-iOSInfiniteScroll provides infinite scrolling for UITableView and supports [TastyPie pagination](http://django-tastypie.readthedocs.org/en/latest/) coupled with [RestKit](http://restkit.org/).

Installation
------------

Install using CocoaPods to this repository. Include the following line in `Podfile`:

    pod 'manticore-iOSInfiniteScroll', '~> 0.0.6', :git => 'https://github.com/rhfung/manticore-iOSInfiniteScroll.git'

Usage
-----

### Setup

Include the following header in your project file:

    #import <manticore-iOSInfiniteScroll/MCPagination.h>

After you set up RestKit's `RKObjectManager`, you'll need to run this command once, for example:

    RKObjectManager* manager = [RKObjectManager managerWithBaseURL:url];

    // ...

    [MCPaginationHelper setupMapping:manager];

This call must be made before the first RestKit call to map the `meta` key returned from the TastyPie server endpoint.

### Single object responses

When RestKit returns back a single object, you can extract the single object using:

    ... success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        id singleObject = [MCPaginationHelper firstObjectWithoutMetaBlock:mappingResult.array];

        // ...
    }

### Array object responses

#### Infinite Scroll in a UITableView

When RestKit returns back an array of objects, you can bind a table to an array for infinite scroll. Infinite scroll is provided by [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh) CocoaPod.

    ... success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        MCPaginatorHelper* arr = [MCPaginationHelper helperWithUsername:[AppModel sharedModel].user.username apikey:[AppModel sharedModel].apikey urlPrefix:API_PREFIX restKit:mappingResult andTableView:yourTableView infiniteScroll:YES];

        // ...
    }

#### Data-Only Parsing

`MCPaginatorHelper` can be used without a `UITableView`. A shorter function signature is used:

    MCPaginatorHelper* arr = [MCPaginationHelper helperWithUsername:[AppModel sharedModel].user.username apikey:[AppModel sharedModel].apikey urlPrefix:API_PREFIX restKit:mappingResult];
    // ...
    // invoke infinite scroll
    [arr loadMoreData];

Object mapping can be performed without infinite scroll. The following method is called:

        [MCPaginationHelper helperWithRestKit:mappingResult]

#### Dummy Mapping

A dummy mapping can be called too:

        [MCPaginationHelper helper]

#### Copying MCPaginatorHelper

You can reuse MCPaginationHelper for other table views. Here's how you would do that:
    
        MCPaginationHelper* otherData = [MCPaginationHelper ...];
        MCPaginationHelper* newData = [MCPaginationHelper helperWithPaginator:otherData andTableView:tableView infiniteScroll:YES];

### Using MCPaginatorHelper

`MCPaginatorHelper` objects provide two properties, which match exactly with TastyPie:

* `objects`: Objects returned and mapped by RestKit. Manticore Communication (manticom) is the preferred way to create these other mappings, or write RestKit mapping by hand.
* `meta`: Pagination information provided by TastyPie. `next` is the URL of the next page's resources. `total_count` refers to the total number of available objects and can be used to stop infinite scroll.

Revisions
---------

0.0.6 - possible bug fix to a crash that happens when UITableView gets deallocated on infinite scroll. A local copy of UITableView is saved, and UI updates are made synchronously in the block.

0.0.5 - bug fix in `helperWithPaginator:andTableView:infiniteScroll:` to prevent crashes during infinite scroll

To Do
-----

This project is a work in progress.

* Decouple authentication from TastyPie `apikey`
* Simplify the pagination function by saving `username`, `apikey`, and url prefix in a global object.

