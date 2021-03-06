# HoloTableView

[![CI Status](https://img.shields.io/travis/HoloFoundation/HoloTableView.svg?style=flat)](https://travis-ci.org/HoloFoundation/HoloTableView)
[![Version](https://img.shields.io/cocoapods/v/HoloTableView.svg?style=flat)](https://cocoapods.org/pods/HoloTableView)
[![License](https://img.shields.io/cocoapods/l/HoloTableView.svg?style=flat)](https://cocoapods.org/pods/HoloTableView)
[![Platform](https://img.shields.io/cocoapods/p/HoloTableView.svg?style=flat)](https://cocoapods.org/pods/HoloTableView)


`HoloTableView` provides chained syntax calls that encapsulate delegate methods for `UITableView`. The delegate methods for `UITableView` are distributed to each `cell`, each `cell` having its own method for setting Class, model, height, and click event, etc.


## Features

- [x] Provide section and row maker to handle proxy events of `UITableVIew`.
- [x] Provide protocols, implemented in cells, headers and footers to handle proxy events of `UITableVIew`.
- [x] Provide left-slide and right-slide actions for `cell`.
- [x] Passing events through the responder chain.
- [x] [HoloTableViewMGPlugin](https://github.com/HoloFoundation/HoloTableViewMGPlugin) to support `MGSwipeTableCell`, add swip actions for `cell`.
- [x] Diff reload data. [HoloTableViewDiffPlugin](https://github.com/HoloFoundation/HoloTableViewDiffPlugin) to support `DeepDiff`
- [x] Support to reload a table view by setting datasource with `HoloTableSection` and `HoloTableRow`.
- [ ] Modern Objective-C and better Swift support.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Integration with 3rd party libraries

- [HoloTableViewMGPlugin](https://github.com/HoloFoundation/HoloTableViewMGPlugin) - plugin to support [MGSwipeTableCell](https://github.com/MortimerGoro/MGSwipeTableCell), add swip actions for `cell`. `MGSwipeTableCell` is an easy to use `UITableViewCell` subclass that allows to display swipeable buttons with a variety of transitions.
- [HoloTableViewDiffPlugin](https://github.com/HoloFoundation/HoloTableViewDiffPlugin) - plugin to support [DeepDiff](https://github.com/onmyway133/DeepDiff), diff reload a section of `UITableView`. `DeepDiff` tells the difference between 2 collections and the changes as edit steps.

## Usage 

[中文介绍](https://github.com/HoloFoundation/HoloTableView/blob/master/README_CN.md)、[文章介绍](http://gonghonglou.com/2020/08/10/HoloTableView-HoloCollectionView/)

### 1. Make a simple cell list

```objc
UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
[self.view addSubview:tableView];

[tableView holo_makeRows:^(HoloTableViewRowMaker * _Nonnull make) {
   // make a cell
   make.row(ExampleTableViewCell.class).model(NSDictionary.new).height(44);
   
   // make a list
   for (NSObject *obj in NSArray.new) {
       make.row(ExampleTableViewCell.class).model(obj).didSelectHandler(^(id  _Nullable model) {
           NSLog(@"did select row : %@", model);
       });
   }
}];

[tableView reloadData];

// etc.
```

The `holo_makeRows:` method is used to create a list of rows **with a default section**. Each `row` is a `cell`. **More properties provided for row see: [HoloTableViewRowMaker.h](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Maker/Row/HoloTableViewRowMaker.h) and [HoloTableRowMaker.h](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Maker/Row/HoloTableRowMaker.h)**


#### Requirements for cell

Conforms to protocol `HoloTableViewCellProtocol`, `HoloTableView` will automatically identify `cell` whether implement these methods and calls, the commonly used two methods:

```objc
@required

// set the model to cell
// the model is the object passed in by make.model()
- (void)holo_configureCellWithModel:(id)model;


@optional

// return cell height（ Priority is higher than: 'heightHandler' and 'height' of maker）
// the model is the object passed in by make.model()
+ (CGFloat)holo_heightForCellWithModel:(id)model;
```

**See `HoloTableViewCellProtocol` more methods: [HoloTableViewCellProtocol](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Core/Protocol/HoloTableViewCellProtocol.h)**

You can also call your own methods by configuring properties such as `configSEL`, `heightSEL`, etc. More properties can find in [HoloTableRowMaker.h](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Maker/Row/HoloTableRowMaker.h).

Note that attributes such as `height`, `estimatedHeight`, etc. that exist `SEL` have priority:
1. First judge whether `cell` implements `heightSEL` method
2. Secondly, verify the implementation of the `heightHandler` block
3. Finally, determine whether the property `height` is assigned


### 2. Make a section list (contain header, footer, row)

```objc
UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
[self.view addSubview:tableView];
    
[tableView holo_makeSections:^(HoloTableViewSectionMaker * _Nonnull make) {
    make.section(TAG)
    .header(ExampleHeaderView.class)
    .headerModel(NSDictionary.new)
    .footer(ExampleFooterView.class)
    .footerModel(NSDictionary.new)
    .makeRows(^(HoloTableViewRowMaker * _Nonnull make) {
        // make a cell
        make.row(ExampleTableViewCell.class).model(NSDictionary.new).height(44);
        
        // make a list
        for (NSObject *obj in NSArray.new) {
            make.row(ExampleTableViewCell.class).model(obj).didSelectHandler(^(id  _Nullable model) {
                NSLog(@"did select row : %@", model);
            });
        }
    });
}];
    
[tableView reloadData];
```

The `holo_makeSections:` method is used to create a list of `section`. **More properties provided for section see: [HoloTableViewSectionMaker.h](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Maker/Section/HoloTableViewSectionMaker.h) and  [HoloTableSectionMaker.h](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Maker/Section/HoloTableSectionMaker.h)**


#### Requirements for header and footer

1. header: conforms to protocol `HoloTableViewHeaderProtocol` , implement these methods, the commonly used two methods:

```objc
@required

// set the model to header
// the model is the object passed in by make.headerModel()
- (void)holo_configureHeaderWithModel:(id)model;

@optional
    
// return header height（ Priority is higher than: 'headerHeightHandler' and 'headerHeight' of maker）
// the model is the object passed in by make.headerModel()
+ (CGFloat)holo_heightForHeaderWithModel:(id)model;
```

2. Footer: conforms to protocol `HoloTableViewFooterProtocol` , implement these methods, the commonly used two methods:

```objc
@required

// set the model to footer
// the model is the object passed in by make.footerModel()
- (void)holo_configureFooterWithModel:(id)model;

@optional

// return footer height（ Priority is higher than: 'footerHeightHandler' and 'footerHeight' of maker）
// the model is the object passed in by make.footerModel()
+ (CGFloat)holo_heightForFooterWithModel:(id)model;
```

**See `HoloTableViewHeaderProtocol` and `HoloTableViewFooterProtocol` more methods: [HoloTableViewHeaderProtocol](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Core/Protocol/HoloTableViewHeaderProtocol.h) and [HoloTableViewFooterProtocol](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Core/Protocol/HoloTableViewFooterProtocol.h)**

You can also call your own methods by configuring properties such as `headerConfigSEL`, `footerConfigSEL`, etc. More properties can find in  [HoloTableSectionMaker.h](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Maker/Section/HoloTableSectionMaker.h).

Like `cell`, properties that contain `SEL` also have a priority.


### 3. Methods for section

```objc
// adding
[self.tableView holo_makeSections:^(HoloTableViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// inserting at index
[self.tableView holo_insertSectionsAtIndex:0 block:^(HoloTableViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// updating with tag value by maker
[self.tableView holo_updateSections:^(HoloTableViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// resetting with tag value by maker
[self.tableView holo_remakeSections:^(HoloTableViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// deleting
[self.tableView holo_removeAllSections];

// deleting with tag value
[self.tableView holo_removeSections:@[TAG]];


// reloadData
[self.tableView reloadData];
```

`UITableView+HoloTableView.h` provides a series of methods for manipulating `sections`, including adding, inserting, updating, resetting, deleting, etc.
**More methods provided for section see: [UITableView+HoloTableView.h (about section)](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Maker/UITableView%2BHoloTableView.h#L24-L144)**


### 4. Methods for row

```objc
// adding
[self.tableView holo_makeRows:^(HoloTableViewRowMaker * _Nonnull make) {
    make.row(ExampleTableViewCell.class);
}];

// adding to section with tag value
[self.tableView holo_makeRowsInSection:TAG block:^(HoloTableViewRowMaker * _Nonnull make) {
    make.row(ExampleTableViewCell.class);
}];

// inserting at index
[self.tableView holo_insertRowsAtIndex:0 block:^(HoloTableViewRowMaker * _Nonnull make) {
    make.row(ExampleTableViewCell.class);
}];

// inserting at index to section with tag value
[self.tableView holo_insertRowsAtIndex:0 inSection:TAG block:^(HoloTableViewRowMaker * _Nonnull make) {
    make.row(ExampleTableViewCell.class);
}];

// updating
[self.tableView holo_updateRows:^(HoloTableViewUpdateRowMaker * _Nonnull make) {
    make.tag(TAG).height(120);
}];

// resetting
[self.tableView holo_remakeRows:^(HoloTableViewUpdateRowMaker * _Nonnull make) {
    make.tag(TAG).model(NSDictionary.new).height(120);
}];

// deleting
[self.tableView holo_removeAllRowsInSections:@[TAG]];

// deleting
[self.tableView holo_removeRows:@[TAG]];


// reloadData
[self.tableView reloadData];
```

`UITableView+HoloTableView.h` provides a series of methods for manipulating rows, including adding, inserting, updating, resetting, deleting, etc.
**More methods provided for row see: [UITableView+HoloTableView.h (about row)](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Maker/UITableView%2BHoloTableView.h#L146-L328)**


### 5. Retrieve Delegate

You can retrieve the delegate of `UITableView` at any time, such as:

```objc
// first way
self.tableView.holo_proxy.dataSource = self;
self.tableView.holo_proxy.delegate = self;
self.tableView.holo_proxy.scrollDelegate = self;

// second way
[self.tableView holo_makeTableView:^(HoloTableViewMaker * _Nonnull make) {
    make.dataSource(self).delegate(self).scrollDelegate(self);
}];
```

Once you set up `dataSource`, `delegate`, `scrollDelegate` and implement some of their methods, `HoloTableView` will use your methods and return values first. For specific logic, please refer to: [HoloTableViewProxy.m](https://github.com/HoloFoundation/HoloTableView/blob/master/HoloTableView/Classes/Core/HoloTableViewProxy.m)

### 6. Reload a table view by setting datasource with `HoloTableSection` and `HoloTableRow`

Make a section list with `HoloTableSection` and `HoloTableRow`:

```objc
HoloTableSection *section = [HoloTableSection new];
section.tag = TAG;

section.header = ExampleHeaderView.class;
section.headerModel = @{@"title":@"header"};

section.footer = ExampleFooterView.class;
section.footerModel = @{@"title":@"footer"};
section.footerHeight = 100;

NSMutableArray *rows = [NSMutableArray new];
for (NSDictionary *dict in self.modelArray) {
    HoloTableRow *row = [HoloTableRow new];
    row.cell = ExampleTableViewCell.class;
    row.model = dict;
    [rows addObject:row];
}
section.rows = rows;

self.tableView.holo_sections = @[section];
[self.tableView reloadData];
```


## Installation

HoloTableView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HoloTableView'
```

## Author

gonghonglou, gonghonglou@icloud.com

## License

HoloTableView is available under the MIT license. See the LICENSE file for more info.


