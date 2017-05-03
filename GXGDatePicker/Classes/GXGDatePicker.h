//
//  GXGDatePicker.h
//
//
//  Created by mrgxg on 2016/12/14.
//  Copyright © 2016 mrgxg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^GXGDatePickerSelectHandler)( NSDate * _Nullable selectedDate);

typedef NS_ENUM(NSInteger, GXGDatePickerMode) {
    GXGDatePickerModeDateAndTime = 0,    //年月日天小时分
    GXGDatePickerModeDate = 1,           //只有年月日
    GXGDatePickerModeMonthDayTime = 2,   //月日小时分
    GXGDatePickerModeHourMinute = 3      //只有时分
};

/**
    1.默认小于最小日期的日期不显示  大于最大日期的不会显示
    2.可以设置循环滚动
 */

@interface GXGDatePicker : UIView


@property (nonatomic, assign) BOOL isShowAsCycle;                       //是否循环显示
@property (nonatomic, assign) BOOL hiddenNavigationBar;                 //是否遮挡navigationBar

@property (nonatomic, strong) UIColor *datePickerTextColor;             //文字颜色
@property (nonatomic, strong) UIFont *datePickerTextFont;               //文字字体
@property (nonatomic, strong) UIColor *datePickerBackgroundColor;       //datePicker背景颜色

@property (nonatomic, assign) GXGDatePickerMode datePickerMode;         //日期类型 默认 GXGDatePickerModeDateAndTime
@property (nullable, nonatomic, strong) NSTimeZone *timeZone;           //默认为系统时区
@property (nullable, nonatomic, strong) NSDate *minimumDate;            //最小日期 默认为 1970-01-01 00:00:00 开始   minimumDate要小于maximumDate
@property (nullable, nonatomic, strong) NSDate *maximumDate;            //最大日期 默认为 2099-12-31 00:00:00
@property (nullable, nonatomic, strong) NSDate *mCurrentDate;           //选中的日期  默认为当前日期


/**
 设置当前选中的为某指定日期

 @param date 指定的日期
 @param animated 是否有动画
 */
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

/**
 显示日期选择器

 @param selectHandler 选择后点击确定按钮回调
 */
- (void)showDatePicker:(nullable GXGDatePickerSelectHandler)selectHandler;


/**
 显示日期选择器
 

 @param targetView 在某个View上显示
 @param selectHandler 选择后点击确定按钮回调
 */
- (void)showDatePickerInView:(nullable UIView *)targetView selectHandler:(nullable GXGDatePickerSelectHandler)selectHandler;


/**
 隐藏日期选择器
 */
- (void)dissmissDatePicker;

@end

NS_ASSUME_NONNULL_END
