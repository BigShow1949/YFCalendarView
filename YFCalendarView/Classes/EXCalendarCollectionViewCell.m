//
//  EXCalendarCollectionViewCell.m
//  EXCalendar
//
//  Created by Eric on 2018/11/8.
//  Copyright © 2018 ex. All rights reserved.
//

#import "EXCalendarCollectionViewCell.h"
#import "EXCalendarApperance.h"
#import "EXCalendarCircleView.h"

@interface EXCalendarCollectionViewCell ()

/**
 Date label.
 */
@property (nonatomic, strong) UILabel *dateLabel;

/**
 Selected or today circle.
 */
@property (nonatomic, strong) EXCalendarCircleView *selectedCircle;

/**
 Specified circle.
 */
@property (nonatomic, strong) EXCalendarCircleView *eventCircle;

@end


@implementation EXCalendarCollectionViewCell
#pragma mark - InitView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createContentView];
    }
    return self;
}


- (void)createContentView {
    CGFloat circleWH = 30;
    CGFloat circleX = (self.frame.size.width - circleWH)/2;
    CGFloat circleY = (self.frame.size.height - circleWH)/2;
//    NSLog(@"width = %f , height = %f", self.frame.size.width, self.frame.size.height);
    EXCalendarCircleView *selectedCircle = [[EXCalendarCircleView alloc] initWithRadius:14];
//    selectedCircle.backgroundColor = [UIColor redColor];
//    selectedCircle.frame = CGRectMake(circleX, circleY, circleWH, circleWH); // 还是计算得不对
    selectedCircle.frame = CGRectMake(10, 4, 30, 30);
    self.selectedCircle = selectedCircle;
    [self addSubview:_selectedCircle];
    
    EXCalendarCircleView *eventCircle = [[EXCalendarCircleView alloc] initWithRadius:14];
    eventCircle.frame = CGRectMake(circleX, circleY, circleWH, circleWH);
    eventCircle.fillColor = [EXCalendarApperance apperance].dayEventColor;
    eventCircle.strokeColor = [EXCalendarApperance apperance].dayEventColor;
    eventCircle.hidden = YES;
    self.eventCircle = eventCircle;
    [self addSubview:_eventCircle];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [EXCalendarApperance apperance].dayTextFont;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [EXCalendarApperance apperance].dayTextColor;
//    dateLabel.backgroundColor = [UIColor blueColor];
    self.dateLabel = dateLabel;
    [self addSubview:_dateLabel];
    
    if (![EXCalendarApperance apperance].hiddenGridLine) {
        [self createGridLine];
    }
}


- (void)createGridLine {
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, -0.5, self.frame.size.width, 1)];
    topLine.backgroundColor = [UIColor colorWithRed:181/255 green:181/255 blue:181/255 alpha:1];
    [self addSubview:topLine];
    
    UILabel *leftLine = [[UILabel alloc] initWithFrame:CGRectMake(-0.5, 0, 1, self.frame.size.height)];
    leftLine.backgroundColor = [UIColor colorWithRed:181/255 green:181/255 blue:181/255 alpha:1];
    [self addSubview:leftLine];
    
    UILabel *rightLine = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 0.5, 0, 1, self.frame.size.height)];
    rightLine.backgroundColor =[UIColor colorWithRed:181/255 green:181/255 blue:181/255 alpha:1];
    [self addSubview:rightLine];
    
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 0.5, self.frame.size.width, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:181/255 green:181/255 blue:181/255 alpha:1];
    [self addSubview:bottomLine];
}


#pragma mark - LoadData
- (void)loadData:(EXCalendarDayItem *)model {
    if (!model) {
        return;
    }
    
    self.viewData = model;
    
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [EXCalendarApperance apperance].calendar.timeZone;
        [dateFormatter setDateFormat:@"dd"];
    }
    
    CGPoint origin = self.dateLabel.frame.origin;
    self.dateLabel.text = [dateFormatter stringFromDate:model.date];
    CGSize size = [self sizeForLabel:_dateLabel];
//    self.dateLabel.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
    self.dateLabel.frame = CGRectMake(16, 10, size.width, size.height);

    CGPoint point = _selectedCircle.center;
    point.x = _dateLabel.center.x;
    self.selectedCircle.center = point;
    self.eventCircle.center = point;
    if (model.isSelected) {
        NSLog(@"这个选中了 ：%@", model.date);
    }
    
    if ([self isToday]) {
        NSLog(@"model.date = %@", model.date);
    }

    self.isSelected = model.isSelected;
}


- (void)loadEvent:(NSDate *)date {
    if (date) {
        self.eventCircle.hidden = NO;
    } else {
        self.eventCircle.hidden = YES;
    }
}


- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.viewData.isSelected = isSelected;
    
    if(isSelected){
        if(!self.viewData.isOtherMonth){
            self.selectedCircle.fillColor = [EXCalendarApperance apperance].dayCircleColorSelected;
            self.selectedCircle.strokeColor = [UIColor whiteColor];
            self.dateLabel.textColor = [EXCalendarApperance apperance].dayTextColorSelected;
        }

        if ([self isToday]) {
            self.selectedCircle.strokeColor = [EXCalendarApperance apperance].dayCircleColorToday;
            self.selectedCircle.fillColor = [EXCalendarApperance apperance].dayCircleColorToday;
        }
    } else {
        self.selectedCircle.fillColor = [EXCalendarApperance apperance].dayCircleColorSelected;
        self.selectedCircle.strokeColor = [UIColor whiteColor];

        if ([self isToday]){
            self.selectedCircle.strokeColor = [EXCalendarApperance apperance].dayBorderColorToday;
            self.selectedCircle.fillColor = [UIColor whiteColor];
            self.dateLabel.textColor = [EXCalendarApperance apperance].dayTextColor;
        } else {

            if(!self.viewData.isOtherMonth ) {
                self.dateLabel.textColor = [EXCalendarApperance apperance].dayTextColor;
            } else {
                self.dateLabel.textColor = [EXCalendarApperance apperance].dayTextColorOtherMonth;
            }

            self.selectedCircle.fillColor = [UIColor whiteColor];
            self.selectedCircle.strokeColor = [UIColor whiteColor];
        }
    }
}


- (CGSize)sizeForLabel:(UILabel *)label {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil].size;
    return labelSize;
}


- (BOOL)isToday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [EXCalendarApperance apperance].calendar.timeZone;
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *gmtDate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:gmtDate];
    NSDate *currentDate = [gmtDate  dateByAddingTimeInterval: interval];
//    NSLog(@"currentDate = %@, self.viewData.date = %@", currentDate, self.viewData.date);
    return [[dateFormatter stringFromDate:self.viewData.date] isEqualToString:[dateFormatter stringFromDate:currentDate]];
}

@end
