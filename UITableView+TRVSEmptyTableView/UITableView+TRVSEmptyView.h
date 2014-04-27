//
//  UITableView+TRVSEmptyTableView.h
//  UITableView+TRVSEmptyTableView
//
//  Created by Travis Jeffery on 4/26/14.
//
//

#import <UIKit/UIKit.h>

@interface UITableView (TRVSEmptyView)

@property (nonatomic, strong) UIView *trvs_emptyView;
@property (nonatomic, assign) BOOL trvs_hideSeparatorsWhenEmpty;

@end
