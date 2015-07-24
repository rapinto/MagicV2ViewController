//
//  MagicV2ListInteractor.h
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



@protocol MagicV2ListInteractorDelegate;


@interface MagicV2ListInteractor : MagicV2Interactor



@property (nonatomic, strong) NSNumber* page;
@property (nonatomic, strong) NSNumber* perPage;
@property (nonatomic) BOOL isPagingDisabled;
@property (nonatomic) BOOL isPagingEnded;
@property (nonatomic, weak) id <MagicV2ListInteractorDelegate> delegate;



- (void)didReceiveResults:(NSMutableArray*)_ReceivedResults;
- (void)pagingTriggered;



@end



@protocol MagicV2ListInteractorDelegate <NSObject>

- (void)magicListInteractorDidReceivedResults:(MagicV2ListInteractor*)listInteractor forLoadingType:(MagicV2TableViewLoadingType)loadingType;

@end