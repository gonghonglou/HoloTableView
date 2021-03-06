//
//  UITableView+HoloTableViewProxy.h
//  HoloTableView
//
//  Created by 与佳期 on 2019/7/27.
//

#import <UIKit/UIKit.h>
@class HoloTableSection, HoloTableViewProxy;

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (HoloTableViewProxy)

/**
 *  Datasource of current UITableView.
 */
@property (nonatomic, copy) NSArray<HoloTableSection *> *holo_sections;

/**
 *  Return list of section titles to display in section index view (e.g. "ABCD...Z#").
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *holo_sectionIndexTitles;

/**
 *  Tell table which section corresponds to section title/index (e.g. "B",1)).
 */
@property (nonatomic, copy, nullable) NSInteger (^holo_sectionForSectionIndexTitleHandler)(NSString *title, NSInteger index);

/**
 *  The delegate of the scroll-view object.
 */
@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> holo_scrollDelegate;

/**
 *  Proxy of current UITableView.
 */
@property (nonatomic, strong, readonly) HoloTableViewProxy *holo_proxy;

@end

NS_ASSUME_NONNULL_END
