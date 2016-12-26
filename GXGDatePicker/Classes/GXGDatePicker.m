//
//  GXGDatePicker.m
//
//  Created by mrgxg on 2016/12/14.
//  Copyright © 2016 mrgxg. All rights reserved.
//

#import "GXGDatePicker.h"

#define MWDP_MONTH 12
#define MWDP_HOUR 24
#define MWDP_MINUTE 60

#define MWDP_Space 6                //datePicker每个column的view之间的距离

NSInteger const MW_DatePickerHeight = 216;
NSInteger const MW_ToolBarHeight = 40;

@interface NSDate (GXGDatePicker)

- (NSDate *)dateWithTimeZone:(NSTimeZone *)zone;

- (NSString *)dateFormat:(NSString *)formatter;

- (NSString *)dateFormat:(NSString *)formatter timeZone:(NSTimeZone *)zone;

+ (NSDate *)dateFrom:(NSString *)dateString format:(NSString *)formatter;

+ (NSDate *)dateFrom:(NSString *)dateString format:(NSString *)formatter timeZone:(NSTimeZone *)zone;

- (NSDate *)dateFromTimeZone:(NSTimeZone *)zone toZone:(NSTimeZone *)zone1;

+ (NSInteger)daysInYear:(NSInteger)year month:(NSInteger)imonth;

- (BOOL)laterThan:(NSDate *)date;

- (BOOL)earlyThan:(NSDate *)date;

@end


@interface UIColor (GXGDatePicker)

+ (UIColor *) gxg_colorWithHex:(NSString*) hex;

+ (UIColor *) gxg_colorWithHex:(NSString*) hex alpha:(CGFloat)alpha;

@end




@interface GXGDatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, copy) GXGDatePickerSelectHandler selectHandler;

@property (nonatomic, strong) NSMutableArray *mYearArray;           //年
@property (nonatomic, strong) NSMutableArray *mMonthArray;          //月
@property (nonatomic, strong) NSMutableArray *mDayArray;            //日
@property (nonatomic, strong) NSMutableArray *mHourArray;           //时
@property (nonatomic, strong) NSMutableArray *mMinArray;            //分

@property (nonatomic, strong) NSMutableArray *mSecondArray;         //秒


//当前选中的
@property (nonatomic, assign) NSInteger mYearIndex;
@property (nonatomic, assign) NSInteger mMonthIndex;
@property (nonatomic, assign) NSInteger mDayIndex;
@property (nonatomic, assign) NSInteger mHourIndex;
@property (nonatomic, assign) NSInteger mMinIndex;

@property (nonatomic, assign) NSInteger mCurrentYear;

//最小
@property (nonatomic, assign) NSInteger mMinYear;
@property (nonatomic, assign) NSInteger mMinMonth;
@property (nonatomic, assign) NSInteger mMinDay;
@property (nonatomic, assign) NSInteger mMinHour;
@property (nonatomic, assign) NSInteger mMinMinute;

//最大
@property (nonatomic, assign) NSInteger mMaxYear;
@property (nonatomic, assign) NSInteger mMaxMonth;
@property (nonatomic, assign) NSInteger mMaxDay;
@property (nonatomic, assign) NSInteger mMaxHour;
@property (nonatomic, assign) NSInteger mMaxMinute;


//最小日期的年月日等
@property (nonatomic, assign) NSInteger mMinDateMonth;
@property (nonatomic, assign) NSInteger mMinDateDay;
@property (nonatomic, assign) NSInteger mMinDateHour;
@property (nonatomic, assign) NSInteger mMinDateMinute;


//最大日期的年月日等
@property (nonatomic, assign) NSInteger mMaxDateMonth;
@property (nonatomic, assign) NSInteger mMaxDateDay;
@property (nonatomic, assign) NSInteger mMaxDateHour;
@property (nonatomic, assign) NSInteger mMaxDateMinute;


//展示个数
@property (nonatomic, assign) NSInteger mYearCount;
@property (nonatomic, assign) NSInteger mMonthCount;
@property (nonatomic, assign) NSInteger mDayCount;
@property (nonatomic, assign) NSInteger mHourCount;
@property (nonatomic, assign) NSInteger mMinuteCount;




@property (nonatomic, strong) NSDate *mSelectedDate;
@property (nonatomic, strong) UIPickerView *mDatePicker;
@property (nonatomic, strong) UIToolbar *mToolBar;
@property (nonatomic, strong) UIView *mContenView;

@property (nonatomic, strong) UIView *targetView;

@end
@implementation GXGDatePicker


- (instancetype)init{
    self = [super init];
    if (self) {
        [self initDateDatas];
        [self initUI];
    }
    return self;
}

- (void)initDateDatas{

    //初始化默认数据
//    self.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    self.timeZone = [NSTimeZone systemTimeZone];
    
    self.datePickerTextColor = [UIColor gxg_colorWithHex:@"#2f3030"];
    self.datePickerTextFont = [UIFont systemFontOfSize:18];
    self.datePickerBackgroundColor = [UIColor gxg_colorWithHex:@"#ecf0f3"];
    
    self.mMinMonth = 1;
    self.mMinDay = 1;
    
    self.mMinHour = 1;
    self.mMinMinute = 1;
    
    
    self.mMinDateHour = 1;
    self.mMinDateMinute = 1;
    
    self.mMaxMonth = MWDP_MONTH;
    self.mMaxHour = MWDP_HOUR;
    self.mMaxMinute = MWDP_MINUTE;
    
    self.mYearArray = [NSMutableArray array];
    self.mMonthArray = [NSMutableArray array];
    self.mDayArray = [NSMutableArray array];
    self.mHourArray = [NSMutableArray array];
    self.mMinArray = [NSMutableArray array];
    
    self.mYearCount = self.mMaxYear - self.mMinYear +1;
    
    for (NSInteger min = 1; min<MWDP_MINUTE ; min++) {
        NSString *num = [NSString stringWithFormat:@"%02ld",(long)min];
        if (min<=MWDP_MONTH) {
            [self.mMonthArray addObject:num];
        }
        if (min<=self.mDayCount) {
            [self.mDayArray addObject:num];
        }
        if (min<=MWDP_HOUR) {
            [self.mHourArray addObject:num];
        }
        if (min<=MWDP_MINUTE) {
            [self.mMinArray addObject:num];
        }
    }
    
    
    self.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.maximumDate = [NSDate dateFrom:@"2099-12-31" format:@"yyyy-MM-dd"];
    
    for (NSInteger year = self.mMinYear; year <= self.mMaxYear ; year++) {
        [self.mYearArray addObject:[NSString stringWithFormat:@"%ld",(long)year]];
    }
    
}


- (void)initUI{
    [self setBackgroundColor:[UIColor gxg_colorWithHex:@"#000000" alpha:0.1]];
    [self.mContenView  setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-64, CGRectGetWidth([UIScreen mainScreen].bounds),MW_DatePickerHeight+MW_ToolBarHeight)];
    [self addSubview:self.mContenView];

    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    
    self.mCurrentDate = [[NSDate date] dateWithTimeZone:self.timeZone];
    
    self.datePickerMode = GXGDatePickerModeDateAndTime;
}



#pragma mark - Private Method

- (void)showDatePickerInView:(UIView *)targetView selectHandler:(nullable GXGDatePickerSelectHandler)selectHandler{
    
    self.selectHandler = selectHandler;
    
    if (targetView && !self.hiddenNavigationBar) {
        self.targetView = targetView;
        [self setFrame:CGRectMake(0, 0,CGRectGetWidth(self.targetView.frame),CGRectGetHeight(self.targetView.frame))];
    }else{
        self.targetView = [self getKeyWindow];
        CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat originY = 0;
        if (!self.hiddenNavigationBar) {
            originY = 64;
        }
       [self setFrame:CGRectMake(0, originY, CGRectGetWidth([UIScreen mainScreen].bounds), screenHeight-64)];
    }
    
    [self.targetView addSubview:self];
    self.alpha = 0;
    
    [self.mContenView  setFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.targetView.frame),MW_DatePickerHeight+MW_ToolBarHeight)];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.mContenView  setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-MW_ToolBarHeight-MW_DatePickerHeight, CGRectGetWidth(self.frame),MW_DatePickerHeight+MW_ToolBarHeight)];
        }];
    }];

}

- (void)setDate:(NSDate *)date animated:(BOOL)animated{
    NSDate *selectDate = [date dateWithTimeZone:self.timeZone];
    [self setMCurrentDate:selectDate animation:animated];
}

- (void)showDatePicker:(GXGDatePickerSelectHandler)selectHandler{
    [self showDatePickerInView:nil selectHandler:selectHandler];
}

- (void)dissmissDatePicker{
    
    [self.mContenView  setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-64-MW_ToolBarHeight-MW_DatePickerHeight, CGRectGetWidth([UIScreen mainScreen].bounds),MW_DatePickerHeight+MW_ToolBarHeight)];
    [UIView animateWithDuration:0.25 animations:^{
       [self.mContenView  setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-64, CGRectGetWidth([UIScreen mainScreen].bounds),MW_DatePickerHeight+MW_ToolBarHeight)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];

    
}


- (UIWindow *)getKeyWindow {
    UIWindow *keyWindow = ((UIWindow *)[UIApplication sharedApplication].keyWindow);
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            keyWindow = window;
            break;
        }
    }
    return keyWindow;
}


- (void)resetDateDatas{
    [self calculateCurrentIndex: self.mCurrentDate];
    
    [self resetMonth];
    [self resetHour];
    [self resetMinute];
    
    self.mYearCount = self.mMaxYear - self.mMinYear + 1;
    self.mMonthCount = self.mMaxMonth - self.mMinMonth +1;
    self.mDayCount = self.mMaxDay - self.mMinDay + 1;
    self.mHourCount = self.mMaxHour - self.mMinHour + 1;
    self.mMinuteCount = self.mMaxMinute - self.mMinMinute + 1;
    
    [self.mYearArray removeAllObjects];
    [self.mMonthArray removeAllObjects];
    [self.mDayArray removeAllObjects];
    [self.mHourArray removeAllObjects];
    [self.mMinArray removeAllObjects];
    
    for (NSInteger year = self.mMinYear; year <= self.mMaxYear ; year++) {
        [self.mYearArray addObject:[NSString stringWithFormat:@"%ld",(long)year]];
    }
    
    for (NSInteger min = self.mMinMinute; min <= self.mMaxMinute ; min++) {
        NSString *num = [NSString stringWithFormat:@"%02ld",(long)min];
        [self.mMinArray addObject:num];
    }
    
    for (NSInteger min = self.mMinHour; min <= self.mMaxHour ; min++) {
        NSString *num = [NSString stringWithFormat:@"%02ld",(long)min];
        [self.mHourArray addObject:num];
    }
    
    for (NSInteger min = self.mMinDay; min <= self.mMaxDay ; min++) {
        NSString *num = [NSString stringWithFormat:@"%02ld",(long)min];
        [self.mDayArray addObject:num];
    }
    
    for (NSInteger min = self.mMinMonth; min <= self.mMaxMonth ; min++) {
        NSString *num = [NSString stringWithFormat:@"%02ld",(long)min];
        [self.mMonthArray addObject:num];
    }
    
}

- (void)selectCurrentDate:(BOOL )animation{
    [self calculateCurrentIndex: self.mCurrentDate];
    
    if (self.mCurrentYear < self.mMinYear) {
        return;
    }
    
    self.mYearIndex = self.mCurrentYear - self.mMinYear;
    
    [self.mDatePicker reloadAllComponents];
    
    if (self.datePickerMode == GXGDatePickerModeDateAndTime) {
        [self resetMonth];
        [self resetDay];
        [self resetHour];
        [self resetMinute];
        
        [self.mDatePicker selectRow:self.mYearIndex inComponent:0 animated:animation];
        [self.mDatePicker selectRow:self.mMonthIndex inComponent:1 animated:animation];
        [self.mDatePicker selectRow:self.mDayIndex inComponent:2 animated:animation];
        [self.mDatePicker selectRow:self.mHourIndex inComponent:3 animated:animation];
        [self.mDatePicker selectRow:self.mMinIndex inComponent:4 animated:animation];
        if (self.isShowAsCycle) {
            for (NSInteger component =0; component < 5; component ++) {
                    [self pickerViewLoaded:component rowCount:[self rowCountOfComponent:component]];
            }
            
        }
    }else if (self.datePickerMode == GXGDatePickerModeDate){
        [self resetMonth];
        [self resetDay];
        
        [self.mDatePicker selectRow:self.mYearIndex inComponent:0 animated:animation];
        [self.mDatePicker selectRow:self.mMonthIndex inComponent:1 animated:animation];
        [self.mDatePicker selectRow:self.mDayIndex inComponent:2 animated:animation];
        if (self.isShowAsCycle) {
            for (NSInteger component =0; component < 3; component ++) {
                [self pickerViewLoaded:component rowCount:[self rowCountOfComponent:component]];
            }
            
        }
    }else if (self.datePickerMode == GXGDatePickerModeMonthDayTime){
        [self resetMonth];
        [self resetDay];
        [self resetHour];
        [self resetMinute];
        
        [self.mDatePicker selectRow:self.mMonthIndex inComponent:0 animated:animation];
        [self.mDatePicker selectRow:self.mDayIndex inComponent:1 animated:animation];
        [self.mDatePicker selectRow:self.mHourIndex inComponent:2 animated:animation];
        [self.mDatePicker selectRow:self.mMinIndex inComponent:3 animated:animation];
        if (self.isShowAsCycle) {
            for (NSInteger component =0; component < 4; component ++) {
                [self pickerViewLoaded:component rowCount:[self rowCountOfComponent:component]];
            }
            
        }
    }else if (self.datePickerMode == GXGDatePickerModeHourMinute){
        [self resetHour];
        [self resetMinute];
        [self.mDatePicker selectRow:self.mHourIndex inComponent:0 animated:animation];
        [self.mDatePicker selectRow:self.mMinIndex inComponent:1 animated:animation];
        if (self.isShowAsCycle) {
            for (NSInteger component =0; component < 2; component ++) {
                [self pickerViewLoaded:component rowCount:[self rowCountOfComponent:component]];
            }
            
        }
    }
    
}


- (void)resetMonth{
    
    if (self.mYearIndex == 0 ) {        //最小年
        self.mMinMonth = self.mMinDateMonth;
        if (self.mYearIndex == (self.mMaxYear - self.mMinYear)){
            self.mMaxMonth = self.mMaxDateMonth;
        }else{
            self.mMaxMonth = MWDP_MONTH;
        }
    }else if (self.mYearIndex == (self.mMaxYear - self.mMinYear)){  //最大年
        self.mMaxMonth = self.mMaxDateMonth;
        self.mMinMonth = 1;
    }else{
        self.mMinMonth = 1;
        self.mMaxMonth = MWDP_MONTH;
    }
    
    self.mMonthCount = self.mMaxMonth - self.mMinMonth +1;
    
}

- (void)resetDay{
    NSInteger days = [NSDate daysInYear:[self.mYearArray[self.mYearIndex % self.mYearCount] integerValue] month:[self.mMonthArray[self.mMonthIndex%self.mMonthCount] integerValue]];
    
    if (self.mYearIndex==0 && self.mMonthIndex == 0) {                                            //最小月？
        self.mMinDay = self.mMinDateDay;
        if ((self.mMonthIndex == (self.mMaxDateMonth - self.mMinDateMonth)) && (self.mYearIndex == (self.mMaxYear - self.mMinYear))){
            self.mMaxDay = self.mMaxDateDay;
        }else{
            self.mMaxDay = days;
        }
    }else if ((self.mMonthIndex == (self.mMaxDateMonth - self.mMinDateMonth)) && (self.mYearIndex == (self.mMaxYear - self.mMinYear))){       //最大月
        self.mMaxDay = self.mMaxDateDay;
        self.mMinDay = 1;
    }else{
        self.mMinDay = 1;
        self.mMaxDay = days;
    }
    
    self.mDayCount = days;

}


- (void)resetHour{
    if (self.mYearIndex==0 && self.mMonthIndex == 0 && self.mDayIndex == 0) {
        self.mMinHour = self.mMinDateHour;
        if ((self.mMonthIndex == (self.mMaxDateMonth - self.mMinDateMonth)) && (self.mYearIndex == (self.mMaxYear - self.mMinYear)) && self.mDayIndex == (self.mMaxDateDay - self.mMinDateDay) ){
            self.mMaxHour = self.mMaxDateHour;
        }else{
            self.mMaxHour = MWDP_HOUR;
        }
    }else if ((self.mMonthIndex == (self.mMaxDateMonth - self.mMinDateMonth)) && (self.mYearIndex == (self.mMaxYear - self.mMinYear)) && self.mDayIndex == (self.mMaxDateDay - self.mMinDateDay) ){
        self.mMaxHour = self.mMaxDateHour;
        self.mMinHour = 1;
    }else{
        self.mMinHour = 1;
        self.mMaxHour = MWDP_HOUR;
    }
    
    self.mHourCount = self.mMaxHour - self.mMinHour + 1 ;
}


- (void)resetMinute{
    if (self.mYearIndex==0 && self.mMonthIndex == 0 && self.mDayIndex == 0 && self.mHourIndex == 0) {
        self.mMinMinute = self.mMinDateMinute;
        if ((self.mMonthIndex == (self.mMaxDateMonth - self.mMinDateMonth)) && (self.mYearIndex == (self.mMaxYear - self.mMinYear)) && self.mDayIndex == (self.mMaxDateDay - self.mMinDateDay)  && self.mHourIndex == (self.mMaxDateHour - self.mMinDateHour)){
            self.mMaxMinute = self.mMaxDateMinute;
        }else{
            self.mMaxMinute = MWDP_MINUTE;
        }
    }else if ((self.mMonthIndex == (self.mMaxDateMonth - self.mMinDateMonth)) && (self.mYearIndex == (self.mMaxYear - self.mMinYear)) && self.mDayIndex == (self.mMaxDateDay - self.mMinDateDay)  && self.mHourIndex == (self.mMaxDateHour - self.mMinDateHour)){
        self.mMaxMinute = self.mMaxDateMinute;
        self.mMinMinute = 1;
    }else{
        self.mMinMinute = 1;
        self.mMaxMinute = MWDP_MINUTE;
    }
    
    self.mMinuteCount = self.mMaxMinute - self.mMinMinute + 1 ;
}


//实现循环
-(void)pickerViewLoaded: (NSInteger)component rowCount:(NSInteger)rowCount {
    NSUInteger max = 16384;
    NSUInteger base10 = (max / 2) - (max / 2) % rowCount;
    [self.mDatePicker selectRow:[self.mDatePicker selectedRowInComponent:component] % rowCount + base10 inComponent:component animated:NO];
}


- (CGFloat)calculatePickerViewHeight:(NSInteger)component{
    NSInteger count = 0;
    CGFloat result = 0;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat usedWidth = 0;
    
    if (self.datePickerMode == GXGDatePickerModeDateAndTime) {
        count = 5;
        usedWidth = screenWidth - (count-1) * MWDP_Space;
        CGFloat ratio = 1./count;
        if (component==0) {
            result = usedWidth*ratio * 1.4;
        }else {
            result = usedWidth*ratio * 0.9;
        }
        
    }else if (self.datePickerMode == GXGDatePickerModeMonthDayTime){
        count = 4;
        usedWidth = screenWidth - (count-1) * MWDP_Space;
        CGFloat ratio = 1./count;
        result = usedWidth*ratio ;
    }else if (self.datePickerMode == GXGDatePickerModeDate){
        count = 4;
        usedWidth = screenWidth - (count-1) * MWDP_Space;
        CGFloat ratio = 1./count;
        if (component==0) {
            result = usedWidth*ratio * 1.4;
        }else {
            result = usedWidth*ratio * 1.3 ;
        }
    }else if(self.datePickerMode == GXGDatePickerModeHourMinute) {
        count = 2;
        usedWidth = screenWidth - (count-1) * MWDP_Space;
        CGFloat ratio = 1./count;
        result = usedWidth*ratio ;
    }
    
    return result;
}


- (UIView *)viewForDatePickerRow:(NSInteger)row component:(NSInteger)component reuseView:(UIView *)view{
    UILabel *titleLab = (UILabel *)view;
    if (!titleLab) {
        titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentCenter;
    }
    
    //需要改变的
    titleLab.textColor = self.datePickerTextColor;
    titleLab.font = self.datePickerTextFont;
    
    NSString *title = @"";
    
    row = row % [self rowCountOfComponent:component];
    
    if (self.datePickerMode == GXGDatePickerModeDateAndTime) {
        if (component==0) {
            //年
            title = [NSString stringWithFormat:@"%@年",self.mYearArray[row]];
        }else if (component==1){
            //月
            title = [NSString stringWithFormat:@"%@月",self.mMonthArray[row]];
        }else if (component==2){
            //日
            title = [NSString stringWithFormat:@"%@日",self.mDayArray[row]];
        }else if (component==3){
            title = [NSString stringWithFormat:@"%@时",self.mHourArray[row]];
        }else if (component==4){
            title = [NSString stringWithFormat:@"%@分",self.mMinArray[row]];
        }
        
    }else if (self.datePickerMode == GXGDatePickerModeMonthDayTime){
        if (component==0) {
            title = [NSString stringWithFormat:@"%@月",self.mMonthArray[row]];
        }else if (component==1){
            title = [NSString stringWithFormat:@"%@日",self.mDayArray[row]];
        }else if (component==2){
            
            title = [NSString stringWithFormat:@"%@时",self.mHourArray[row]];
        }else if (component==3){
            title = [NSString stringWithFormat:@"%@分",self.mMinArray[row]];
        }
    }else if (self.datePickerMode == GXGDatePickerModeDate){
        if (component==0) {
            //年
            title = [NSString stringWithFormat:@"%@年",self.mYearArray[row]];
        }else if (component==1){
            //月
            title = [NSString stringWithFormat:@"%@月",self.mMonthArray[row]];
        }else if (component==2){
            //日
            title = [NSString stringWithFormat:@"%@日",self.mDayArray[row]];
        }
    }else if(self.datePickerMode == GXGDatePickerModeHourMinute) {
        if (component==0) {
            //年
            title = [NSString stringWithFormat:@"%@时",self.mHourArray[row]];
        }else if (component==1){
            //月
            title = [NSString stringWithFormat:@"%@分",self.mMinArray[row]];
        }
    }
    
    
    titleLab.text = title;
    return titleLab;
}


- (void)selectPickerView:(NSInteger)row component:(NSInteger)component{
    NSDate *resultDate;
    NSString *year ;
    NSString *month ;
    NSString *day;
    NSString *hour;
    NSString *minute;
    
    row = row % [self rowCountOfComponent:component];
    
    
    if (self.datePickerMode == GXGDatePickerModeDateAndTime) {
        if (component==0) {
            self.mYearIndex = row;
            [self resetMonth];
        }else if (component==1){
            self.mMonthIndex = row;
            [self resetDay];
        }else if (component==2){
            self.mDayIndex = row;
            [self resetHour];
        }else if (component==3){
            self.mHourIndex = row;
            [self resetMinute];
        }else if (component==4){
            self.mMinIndex = row;
        }
    }else if (self.datePickerMode == GXGDatePickerModeDate){
        if (component==0) {
            self.mYearIndex = row;
            [self resetMonth];
        }else if (component==1){
            self.mMonthIndex = row;
            [self resetDay];
            
        }else if (component==2){
            
            self.mDayIndex = row;
        }
    }else if (self.datePickerMode == GXGDatePickerModeMonthDayTime){
        if (component==0) {
            self.mMonthIndex = row;
            [self resetDay];
        }else if (component==1){
            self.mDayIndex = row;
            [self resetHour];
            
        }else if (component==2){
            self.mHourIndex = row;
            [self resetMinute];
        }else if (component==3){
            self.mMinIndex = row;
        }
    }else if (self.datePickerMode == GXGDatePickerModeHourMinute){
        if (component==0) {
            self.mHourIndex = row;
            [self resetMinute];
        }else if (component==1){
            self.mMinIndex = row;
        }
    }
    
    year = self.mYearArray[self.mYearIndex % self.mYearCount];
    month = self.mMonthArray[self.mMonthIndex%self.mMonthCount];
    day = self.mDayArray[self.mDayIndex%(self.mMaxDay - self.mMinDay + 1)];
    hour = self.mHourArray[self.mHourIndex%self.mHourCount];
    minute = self.mMinArray[self.mMinIndex%self.mMinuteCount];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
    resultDate = [NSDate dateFrom:dateStr format:@"yyyy-MM-dd HH:mm" timeZone:self.timeZone];
    self.mSelectedDate = resultDate;
}


- (NSInteger)rowCountOfComponent:(NSInteger)component{
    if (component==0) {
        if (self.datePickerMode == GXGDatePickerModeMonthDayTime) {
            return self.mMonthArray.count;
        }else if (self.datePickerMode == GXGDatePickerModeHourMinute){
            return self.mHourArray.count;
        }
        return self.mYearArray.count;
    }else if (component==1){
        if (self.datePickerMode == GXGDatePickerModeMonthDayTime) {
            return self.mDayArray.count;
        }else if (self.datePickerMode == GXGDatePickerModeHourMinute){
            return self.mMinArray.count;
        }
        return self.mMonthArray.count;
    }else if (component==2){
        if (self.datePickerMode == GXGDatePickerModeMonthDayTime) {
            return self.mHourArray.count;
        }
        return self.mDayArray.count;
    }else if (component == 3){
        if (self.datePickerMode == GXGDatePickerModeMonthDayTime) {
            return self.mMinArray.count;
        }
        return self.mHourArray.count;
    }else if (component==4){
        return self.mMinArray.count;
    }
    return 0;
}


- (void)calculateCurrentIndex:(NSDate *)date{
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:self.timeZone];
    NSDateComponents *components = [cal components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute ) fromDate:date?[date dateFromTimeZone:self.timeZone toZone:[NSTimeZone timeZoneForSecondsFromGMT:0]] :[NSDate date]];
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger hour = components.hour;
    NSInteger minute = components.minute;
    
    NSInteger days = [NSDate daysInYear:year month:month];
    
    self.mCurrentYear = year;
    
    if (self.mCurrentYear == self.mMinYear) {
        self.mMonthIndex = month - self.mMinDateMonth;
    }else if (self.mCurrentYear == self.mMaxYear){
        self.mMonthIndex = self.mMaxDateMonth - month;
    }else{
        self.mMonthIndex = month-1;
    }
    
    if (self.mCurrentYear == self.mMinYear && month == self.mMinDateMonth) {
        self.mDayIndex = day - self.mMinDateDay;
    }else if (self.mCurrentYear == self.mMaxYear && month == self.mMaxDateMonth){
        self.mDayIndex = days - day;
    }else{
        self.mDayIndex = day-1;
    }
    
    if (self.mCurrentYear == self.mMinYear && month == self.mMinDateMonth && day == self.mMinDateDay )  {
        self.mHourIndex = (hour - self.mMinDateHour < 0) ?0 : hour - self.mMinDateHour;
    }else if (self.mCurrentYear == self.mMaxYear && month == self.mMaxDateMonth && day == self.mMaxDateDay){
        self.mHourIndex = (self.mMaxDateHour - hour < 0) ? 0 : self.mMaxDateHour - hour;
    }else{
        self.mHourIndex = hour-1 < 0 ? 0 : hour - 1;
    }
    
    
    
    if (self.mCurrentYear == self.mMinYear && month == self.mMinDateMonth && day == self.mMinDateDay && hour == self.mMinDateHour) {
        self.mMinIndex = minute - self.mMinDateMinute;
    }else if (self.mCurrentYear == self.mMaxYear && month == self.mMaxDateMonth && day == self.mMaxDateDay && hour == self.mMaxDateHour){
        self.mMinIndex = minute - self.mMaxDateMinute;
    }else{
        self.mMinIndex = minute-1 ;
    }
    
    self.mDayCount = days;

}


#pragma mark - Actions
- (void)actionCancel:(UIButton *)btn{
    [self dissmissDatePicker];
}

- (void)actionDone:(UIButton *)btn{
    [self dissmissDatePicker];
    if (self.selectHandler) {
        self.selectHandler(self.mSelectedDate?self.mSelectedDate:[[NSDate date] dateWithTimeZone:self.timeZone]);
    }
    
}

- (void)changeSelectDate:(UIDatePicker *)datePicker{
   self.mSelectedDate =  datePicker.date;
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self dissmissDatePicker];
}


#pragma mark- UIPickerViewDelegate 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.datePickerMode == GXGDatePickerModeDate) {
        return 3;
    }else if (self.datePickerMode == GXGDatePickerModeHourMinute){
        return 2;
    }else if (self.datePickerMode == GXGDatePickerModeMonthDayTime){
        return 4;
    }
    return 5;
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.isShowAsCycle) {
        return 16384;
    }
    
    return [self rowCountOfComponent:component];

}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return  [self calculatePickerViewHeight:component];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    return [self viewForDatePickerRow:row component:component reuseView:view];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.isShowAsCycle) {
        [self pickerViewLoaded:component rowCount:[self rowCountOfComponent:component]];
    }
    
    [self selectPickerView:row component:component];
    
}




#pragma mark - Getter

- (UIToolbar *)mToolBar{
    if (!_mToolBar) {
        _mToolBar= [[UIToolbar alloc] init];
        
        _mToolBar.barStyle = UIBarStyleDefault;
        [_mToolBar sizeToFit];
        [_mToolBar setBackgroundColor:[UIColor whiteColor]];
        _mToolBar.layer.borderWidth = 0.35f;
        _mToolBar.layer.borderColor = [[UIColor colorWithWhite:.8 alpha:1.0] CGColor];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [cancelBtn addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [cancelBtn setTitleColor:[UIColor gxg_colorWithHex:@"#559dc5"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        
        UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [doneBtn addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setTitleColor:[UIColor gxg_colorWithHex:@"#559dc5"] forState:UIControlStateNormal];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];

        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 5;
        
        [_mToolBar setItems:[NSArray arrayWithObjects:fixedSpace,cancelButton,flexSpace,doneBtnItem,fixedSpace, nil] animated:YES];

    }
    return _mToolBar;
}

- (UIPickerView *)mDatePicker{
    if (!_mDatePicker) {
        _mDatePicker = [[UIPickerView alloc] init];
        _mDatePicker.backgroundColor = self.datePickerBackgroundColor;
        _mDatePicker.showsSelectionIndicator = YES;
        _mDatePicker.delegate = self;
        _mDatePicker.dataSource = self;
    
    }

    return _mDatePicker;
}


- (UIView *)mContenView{
    if (!_mContenView) {
        _mContenView = [[UIView alloc] init];
        
        [_mContenView addSubview:self.mToolBar];
        [_mContenView addSubview:self.mDatePicker];
        
        self.mToolBar.translatesAutoresizingMaskIntoConstraints = NO;
        self.mDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
        [_mContenView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolBar]|" options:0 metrics:@{} views:@{@"toolBar":self.mToolBar}]];
        
        [_mContenView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[datePicker]|" options:0 metrics:@{} views:@{@"datePicker":self.mDatePicker}]];
        
        [_mContenView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolBar(toolHeight)]-0-[datePicker(dateHeight)]-0-|" options:0 metrics:@{@"toolHeight":@(MW_ToolBarHeight),@"dateHeight":@(MW_DatePickerHeight)} views:@{@"datePicker":self.mDatePicker,@"toolBar":self.mToolBar}]];
    }
    [_mContenView layoutIfNeeded];
   
    return _mContenView;
}



#pragma mark - Setter

- (void)setMMonthCount:(NSInteger)mMonthCount{
    [self.mMonthArray removeAllObjects];
    _mMonthCount = mMonthCount;
    
    for (NSInteger day = self.mMinMonth; day<= self.mMaxMonth; day++) {
        [self.mMonthArray addObject:[NSString stringWithFormat:@"%02ld",(long)day]];
    }
    
    if (self.datePickerMode == GXGDatePickerModeDate  || self.datePickerMode == GXGDatePickerModeDateAndTime) {
        [self.mDatePicker reloadComponent:1];
    }else if (self.datePickerMode == GXGDatePickerModeMonthDayTime){
        [self.mDatePicker reloadComponent:0];
    }
    
}

- (void)setMYearCount:(NSInteger)mYearCount{
    if (mYearCount<0) {
        return;
    }
    _mYearCount = mYearCount;
}

- (void)setMDayCount:(NSInteger)mDayCount{
    
    [self.mDayArray removeAllObjects];
    _mDayCount = mDayCount;
    for (NSInteger day = self.mMinDay; day<= self.mMaxDay; day++) {
        [self.mDayArray addObject:[NSString stringWithFormat:@"%02ld",(long)day]];
    }
    if (self.datePickerMode == GXGDatePickerModeDate  || self.datePickerMode == GXGDatePickerModeDateAndTime){
        [self.mDatePicker reloadComponent:2];
    }else if (self.datePickerMode == GXGDatePickerModeMonthDayTime){
        [self.mDatePicker reloadComponent:1];
    }
    
}


- (void)setMHourCount:(NSInteger)mHourCount{
    [self.mHourArray removeAllObjects];
    _mHourCount = mHourCount;
    
    for (NSInteger day = self.mMinHour; day<= self.mMaxHour; day++) {
        [self.mHourArray addObject:[NSString stringWithFormat:@"%02ld",(long)day]];
    }
    if (self.datePickerMode == GXGDatePickerModeDateAndTime) {
        [self.mDatePicker reloadComponent:3];
    }else if(self.datePickerMode == GXGDatePickerModeMonthDayTime){
        [self.mDatePicker reloadComponent:2];
    }else if (self.datePickerMode == GXGDatePickerModeHourMinute) {
        [self.mDatePicker reloadComponent:0];
    }
    
}


- (void)setMMinuteCount:(NSInteger)mMinuteCount{
    [self.mMinArray removeAllObjects];
    _mMinuteCount = mMinuteCount;
    
    for (NSInteger day = self.mMinMinute; day<= self.mMaxMinute; day++) {
        [self.mMinArray addObject:[NSString stringWithFormat:@"%02ld",(long)day]];
    }
    if (self.datePickerMode == GXGDatePickerModeDateAndTime) {
        [self.mDatePicker reloadComponent:4];
    }else if(self.datePickerMode == GXGDatePickerModeMonthDayTime){
        [self.mDatePicker reloadComponent:3];
    }else if (self.datePickerMode == GXGDatePickerModeHourMinute) {
        [self.mDatePicker reloadComponent:1];
    }
    
}

- (void)setMCurrentDate:(NSDate *)mCurrentDate{
    _mCurrentDate = [mCurrentDate dateWithTimeZone:self.timeZone];
    [self selectCurrentDate:NO];
}

- (void)setMCurrentDate:(NSDate *)mCurrentDate animation:(BOOL)animation{
    _mCurrentDate = mCurrentDate;
    [self selectCurrentDate:animation];
}


- (void)setMinimumDate:(NSDate *)minimumDate{
    if (self.maximumDate && [minimumDate laterThan:self.maximumDate]) {
        return;
    }
    if (!minimumDate) {
        minimumDate = [NSDate dateWithTimeIntervalSince1970:0] ;
    }
    
    _minimumDate = minimumDate;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:self.timeZone];
    NSDateComponents *components = [cal components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute) fromDate:_minimumDate];
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger hour = components.hour;
    NSInteger minute = components.minute;
    
    self.mMinYear = year;
    self.mMinDateMonth = month;
    self.mMinDateDay = day;
    self.mMinDateHour = hour;
    self.mMinDateMinute = minute;
    
    if (self.maximumDate) {
        [self resetDateDatas];
        [self selectCurrentDate:NO];
    }
   
}

- (void)setMaximumDate:(NSDate *)maximumDate{
    if (self.minimumDate && [maximumDate earlyThan:self.minimumDate]) {
        return;
    }
    if (!maximumDate) {
        maximumDate = [NSDate dateFrom:@"2099-12-31" format:@"yyyy-MM-dd"];
    }
    
    _maximumDate = maximumDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:self.timeZone];
    NSDateComponents *components = [cal components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute) fromDate:_maximumDate];
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger hour = components.hour;
    NSInteger minute = components.minute;
    
    self.mMaxYear = year;
    self.mMaxDateMonth = month;
    self.mMaxDateDay = day;
    self.mMaxDateHour = hour;
    self.mMaxDateMinute = minute;
    
    if (self.minimumDate) {
        [self resetDateDatas];
        [self selectCurrentDate:NO];
    }
}


- (void)setDatePickerMode:(GXGDatePickerMode)datePickerMode{
    if (datePickerMode == _datePickerMode) {
        return;
    }
    _datePickerMode = datePickerMode;
    
    [self resetDateDatas];
    [self selectCurrentDate:NO];
}

- (void)setIsShowAsCycle:(BOOL)isShowAsCycle{
    _isShowAsCycle = isShowAsCycle;
    
    [self.mDatePicker reloadAllComponents];
    [self selectCurrentDate:NO];
}

- (void)setTimeZone:(NSTimeZone *)timeZone{
    
    if (_timeZone!=nil) {
        NSTimeZone *oldTimeZone = _timeZone;
        self.maximumDate = _maximumDate;
        self.minimumDate = _minimumDate;
        self.mCurrentDate = [self.mCurrentDate dateFromTimeZone:oldTimeZone toZone:timeZone];
    }
    
    _timeZone = timeZone;
    
    [self resetDateDatas];
    [self selectCurrentDate:NO];
}

- (void)setDatePickerTextFont:(UIFont *)datePickerTextFont{
    _datePickerTextFont = datePickerTextFont;
    [self.mDatePicker reloadAllComponents];
}

- (void)setDatePickerTextColor:(UIColor *)datePickerTextColor{
    _datePickerTextColor = datePickerTextColor;
    [self.mDatePicker reloadAllComponents];
}

- (void)setDatePickerBackgroundColor:(UIColor *)datePickerBackgroundColor{
    _datePickerBackgroundColor = datePickerBackgroundColor;
    
    [self.mDatePicker setBackgroundColor:datePickerBackgroundColor];
}

@end


@implementation NSDate (GXGDatePicker)

- (NSString *)dateFormat:(NSString *)formatter timeZone:(NSTimeZone *)zone{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:zone];
    [format setDateFormat:formatter];
    NSString *dateString = [format stringFromDate:self];
    return dateString;
}

- (NSString *)dateFormat:(NSString *)formatter{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    NSString *dateString = [format stringFromDate:self];
    return dateString;
}

+ (NSDate *)dateFrom:(NSString *)dateString format:(NSString *)formatter timeZone:(NSTimeZone *)zone{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:zone];
    [format setDateFormat:formatter];
    NSDate *resultDate = [format dateFromString:dateString];
    return resultDate;
}

+ (NSDate *)dateFrom:(NSString *)dateString format:(NSString *)formatter{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    NSDate *resultDate = [format dateFromString:dateString];
    return resultDate;
}

- (NSDate *)dateWithTimeZone:(NSTimeZone *)zone{
    NSInteger interval = [zone secondsFromGMT];
    return  [self dateByAddingTimeInterval:interval];
}

- (NSDate *)dateFromTimeZone:(NSTimeZone *)zone toZone:(NSTimeZone *)zone1{
    NSTimeInterval interval = [zone secondsFromGMT];
    NSDate *GMTDate = [self dateByAddingTimeInterval:-interval];
    NSDate *resultDate = [GMTDate dateWithTimeZone:zone1];
    return resultDate;
}

+ (NSInteger)daysInYear:(NSInteger)year month:(NSInteger)imonth{
    
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
        return 29;
    if(year%100 == 0)
        return 28;
    return 29;
}

- (BOOL)laterThan:(NSDate *)date{
    NSComparisonResult result = [self compare:date];
    if (result==NSOrderedDescending) {
        return YES;
    }
    return NO;
}

- (BOOL)earlyThan:(NSDate *)date{
    NSComparisonResult result = [self compare:date];
    if (result==NSOrderedAscending) {
        return YES;
    }
    return NO;
}

@end


@implementation UIColor (GXGDatePicker)

+ (UIColor *) gxg_colorWithHex:(NSString*) hex
{
    return [UIColor gxg_colorWithHex:hex alpha:1.f];
}

+ (UIColor *) gxg_colorWithHex:(NSString*) hex alpha:(CGFloat)alpha{
    if ([hex hasPrefix:@"#"]) {
        hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != hex)
    {
        NSScanner *scanner = [NSScanner scannerWithString:hex];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:alpha];
    return result;
}

@end
