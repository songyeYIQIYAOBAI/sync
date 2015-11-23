//
//  FormDescriptor.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-28.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FormDescriptor.h"
#import "FormRowDescriptor.h"
@implementation FormDescriptor
-(void)dealloc{
    
    [_rowDataSoure release];
    [super dealloc];
}
-(NSMutableArray *)rowDataSoure{
    
    if (!_rowDataSoure) {
     
        _rowDataSoure = [[NSMutableArray alloc]init];
    }
    
    return _rowDataSoure;
}

-(NSDictionary *)formValues{
    
    if (![self.rowDataSoure count] >0) {
        return nil;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    for (FormRowDescriptor *rowDes in self.rowDataSoure) {
        
        [dic setObject:rowDes.contentText forKey:rowDes.title];
        
    }
    
    return [dic autorelease];
}

-(NSString*)showString{
    
    NSMutableString *string=[[[NSMutableString alloc]init]autorelease];
    for (FormRowDescriptor *rowDes in self.rowDataSoure) {
        
        [string appendFormat:@"%@%@\n",rowDes.title,rowDes.contentText];
        
    }
         
    return string;
    
    
}
@end
