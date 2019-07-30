//
//  UITableView+HoloTableViewProxy.m
//  HoloTableView
//
//  Created by 与佳期 on 2019/7/27.
//

#import "UITableView+HoloTableViewProxy.h"
#import <objc/runtime.h>
#import "HoloTableViewProxy.h"

static char kHoloTableViewProxyKey;

@implementation UITableView (HoloTableViewProxy)

- (HoloTableViewProxy *)holo_tableViewProxy {
    HoloTableViewProxy *tableViewProxy = objc_getAssociatedObject(self, &kHoloTableViewProxyKey);
    if (!tableViewProxy) {
        tableViewProxy = [[HoloTableViewProxy alloc] initWithTableView:self];
        objc_setAssociatedObject(self, &kHoloTableViewProxyKey, tableViewProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (!self.dataSource || !self.delegate) {
            self.dataSource = tableViewProxy;
            self.delegate = tableViewProxy;
        }
    }
    return tableViewProxy;
}

#pragma mark - getter & setter
- (HoloTableViewDataSource *)holo_tableDataSource {
    return self.holo_tableViewProxy.holo_tableDataSource;
}

- (id<UIScrollViewDelegate>)holo_tableScrollDelegate {
    return self.holo_tableViewProxy.holo_tableScrollDelegate;
}

- (void)setHolo_tableScrollDelegate:(id<UIScrollViewDelegate>)holo_tableScrollDelegate {
    self.holo_tableViewProxy.holo_tableScrollDelegate = holo_tableScrollDelegate;
}

@end
