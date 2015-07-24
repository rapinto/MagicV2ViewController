//
//  MagicV2ListInteractor.m
//
//
//  Created by Raphaël Pinto on 21/07/2015.
//
// The MIT License (MIT)
// Copyright (c) 2015 Raphael Pinto.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.



#import "MagicV2ListInteractor.h"
#import "MagicV2Interactor.h"



@implementation MagicV2ListInteractor



#pragma mark -
#pragma mark Object Life Cycle Methods



- (id)init
{
    self = [super init];
    
    if (self)
    {
        _perPage = [NSNumber numberWithInt:20];
        _page = [NSNumber numberWithInt:1];
    }
    
    return self;
}



#pragma mark -
#pragma mark Data Management Methods



/*- (void)initFetchResultController
{
    if ([[self computedRequestKey] length] > 0)
    {
        [NSFetchedResultsController deleteCacheWithName:[self computedRequestKey]];
    }
    
    
    NSFetchRequest* lRequest = [self fetchRequest];
    lRequest.fetchOffset = 0;
    lRequest.fetchLimit = [_perPage intValue] * [_page intValue];
    
    
    self.resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:lRequest
                                                                managedObjectContext:[self managedObjectContext]
                                                                  sectionNameKeyPath:nil
                                                                           cacheName:[self computedRequestKey]];
    self.resultController.delegate = self.resultControllerDelegate;
    
    [self.resultController performFetch:nil];
}


- (NSManagedObjectContext*)managedObjectContext
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    
    return nil;
}


- (NSFetchRequest*)fetchRequest
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    
    return nil;
}*/


- (void)didReceiveResults:(NSMutableArray*)_ReceivedResults
{
    [super didReceiveResult];
    
    if (self.loadingType == kMagicV2TableViewLoadingType_PullToRefresh || self.loadingType == kMagicV2TableViewLoadingType_Init)
    {
        [self.results removeAllObjects];
    }
    
    [self.results addObjectsFromArray:_ReceivedResults];
    
    [self updatePagingEngine:_ReceivedResults];
    
    MagicV2TableViewLoadingType lPreviousLoadingType = self.loadingType;
    self.loadingType = kMagicV2TableViewLoadingType_NotLoading;
    
    [_delegate magicListInteractorDidReceivedResults:self forLoadingType:lPreviousLoadingType];
}


- (void)updatePagingEngine:(NSMutableArray*)_ReceivedResults
{
    if ([_ReceivedResults count] < [self.perPage intValue])
    {
        self.isPagingEnded = YES;
    }
    else
    {
        self.isPagingEnded = NO;
    }
}


- (void)pagingTriggered
{
    if (self.isPagingEnded)
    {
        return;
    }
    
    [self getResultsForLoadingType:kMagicV2TableViewLoadingType_Paging];
}


- (NSString*)computedRequestKey
{
    return [self.requestKey stringByAppendingFormat:@"_%@", self.page];
}


- (void)deleteLastCallTimestamp
{
    for (NSString* aKey in [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys])
    {
        if ([aKey rangeOfString:self.requestKey].location != NSNotFound)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKey];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)updateCurrentPage
{
    if (self.loadingType == kMagicV2TableViewLoadingType_Init || self.loadingType == kMagicV2TableViewLoadingType_PullToRefresh)
    {
        self.page = [NSNumber numberWithInt:1];
    }
    else if (self.loadingType == kMagicV2TableViewLoadingType_Paging)
    {
        self.page = [NSNumber numberWithInt:[self.page intValue] + 1];
    }
}



@end
