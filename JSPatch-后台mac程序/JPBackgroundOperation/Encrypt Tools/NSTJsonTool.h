//
//  NSTJsonTool.h
//  SpaceHome
//
//  Created by ccSunday on 15/2/13.
//  Copyright (c) 2015年 ccSunday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTJsonTool : NSObject

//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
+ (NSDictionary*)getObjectData:(id)obj;

//将getObjectData方法返回的NSDictionary转化成JSON
+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;

//将NSDictionary转化成JSON串
+ (NSString*)getDicJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;

//将Json的NSData数据转成NSDictionary
+ (NSDictionary*)getDictionary:(NSData*)obj options:(NSJSONReadingOptions)options error:(NSError**)error;

//直接通过NSLog输出getObjectData方法返回的NSDictionary
+ (void)print:(id)obj;

@end
