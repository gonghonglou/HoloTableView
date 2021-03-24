//
//  HoloTableSection.m
//  HoloTableView
//
//  Created by 与佳期 on 2020/6/2.
//

#import "HoloTableSection.h"

@implementation HoloTableSection

- (instancetype)init {
    self = [super init];
    if (self) {
        _rows = [NSArray<HoloTableRowProtocol> new];
        _headerHeight = CGFLOAT_MIN;
        _footerHeight = CGFLOAT_MIN;
        _headerEstimatedHeight = CGFLOAT_MIN;
        _footerEstimatedHeight = CGFLOAT_MIN;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _headerConfigSEL                = @selector(holo_configureHeaderWithModel:);
        _footerConfigSEL                = @selector(holo_configureFooterWithModel:);
        _headerHeightSEL                = @selector(holo_heightForHeaderWithModel:);
        _footerHeightSEL                = @selector(holo_heightForFooterWithModel:);
        _headerEstimatedHeightSEL       = @selector(holo_estimatedHeightForHeaderWithModel:);
        _footerEstimatedHeightSEL       = @selector(holo_estimatedHeightForFooterWithModel:);
        
        _headerFooterConfigSEL          = @selector(holo_configureHeaderFooterWithModel:);
        _headerFooterHeightSEL          = @selector(holo_heightForHeaderFooterWithModel:);
        _headerFooterEstimatedHeightSEL = @selector(holo_estimatedHeightForHeaderFooterWithModel:);
        
        _willDisplayHeaderSEL           = @selector(holo_willDisplayHeaderWithModel:);
        _willDisplayFooterSEL           = @selector(holo_willDisplayFooterWithModel:);
        _didEndDisplayingHeaderSEL      = @selector(holo_didEndDisplayingHeaderWithModel:);
        _didEndDisplayingFooterSEL      = @selector(holo_didEndDisplayingFooterWithModel:);
#pragma clang diagnostic pop
    }
    return self;
}


- (void)addRow:(id<HoloTableRowProtocol>)row {
    if (!row) return;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.rows];
    [array addObject:row];
    self.rows = array.copy;
}

- (void)removeRow:(id<HoloTableRowProtocol>)row {
    if (!row) return;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.rows];
    [array removeObject:row];
    self.rows = array.copy;
}

- (void)removeAllRows {
    self.rows = [NSArray<HoloTableRowProtocol> new];
}

- (void)insertRow:(id<HoloTableRowProtocol>)row atIndex:(NSInteger)index {
    if (!row) return;
    
    if (index < 0) index = 0;
    if (index > self.rows.count) index = self.rows.count;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.rows];
    [array insertObject:row atIndex:index];
    self.rows = array.copy;
}

@end
