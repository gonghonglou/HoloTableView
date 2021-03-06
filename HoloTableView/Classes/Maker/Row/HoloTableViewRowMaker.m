//
//  HoloTableViewRowMaker.m
//  HoloTableView
//
//  Created by 与佳期 on 2019/7/28.
//

#import "HoloTableViewRowMaker.h"
#import "HoloTableRow.h"
#import "HoloTableRowMaker.h"

@interface HoloTableViewRowMaker ()

@property (nonatomic, strong) NSMutableArray<HoloTableRow *> *holoRows;

@end

@implementation HoloTableViewRowMaker

- (HoloTableRowMaker * (^)(Class))row {
    return ^id(Class cls) {
        HoloTableRowMaker *rowMaker = [HoloTableRowMaker new];
        HoloTableRow *tableRow = [rowMaker fetchTableRow];
        tableRow.cell = cls;
        
        [self.holoRows addObject:tableRow];
        return rowMaker;
    };
}

- (NSArray<HoloTableRow *> *)install {
    return self.holoRows;
}

#pragma mark - getter
- (NSMutableArray<HoloTableRow *> *)holoRows {
    if (!_holoRows) {
        _holoRows = [NSMutableArray new];
    }
    return _holoRows;
}

@end
