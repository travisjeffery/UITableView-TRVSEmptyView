//
//  UITableView+TRVSEmptyTableView.m
//  UITableView+TRVSEmptyTableView
//
//  Created by Travis Jeffery on 4/26/14.
//
//

#import "UITableView+TRVSEmptyView.h"
#import <objc/runtime.h>

static const NSString *TRVSEmptyViewAssociatedKey = @"TRVSEmptyViewAssociatedKey";
static const NSString *TRVSSeperatorStyleAssociatedKey = @"TRVSSeperatorStyleAssociatedKey";
static const NSString *TRVSHideSeperatorsAssociatedKey = @"TRVSHideSeperatorsAssociatedKey";

void trvs_swizzle(Class class, SEL originalName, SEL replacingName) {
    Method originalMethod = class_getInstanceMethod(class, originalName);
    Method replacingMethod = class_getInstanceMethod(class, replacingName);
    if (class_addMethod(class, originalName, method_getImplementation(replacingMethod), method_getTypeEncoding(replacingMethod))) {
        class_replaceMethod(class, replacingName, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, replacingMethod);
    }
}

@interface UITableView (TRVSEmptyViewPrivate)

@property (nonatomic, assign) UITableViewCellSeparatorStyle trvs_separatorStyle;

@end

@implementation UITableView (TRVSEmptyView)

+ (void)load {
    trvs_swizzle([UITableView class], @selector(reloadData), @selector(trvs_reloadData));
    trvs_swizzle([UITableView class], @selector(layoutSubviews), @selector(trvs_layoutSubviews));
}

- (void)setTrvs_emptyView:(UIView *)trvs_emptyView {
    if (self.trvs_emptyView) {
        [self.trvs_emptyView removeFromSuperview];
    }
    objc_setAssociatedObject(self, &TRVSEmptyViewAssociatedKey, trvs_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self trvs_updateEmptyView];
}

- (void)setTrvs_hideSeparatorsWhenEmpty:(BOOL)trvs_hideSeparatorsWhenEmpty {
    objc_setAssociatedObject(self, &TRVSHideSeperatorsAssociatedKey, @(trvs_hideSeparatorsWhenEmpty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)trvs_hideSeparatorsWhenEmpty {
    return [objc_getAssociatedObject(self, &TRVSHideSeperatorsAssociatedKey) boolValue];
}

- (UIView *)trvs_emptyView {
    return objc_getAssociatedObject(self, &TRVSEmptyViewAssociatedKey);
}

- (void)trvs_reloadData {
    [self trvs_reloadData];
    [self trvs_updateEmptyView];
}

- (void)trvs_layoutSubviews {
    [self trvs_layoutSubviews];
    [self trvs_updateEmptyView];
}

- (void)trvs_updateEmptyView {
    if (!self.trvs_emptyView)
        return;
    
    if (self.trvs_emptyView.superview != self)
        [self addSubview:self.trvs_emptyView];
    
    self.trvs_emptyView.frame = ({
        CGRect rect = self.bounds;
        rect.origin = (CGPoint){0, 0};
        rect = UIEdgeInsetsInsetRect(rect, (UIEdgeInsets){.top = CGRectGetHeight(self.tableHeaderView.frame)});
        rect.size.height -= self.contentInset.top;
        rect;
    });

    self.trvs_emptyView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    if ([self trvs_isEmpty] && self.trvs_hideSeparatorsWhenEmpty) {
        self.trvs_separatorStyle = self.separatorStyle;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else if (self.trvs_hideSeparatorsWhenEmpty) {
        self.separatorStyle = self.trvs_separatorStyle;
    }
    
    self.trvs_emptyView.hidden = ![self trvs_isEmpty];
}

- (BOOL)trvs_isEmpty {
    NSUInteger rowCount = 0;
    for (NSInteger section = 0; section < self.numberOfSections; section++) {
        rowCount += [self numberOfRowsInSection:section];
    }
    return rowCount == 0;
}

@end

@implementation UITableView (TRVSEmptyViewPrivate)

@dynamic trvs_separatorStyle;

- (void)setTrvs_separatorStyle:(UITableViewCellSeparatorStyle)trvs_separatorStyle {
    objc_setAssociatedObject(self, &TRVSSeperatorStyleAssociatedKey, @(trvs_separatorStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableViewCellSeparatorStyle)trvs_separatorStyle {
    NSNumber *style = objc_getAssociatedObject(self, &TRVSSeperatorStyleAssociatedKey);
    return style ? style.integerValue : self.separatorStyle;
}

@end

