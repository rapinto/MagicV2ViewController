//
//  MagicV2Model.m
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



#import "MagicV2Interactor.h"

@implementation MagicV2Interactor



#pragma mark -
#pragma mark Object Life Cycle Methods



- (id)init
{
    self = [super init];
    if (self)
    {
        _requestKey = [NSString stringWithFormat:@"Request_key_%@",[self description]];
        _loadingType = kMagicV2TableViewLoadingType_NotLoading;
        _requestCallDeltaTime = 0;
        _results = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc
{
    HNLog(@"");
}



#pragma mark -
#pragma mark Request Sending Methods



- (void)sendRequest
{
}


- (void)loadLocalResults
{
    [self didReceiveResult];
}



#pragma mark -
#pragma mark Data Management Methods



- (void)getResultsForLoadingType:(MagicV2TableViewLoadingType)_LoadingType
{
    if (self.loadingType != kMagicV2TableViewLoadingType_NotLoading)
    {
        return;
    }
    
    
    _loadingType = _LoadingType;
    [self updateCurrentPage];
    
    
    id lObj = [[NSUserDefaults standardUserDefaults] objectForKey:[self computedRequestKey]];
    
    BOOL lAlreadySent = YES;
    
    if ([lObj isKindOfClass:[NSDate class]])
    {
        NSDate* lLastCallTs = (NSDate*)lObj;
        
        if ([lLastCallTs timeIntervalSince1970] + self.requestCallDeltaTime < [[NSDate date] timeIntervalSince1970])
        {
            lAlreadySent = NO;
        }
    }
    else
    {
        lAlreadySent = NO;
    }
    
    
    if (!lAlreadySent)
    {
        [self sendRequest];
    }
    else 
    {
        [self loadLocalResults];
    }
}


- (void)didReceiveResult
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[self computedRequestKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)didReceiveError
{
    [self loadLocalResults];
}


- (NSString*)computedRequestKey
{
    return self.requestKey;
}


- (void)deleteLastCallTimestamp
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self computedRequestKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)updateCurrentPage
{
}



#pragma mark -
#pragma User Interaction Methods



- (void)pullToRefreshTriggered
{
    if (self.loadingType != kMagicV2TableViewLoadingType_NotLoading)
    {
        return;
    }
    
    [self deleteLastCallTimestamp];
    
    [self getResultsForLoadingType:kMagicV2TableViewLoadingType_PullToRefresh];
}



@end
