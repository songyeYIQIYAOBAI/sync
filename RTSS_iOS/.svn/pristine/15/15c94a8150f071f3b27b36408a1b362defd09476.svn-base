//
//  FormRowDescriptor.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-28.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FormRowDescriptor.h"

@interface FormRowDescriptor ()

@property(nonatomic,readwrite,copy)NSString *cellClassString;

@end

@implementation FormRowDescriptor

#pragma mark --Set Property


-(void)setRowType:(FormRowType)rowType{
    
    _rowType = rowType;
    switch (rowType) {
        case FormRowTypeSelect:{
            self.cellClassString = @"FormPickerCell";
             break;
        }
        case FormRowTypeTextField:{
            self.cellClassString = @"FormTextFieldCell";
            break;
        }
        case FormRowTypeTextView:{
            self.cellClassString = @"FormTextViewCell";
            break;
        }
        default:
           self.cellClassString = @"FormPickerCell";
            break;
    }
}
-(void)setPickerArray:(NSArray *)pickerArray{
    
    if (_pickerArray != pickerArray) {
        
        [_pickerArray release];
        _pickerArray = [pickerArray retain];
        
        if ([_pickerArray count] > 0) {
            self.contentText = [_pickerArray objectAtIndex:0];
        }
    }
    

}

-(instancetype)initWithRowType:(FormRowType)type Title:(NSString *)title{
    
    self = [super init];
    
    if (self) {
        self.rowType = type;
        self.title = title;
        self.contentText = @"";
        self.tag = @"";
    }
    return self;
}


@end
