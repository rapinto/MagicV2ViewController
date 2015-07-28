//
//  MagicV2ViewController.m
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


#import "MagicV2ViewController.h"
#import "MagicV2Interactor.h"
#import "MagicV2DetailInteractor.h"
#import "MagicV2ListInteractor.h"
#import "MagicV2DefaultLoadingCell.h"
#import "MagicV2NoResultsCell.h"
#import "MagicV2PagingCell.h"
#import "MagicV2TableHeaderViewDelegate.h"



@interface MagicV2ViewController ()

@end

@implementation MagicV2ViewController



#pragma mark -
#pragma mark Object Life Cycle Methods



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isPullToRefreshEnabled = YES;
    
    [self initDetailModel];
    _detailModel.delegate = self;
    [self initListModel];
    _listModel.delegate = self;
    [self initTableHeaderView];
    
    [self addEmptyFooterViewIfNeeded];
    [self initUIRefreshControl];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadModelRequestsForLoadingType:kMagicV2TableViewLoadingType_Init];
}


- (void)dealloc
{
    HNLog(@"");
}



#pragma mark -
#pragma mark Init Magic Methods


// /!\ Need to be implemented to activate detail + list mode
- (void)initDetailModel
{
}


// /!\ Must be implemented
- (void)initListModel
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
}


// /!\ Need to be implemented to activate detail + list mode
- (void)initTableHeaderView
{
    if (!_tableHeaderView)
    {
        _tableHeaderView = [self magicTableHeaderView];        
        self.tableView.tableHeaderView = _tableHeaderView;
    }
}


- (void)initUIRefreshControl
{
    if (_isPullToRefreshEnabled)
    {
        UIRefreshControl* lRefreshControl = [[UIRefreshControl alloc] init];
        [lRefreshControl addTarget:self action:@selector(diTriggerPullToRefresh:) forControlEvents:UIControlEventValueChanged];
        [self setRefreshControl:lRefreshControl];
    }
}


#pragma mark -
#pragma mark View Update Methods



- (void)addEmptyFooterViewIfNeeded
{
    if (!self.tableView.tableFooterView)
    {
        UIView* lEmptyFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        lEmptyFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tableView.tableFooterView = lEmptyFooterView;
    }
}



#pragma mark -
#pragma mark Magic Methods



- (void)resetModels
{
    
    
}


- (void)loadModelRequestsForLoadingType:(MagicV2TableViewLoadingType)_LoadingType
{
    if (_detailModel)
    {
        [_detailModel getResultsForLoadingType:_LoadingType];
        
        [self setHeaderViewForModel:_detailModel];
    }
    else if (_listModel)
    {
        [_listModel getResultsForLoadingType:_LoadingType];
        
        [self setHeaderViewForModel:_listModel];
    }
}


- (UITableViewCell*)defaultLoadingCellForTableView:(UITableView*)tableView
{
    MagicV2DefaultLoadingCell* lCell = [tableView dequeueReusableCellWithIdentifier:@"MagicV2DefaultLoadingCell"];
    
    if (!lCell)
    {
        NSArray* lViews = [[NSBundle mainBundle] loadNibNamed:@"MagicV2DefaultLoadingCell" owner:self options:nil];
        
        for (UIView* aView in lViews)
        {
            if ([aView isKindOfClass:[MagicV2DefaultLoadingCell class]])
            {
                lCell = (MagicV2DefaultLoadingCell*)aView;
            }
        }
    }
    
    return lCell;
}


- (UITableViewCell*)noResultCellForTableView:(UITableView*)tableView section:(NSInteger)section
{
    MagicV2NoResultsCell* lCell = [tableView dequeueReusableCellWithIdentifier:@"MagicV2NoResultsCell"];
    
    if (!lCell)
    {
        NSArray* lViews = [[NSBundle mainBundle] loadNibNamed:@"MagicV2NoResultsCell" owner:self options:nil];
        
        for (UIView* aView in lViews)
        {
            if ([aView isKindOfClass:[MagicV2NoResultsCell class]])
            {
                lCell = (MagicV2NoResultsCell*)aView;
            }
        }
    }
    
    return lCell;
}


- (UITableViewCell*)pagingCellForTableView:(UITableView*)tableView
{
    MagicV2PagingCell* lCell = [tableView dequeueReusableCellWithIdentifier:@"MagicV2PagingCell"];
    
    if (!lCell)
    {
        NSArray* lViews = [[NSBundle mainBundle] loadNibNamed:@"MagicV2PagingCell" owner:self options:nil];
        
        for (UIView* aView in lViews)
        {
            if ([aView isKindOfClass:[MagicV2PagingCell class]])
            {
                lCell = (MagicV2PagingCell*)aView;
            }
        }
    }
    
    return lCell;
}


- (UIView<MagicV2TableHeaderViewDelegate>*)magicTableHeaderView
{
    return nil;
}


// /!\ Must be implemented
- (UITableViewCell*)tableViewCellForTableView:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    
    return nil;
}


// /!\ Must be implemented
- (CGFloat)tableViewCellHeightForTableView:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    
    return 0.0f;
}



#pragma mark -
#pragma mark View Update Methods



- (void)setHeaderViewForModel:(MagicV2Interactor*)model
{
    [self updateTableHeaderView];
    self.tableView.tableHeaderView = _tableHeaderView;
}


- (void)updateTableHeaderView
{
    if (_tableHeaderView && [_tableHeaderView respondsToSelector:@selector(updateMagicHeaderViewAndReturnNewHeightForMagicController:)])
    {
        float lheight = [_tableHeaderView updateMagicHeaderViewAndReturnNewHeightForMagicController:self];
        
        _tableHeaderView.frame = CGRectMake(_tableHeaderView.frame.origin.x,
                                            _tableHeaderView.frame.origin.y,
                                            _tableHeaderView.frame.size.width,
                                            lheight);
        HNLog(@"HEHOOOO");
        HNLogRect(_tableHeaderView.frame);
    }
}



#pragma mark -
#pragma mark User Interaction Methods



- (void)diTriggerPullToRefresh:(id)sender
{
    [self resetModels];
    
    if (_detailModel)
    {
        [_detailModel pullToRefreshTriggered];
    }
    else
    {
        [_listModel pullToRefreshTriggered];
    }
}


- (void)didTriggerPaging
{
    [_listModel pagingTriggered];
}



#pragma mark -
#pragma mark Table View Data Source Methods



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_listModel.isPagingEnded)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,
                                                       self.tableView.contentInset.left,
                                                       [MagicV2PagingCell cellHeight],
                                                       self.tableView.contentInset.right);
        return [_listModel.results count];
    }
    
    return [_listModel.results count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_detailModel.loadingType != kMagicV2TableViewLoadingType_NotLoading || _listModel.loadingType != kMagicV2TableViewLoadingType_NotLoading)
    {
        return [self defaultLoadingCellForTableView:tableView];
    }
    else
    {
        if ([_listModel.results count] == 0)
        {
            return [self noResultCellForTableView:tableView section:indexPath.section];
        }
        else if ([_listModel.results count] > indexPath.row)
        {
            return [self tableViewCellForTableView:tableView forIndexPath:indexPath];
        }
        else
        {
            return [self pagingCellForTableView:tableView];
        }
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bugCell"];
}



#pragma mark -
#pragma mark Delegate Methods



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MagicV2PagingCell class]])
    {
        [self didTriggerPaging];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_detailModel.loadingType != kMagicV2TableViewLoadingType_NotLoading || _listModel.loadingType != kMagicV2TableViewLoadingType_NotLoading)
    {
        return [MagicV2DefaultLoadingCell cellHeight];
    }
    else
    {
        if ([_listModel.results count] == 0)
        {
            return [MagicV2NoResultsCell cellHeight];
        }
        else if ([_listModel.results count] > indexPath.row)
        {
            return [self tableViewCellHeightForTableView:tableView forIndexPath:indexPath];
        }
        else
        {
            return [MagicV2PagingCell cellHeight];
        }
    }
    
    return 44.0f;
}



#pragma mark -
#pragma mark Magic Detail Interactor Delegate Methods



- (void)magicDetailInteractorDidReceivedResults:(MagicV2DetailInteractor*)detailInteractor forLoadingType:(MagicV2TableViewLoadingType)loadingType
{
    switch (loadingType)
    {
        case kMagicV2TableViewLoadingType_PullToRefresh:
            [_listModel pullToRefreshTriggered];
            break;
        case kMagicV2TableViewLoadingType_Init:
            [_listModel getResultsForLoadingType:kMagicV2TableViewLoadingType_Init];
            [self setHeaderViewForModel:_listModel];
            break;
        default:
            break;
    }
    
    [self updateTableHeaderView];
}



#pragma mark -
#pragma mark Magic List Interactor Delegate Methods



- (void)magicListInteractorDidReceivedResults:(MagicV2ListInteractor*)listInteractor forLoadingType:(MagicV2TableViewLoadingType)loadingType
{
    if (loadingType == kMagicV2TableViewLoadingType_PullToRefresh)
    {
        [self.refreshControl endRefreshing];
    }
    
    [self.tableView reloadData];
}


@end
