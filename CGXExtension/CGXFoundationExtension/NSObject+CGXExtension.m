//
//  NSObject+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "NSObject+CGXExtension.h"
#import <objc/message.h>
#import "NSString+CGXExtension.h"

#define force_inline __inline__ __attribute__((always_inline))

//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html

typedef NS_ENUM(NSInteger, CGXEncodingType) {
    
    CGXEncodingTypeUnknown,
    
    //下面这些支持自动赋值
    CGXEncodingTypeString,
    CGXEncodingTypeMutableString,
    CGXEncodingTypeArray,
    CGXEncodingTypeMutableArray,
    CGXEncodingTypeDictionary,
    CGXEncodingTypeMutableDictionary,
    CGXEncodingTypeNumber,
    CGXEncodingTypeDate,    //仅支持服务器返回数字 值为timeIntervalSince1970
    CGXEncodingTypeObject,
    CGXEncodingTypeInt32,
    CGXEncodingTypeUInt32,
    CGXEncodingTypeFloat,
    CGXEncodingTypeDouble,
    CGXEncodingTypeBool,
    CGXEncodingTypeBoolean,
    
    //下面这些不支持自动赋值
    CGXEncodingTypeVoid,
    CGXEncodingTypeInt8     = CGXEncodingTypeBool,
    CGXEncodingTypeUInt8    = CGXEncodingTypeBoolean,
    CGXEncodingTypeInt16,
    CGXEncodingTypeUInt16,
    CGXEncodingTypeInt64,
    CGXEncodingTypeUInt64,
    CGXEncodingTypeLongDouble,
    CGXEncodingTypeClass,
    CGXEncodingTypeSEL,
    CGXEncodingTypeCString,
    CGXEncodingTypePointer,
    CGXEncodingTypeCArray,
    CGXEncodingTypeUnion,
    CGXEncodingTypeStruct,
    CGXEncodingTypeBlock,
};

typedef NS_OPTIONS(NSUInteger, CGXPropertyType) {
    
    CGXPropertyTypeUnknown      = 0,
    
    CGXPropertyTypeNonatomic    = 1 << 1,
    
    CGXPropertyTypeCopy         = 1 << 2,
    CGXPropertyTypeRetain       = 2 << 2,
    CGXPropertyTypeWeak         = 3 << 2,
    
    CGXPropertyTypeCustomGetter = 1 << 4,
    CGXPropertyTypeCustomSetter = 2 << 4,
    CGXPropertyTypeDynamic      = 3 << 4,
    
    CGXPropertyTypeReadonly     = 1 << 6,
};

CGXEncodingType CGXGetEncodingType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) {
        return CGXEncodingTypeUnknown;
    }
    
    size_t len = strlen(type);
    if (len == 0) {
        return CGXEncodingTypeUnknown;
    }
    
    switch (*type) {
        case 'v': return CGXEncodingTypeVoid;
        case 'B': return CGXEncodingTypeBool;
        case 'c': return CGXEncodingTypeBool;
        case 'C': return CGXEncodingTypeBoolean;
        case 's': return CGXEncodingTypeInt16;
        case 'S': return CGXEncodingTypeUInt16;
        case 'i': return CGXEncodingTypeInt32;
        case 'I': return CGXEncodingTypeUInt32;
        case 'l': return CGXEncodingTypeInt32;
        case 'L': return CGXEncodingTypeUInt32;
        case 'q': return CGXEncodingTypeInt64;
        case 'Q': return CGXEncodingTypeUInt64;
        case 'f': return CGXEncodingTypeFloat;
        case 'd': return CGXEncodingTypeDouble;
        case 'D': return CGXEncodingTypeLongDouble;
        case '*': return CGXEncodingTypeCString;
        case '[': return CGXEncodingTypeCArray;
        case '(': return CGXEncodingTypeUnion;
        case '{': return CGXEncodingTypeStruct;
        case '^':
        {
            if (len == 2) {
                if (*(type + 1) == '#') {
                    return CGXEncodingTypeClass;
                } else if (*(type + 1) == ':') {
                    return CGXEncodingTypeSEL;
                }
            } else {
                return CGXEncodingTypePointer;
            }
        }
        case '@':
        {
            if (len == 2 && *(type + 1) == '?') {
                return CGXEncodingTypeBlock;
            } else {
                return CGXEncodingTypeObject;
            }
        }
        default: return CGXEncodingTypeUnknown;
    }
    return CGXEncodingTypeUnknown;
}

//根据对象的属性和类型赋值
static force_inline void CGXSetPropertyValue(NSObject *object, SEL setter, CGXEncodingType encodingType, id value, Class objectClass) {
    
    if (!object || !setter || (encodingType == CGXEncodingTypeUnknown) || !value || [value isKindOfClass:[NSNull class]]) {
        return;
    }
    
    switch (encodingType) {
        case CGXEncodingTypeString:
        case CGXEncodingTypeMutableString:
        {
            NSString *val = nil;
            
            if ([value isKindOfClass:[NSString class]]) {
                val = value;
            } else if ([value isKindOfClass:[NSNumber class]]) {
                val = ((NSNumber *)value).stringValue;
            }
            
            if (val) {
                if (encodingType == CGXEncodingTypeString) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val);
                } else if (encodingType == CGXEncodingTypeMutableString) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val.mutableCopy);
                }
            }
        }
            break;
        case CGXEncodingTypeArray:
        case CGXEncodingTypeMutableArray:
        {
            NSMutableArray *val = nil;
            
            if (![value isKindOfClass:[NSArray class]] && [value isKindOfClass:[NSString class]]) {
                value = [value objectFromJSONString];
            }
            
            if (objectClass && [value isKindOfClass:[NSArray class]] && [(NSArray *)value count]) {
                val = [NSMutableArray array];
                
                for (id obj in value) {
                    id newObj = [objectClass objectWithData:obj];
                    if (newObj) {
                        [val addObject:newObj];
                    }
                }
                
                if (val.count) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val);
                }
            }
        }
            break;
        case CGXEncodingTypeDictionary:
        case CGXEncodingTypeMutableDictionary:
        {
            NSDictionary *val = nil;
            
            if (![value isKindOfClass:[NSDictionary class]] && [value isKindOfClass:[NSString class]]) {
                value = [value objectFromJSONString];
            }
            
            if ([value isKindOfClass:[NSDictionary class]]) {
                val = value;
            }
            
            if (val) {
                if (encodingType == CGXEncodingTypeDictionary) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val);
                } else if (encodingType == CGXEncodingTypeMutableDictionary) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val.mutableCopy);
                }
            }
        }
            break;
        case CGXEncodingTypeObject:
        {
            NSDictionary *val = nil;
            
            if ([value isKindOfClass:[NSDictionary class]]) {
                val = value;
            }
            
            if (objectClass && val) {
                ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, [objectClass objectWithData:val]);
            }
        }
            break;
        case CGXEncodingTypeNumber:
        case CGXEncodingTypeDate:
        case CGXEncodingTypeInt32:
        case CGXEncodingTypeUInt32:
        case CGXEncodingTypeFloat:
        case CGXEncodingTypeDouble:
        case CGXEncodingTypeBool:
        case CGXEncodingTypeBoolean:
        {
            NSNumber *val = nil;
            
            if ([value isKindOfClass:[NSNumber class]]) {
                val = value;
            } else if ([value isKindOfClass:[NSString class]]) {
                val = @([((NSString *)value) doubleValue]);
            }
            
            if (val) {
                switch (encodingType) {
                    case CGXEncodingTypeNumber:
                    {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val);
                    }
                        break;
                    case CGXEncodingTypeDate:
                    {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, [NSDate dateWithTimeIntervalSince1970:val.floatValue]);
                    }
                        break;
                    case CGXEncodingTypeInt32:
                    {
                        ((void (*)(id, SEL, int32_t))(void *) objc_msgSend)((id)object, setter, (int32_t)val.integerValue);
                    }
                        break;
                    case CGXEncodingTypeUInt32:
                    {
                        ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)((id)object, setter, (uint32_t)val.unsignedIntegerValue);
                    }
                        break;
                    case CGXEncodingTypeFloat:
                    {
                        ((void (*)(id, SEL, float))(void *) objc_msgSend)((id)object, setter, val.floatValue);
                    }
                        break;
                    case CGXEncodingTypeDouble:
                    {
                        ((void (*)(id, SEL, double))(void *) objc_msgSend)((id)object, setter, val.doubleValue);
                    }
                        break;
                    case CGXEncodingTypeBool:
                    {
                        ((void (*)(id, SEL, int8_t))(void *) objc_msgSend)((id)object, setter, (int8_t)val.charValue);
                    }
                        break;
                    case CGXEncodingTypeBoolean:
                    {
                        ((void (*)(id, SEL, uint8_t))(void *) objc_msgSend)((id)object, setter, (uint8_t)val.unsignedCharValue);
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        default:
            break;
    }
}

static force_inline NSDictionary* CGXGetPropertyMapDictionary(NSObject *object) {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([object respondsToSelector:@selector(propertyMap)]) {
        NSDictionary *map = [object performSelector:@selector(propertyMap)];
        if (map && [map isKindOfClass:[NSDictionary class]] && map.count) {
            return map;
        }
    }
    
#pragma clang diagnostic pop
    
    return nil;
}

#pragma mark - CGXPropertyInfo.h

@interface CGXPropertyInfo : NSObject

@property (nonatomic, assign, readonly) objc_property_t property;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) SEL getter;
@property (nonatomic, assign, readonly) SEL setter;
@property (nonatomic, assign, readonly) CGXEncodingType encodingType;
@property (nonatomic, assign, readonly) CGXPropertyType propertyType;

/** propertyMap中定义的服务器返回字段名 如果为nil 则代表服务器返回的就是name */
@property (nonatomic, strong, readwrite) NSString *mapKey;
/** 如果属性类型是数组 且propertyMap方法里有对象类型定义,则代表数组内对象的类型.或属性类型为对象,则代表对象类型 否则为nil */
@property (nonatomic, assign, readwrite) Class objectClass;

- (instancetype)initWithProperty:(objc_property_t)property;

@end

#pragma mark - CGXPropertyInfo.m

@implementation CGXPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    if (!property) return nil;
    self = [self init];
    _property = property;
    
    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    
    _propertyType = CGXPropertyTypeUnknown;
    
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++) {
        switch (attrs[i].name[0]) {
            case 'T':
            {
                if (attrs[i].value) {
                    _encodingType = CGXGetEncodingType(attrs[i].value);
                    
                    if (_encodingType == CGXEncodingTypeObject) {
                        size_t len = strlen(attrs[i].value);
                        if (len > 3) {
                            char name[len - 2];
                            name[len - 3] = '\0';
                            memcpy(name, attrs[i].value + 2, len - 3);
                            _objectClass = objc_getClass(name);
                            
                            if ([_objectClass isSubclassOfClass:[NSMutableString class]]) {
                                _encodingType = CGXEncodingTypeMutableString;
                            } else if ([_objectClass isSubclassOfClass:[NSString class]]) {
                                _encodingType = CGXEncodingTypeString;
                            } else if ([_objectClass isSubclassOfClass:[NSMutableArray class]]) {
                                _encodingType = CGXEncodingTypeMutableArray;
                            } else if ([_objectClass isSubclassOfClass:[NSArray class]]) {
                                _encodingType = CGXEncodingTypeArray;
                            } else if ([_objectClass isSubclassOfClass:[NSMutableDictionary class]]) {
                                _encodingType = CGXEncodingTypeMutableDictionary;
                            } else if ([_objectClass isSubclassOfClass:[NSDictionary class]]) {
                                _encodingType = CGXEncodingTypeDictionary;
                            } else if ([_objectClass isSubclassOfClass:[NSNumber class]]) {
                                _encodingType = CGXEncodingTypeNumber;
                            } else if ([_objectClass isSubclassOfClass:[NSDate class]]) {
                                _encodingType = CGXEncodingTypeDate;
                            }
                        }
                    }
                }
            }
                break;
            case 'R':
            {
                _propertyType |= CGXPropertyTypeReadonly;
            }
                break;
            case 'C':
            {
                _propertyType |= CGXPropertyTypeCopy;
            }
                break;
            case '&':
            {
                _propertyType |= CGXPropertyTypeRetain;
            }
                break;
            case 'N':
            {
                _propertyType |= CGXPropertyTypeNonatomic;
            }
                break;
            case 'D':
            {
                _propertyType |= CGXPropertyTypeDynamic;
            }
                break;
            case 'W':
            {
                _propertyType |= CGXPropertyTypeWeak;
            }
                break;
            case 'G':
            {
                _propertyType |= CGXPropertyTypeCustomGetter;
                if (attrs[i].value) {
                    _getter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            }
                break;
            case 'S':
            {
                _propertyType |= CGXPropertyTypeCustomSetter;
                if (attrs[i].value) {
                    _setter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            }
                break;
            default:
                break;
        }
    }
    if (attrs) {
        free(attrs);
        attrs = NULL;
    }
    
    if (_name.length) {
        if (!_getter) {
            _getter = NSSelectorFromString(_name);
        }
        if (!_setter) {
            _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]]);
        }
    }
    return self;
}

@end

#pragma mark - CGXClassInfo.h

@interface CGXClassInfo : NSObject

@property (nonatomic, assign, readonly) Class cls;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, CGXPropertyInfo *> *propertyInfos;     //对象属性信息
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *propertyMap;

+ (instancetype)classInfoWithClass:(Class)cls;
+ (instancetype)classInfoWithClassName:(NSString *)className;

@end

#pragma mark - CGXClassInfo.m

@implementation CGXClassInfo

- (instancetype)initWithClass:(Class)cls {
    if (!cls) return nil;
    self = [super init];
    _cls = cls;
    _name = NSStringFromClass(cls);
    [self initInfos];
    
    return self;
}

- (void)initInfos {
    _propertyInfos = nil;
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.cls, &propertyCount);
    if (properties) {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        _propertyInfos = propertyInfos;
        for (unsigned int i = 0; i < propertyCount; i++) {
            CGXPropertyInfo *info = [[CGXPropertyInfo alloc] initWithProperty:properties[i]];
            if (info.name) {
                propertyInfos[info.name] = info;
            }
        }
        free(properties);
    }
    
    _propertyMap = CGXGetPropertyMapDictionary([_cls new]);
    
    if (!_propertyMap.count || !_propertyInfos.count) {
        return;
    }
    
    [_propertyMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        CGXPropertyInfo *propertyInfo = [_propertyInfos objectForKey:key];
        if (propertyInfo) {
            if ([obj isKindOfClass:[NSString class]] && ((NSString *)obj).length) {
                propertyInfo.mapKey = obj;
            } else if (((propertyInfo.encodingType == CGXEncodingTypeArray) || (propertyInfo.encodingType == CGXEncodingTypeMutableArray)) && [obj isKindOfClass:[NSDictionary class]]) {
                NSString *firstKey = ((NSDictionary *)obj).allKeys.firstObject;
                id clazz = [((NSDictionary *)obj) objectForKey:firstKey];
                if ([firstKey isKindOfClass:[NSString class]] && firstKey.length && [clazz respondsToSelector:@selector(isSubclassOfClass:)]) {
                    propertyInfo.mapKey = firstKey;
                    propertyInfo.objectClass = clazz;
                }
            }
        }
    }];
}

+ (instancetype)classInfoWithClass:(Class)cls {
    if (!cls || (cls == [NSObject class])) return nil;
    static CFMutableDictionaryRef classCache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    CGXClassInfo *info = CFDictionaryGetValue(classCache, (__bridge const void *)(cls));
    
    dispatch_semaphore_signal(lock);
    if (!info) {
        info = [[CGXClassInfo alloc] initWithClass:cls];
        if (info) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    return info;
}

+ (instancetype)classInfoWithClassName:(NSString *)className {
    return [self classInfoWithClass:NSClassFromString(className)];
}

@end

//根据对象属性生成 dictionary
static force_inline NSDictionary* CGXGetPropertyValue(NSObject *object, BOOL needNullValue, BOOL useMapPropertyKey) {
    
    Class clazz = [object class];
    
    //如果某个对象的属性是数组时会用到这块代码
    if ([clazz isSubclassOfClass:[NSNull class]]) {
        return nil;
    } else if ([clazz isSubclassOfClass:[NSDate class]]) {
        return (id)@([((NSDate *)object) timeIntervalSince1970]);
    } else if ([clazz isSubclassOfClass:[NSString class]] ||
               [clazz isSubclassOfClass:[NSNumber class]] ||
               [clazz isSubclassOfClass:[NSDictionary class]]) {
        return (id)object;
    } else if ([clazz isSubclassOfClass:[NSArray class]]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (id arrObj in (NSArray *)object) {
            id newObjPV = CGXGetPropertyValue(arrObj, needNullValue, useMapPropertyKey);
            if (newObjPV) {
                [arr addObject:newObjPV];
            }
        }
        if (arr.count) {
            return (id)arr;
        }
    }
    
    CGXClassInfo *classInfo = [CGXClassInfo classInfoWithClass:[object class]];
    
    if (!classInfo.propertyInfos.count) {
        return nil;
    }
    
    NSMutableDictionary *propertyValues = [NSMutableDictionary dictionary];
    
    [classInfo.propertyInfos enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CGXPropertyInfo * _Nonnull obj, BOOL * _Nonnull stop) {
        
        id value = nil;
        
        switch (obj.encodingType) {
            case CGXEncodingTypeString:
            case CGXEncodingTypeMutableString:
            {
                value = ((NSString* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter);
            }
                break;
            case CGXEncodingTypeArray:
            case CGXEncodingTypeMutableArray:
            {
                NSArray *arr = ((NSArray* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter);
                if (arr && [arr isKindOfClass:[NSArray class]] && arr.count) {
                    NSMutableArray *valArray = [NSMutableArray array];
                    [arr enumerateObjectsUsingBlock:^(id  _Nonnull arrObj, NSUInteger idx, BOOL * _Nonnull stop) {
                        id arrObjPV = CGXGetPropertyValue(arrObj, needNullValue, useMapPropertyKey);
                        if (arrObjPV) {
                            [valArray addObject:arrObjPV];
                        }
                    }];
                    if (valArray.count) {
                        value = valArray;
                    }
                }
            }
                break;
            case CGXEncodingTypeDictionary:
            {
                value = ((NSDictionary* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter);
            }
                break;
            case CGXEncodingTypeMutableDictionary:
            {
                value = ((NSMutableDictionary* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter);
            }
                break;
            case CGXEncodingTypeObject:
            {
                value = CGXGetPropertyValue(((NSObject* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter), needNullValue, useMapPropertyKey);
            }
                break;
            case CGXEncodingTypeNumber:
            {
                value = ((NSNumber* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter);
            }
                break;
            case CGXEncodingTypeDate:
            {
                value = @([((NSDate* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter) timeIntervalSince1970]);
            }
                break;
            case CGXEncodingTypeInt32:
            {
                value = @(((int32_t (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            case CGXEncodingTypeUInt32:
            {
                value = @(((uint32_t (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            case CGXEncodingTypeFloat:
            {
                value = @(((float (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            case CGXEncodingTypeDouble:
            {
                value = @(((double (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            case CGXEncodingTypeBool:
            {
                value = @(((int8_t (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            case CGXEncodingTypeBoolean:
            {
                value = @(((uint8_t (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            default:
                break;
        }
        
        if (!value && needNullValue) {
            value = [NSNull null];
        }
        
        if (value) {
            [propertyValues setObject:value forKey:(useMapPropertyKey && obj.mapKey)?obj.mapKey:obj.name];
        }
    }];
    
    if (propertyValues.count) {
        return propertyValues;
    }
    
    return nil;
}

static const void *CGXExtensionNSObjectUserDataKey = &CGXExtensionNSObjectUserDataKey;

@implementation NSObject (CGXExtension)

#pragma mark - 新建对象 & 对象赋值

+ (NSMutableArray *)objectArrayWithDictionaryArray:(NSArray<NSDictionary *> *)dictionaryArray {
    if (!dictionaryArray.count) {
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSDictionary *dic in dictionaryArray) {
        id obj = [self objectWithData:dic];
        if (obj) {
            [arr addObject:obj];
        }
    }
    if (arr.count) {
        return arr;
    }
    return nil;
}

+ (instancetype)objectWithData:(id)data {
    
    Class clazz = [self class];
    
    if (!data || [data isKindOfClass:[NSNull class]] || (clazz == [NSObject class])) {
        return nil;
    }
    
    if ([clazz isSubclassOfClass:[NSMutableString class]]) {
        if ([data isKindOfClass:[NSString class]]) {
            return [data mutableCopy];
        }
    } else if ([clazz isSubclassOfClass:[NSString class]]) {
        if ([data isKindOfClass:[NSString class]]) {
            return data;
        }
    } else if ([clazz isSubclassOfClass:[NSNumber class]]) {
        if ([data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSNumber class]]) {
            return @([data doubleValue]);
        }
    } else if ([clazz isSubclassOfClass:[NSMutableDictionary class]]) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            return [data mutableCopy];
        }
    } else if ([clazz isSubclassOfClass:[NSDictionary class]]) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            return data;
        }
    } else if ([clazz isSubclassOfClass:[NSArray class]]) {
        if ([data isKindOfClass:[NSArray class]] && [(NSArray *)data count]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (id obj in data) {
                //因为无法确定obj的具体类型 所以只能支持基本类型
                id newObj = [[obj class] objectWithData:obj];
                if (newObj) {
                    [arr addObject:newObj];
                }
            }
            if (arr.count) {
                return arr;
            }
        }
    } else {
        return [[self new] voluationWithData:data];
    }
    
    return nil;
}

- (instancetype)voluationWithData:(id)data {
    
    CGXClassInfo *classInfo = [CGXClassInfo classInfoWithClass:[self class]];
    
    if (!data || [data isKindOfClass:[NSNull class]] || !classInfo.propertyInfos.count) {
        return self;
    }
    
    BOOL useMapPropertyKey = [data isKindOfClass:[NSDictionary class]];
    [classInfo.propertyInfos enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CGXPropertyInfo * _Nonnull obj, BOOL * _Nonnull stop) {
        if ((obj.propertyType & CGXPropertyTypeReadonly) != CGXPropertyTypeReadonly) {
            CGXSetPropertyValue(self, obj.setter, obj.encodingType, [data valueForKey:(useMapPropertyKey && obj.mapKey)?obj.mapKey:key], obj.objectClass);
        }
    }];
    
    return self;
}

#pragma mark - 各种列表

- (NSArray *)propertyList {
    return [[self class] propertyList];
}

- (NSDictionary *)propertyValues {
    return CGXGetPropertyValue(self, NO, NO);
}

- (NSDictionary *)propertyValuesUseMapPropertyKey {
    return CGXGetPropertyValue(self, NO, YES);
}

- (NSDictionary *)allPropertyValues {
    return CGXGetPropertyValue(self, YES, NO);
}

- (NSDictionary *)allPropertyValuesUseMapPropertyKey {
    return CGXGetPropertyValue(self, YES, YES);
}

- (NSArray *)methodList {
    return [[self class] methodList];
}

- (NSArray *)ivarList {
    return [[self class] ivarList];
}

//获取当前类的属性列表
+ (NSArray *)propertyList {
    CGXClassInfo *classInfo = [CGXClassInfo classInfoWithClass:[self class]];
    return classInfo.propertyInfos.allKeys;
}

//获取当前类的方法列表
+ (NSArray *)methodList {
    unsigned int count;
    
    Method *methods = class_copyMethodList([self class], &count);
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *methodName = NSStringFromSelector(method_getName(methods[i]));
        [list addObject:methodName];
    }
    
    if (list.count) {
        return list;
    }
    
    return nil;
}

//获取当前类的实例变量列表
+ (NSArray *)ivarList {
    unsigned int count;
    
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        const char *ivarName = ivar_getName(ivars[i]);
        [list addObject:[NSString stringWithUTF8String:ivarName]];
    }
    
    if (list.count) {
        return list;
    }
    
    return nil;
}

#pragma mark - JSON 互转

- (NSString *)JSONString {
    return self.propertyValuesUseMapPropertyKey.JSONString;
}

+ (instancetype)objectWithJSONString:(NSString *)JSONString {
    return [self objectWithData:[JSONString objectFromJSONString]];
}

+ (NSString *)JSONStringFromObjectArray:(NSArray *)objectArray {
    NSMutableArray *arr = [NSMutableArray array];
    for (id obj in objectArray) {
        NSDictionary *pvs = [obj propertyValuesUseMapPropertyKey];
        if (pvs.count) {
            [arr addObject:pvs];
        }
    }
    if (arr.count) {
        return arr.JSONString;
    }
    return nil;
}

+ (NSArray *)objectArrayFromJSONString:(NSString *)JSONString {
    NSArray *arr = [JSONString objectFromJSONString];
    if (!arr.count) {
        return nil;
    }
    NSMutableArray *objectArray = [NSMutableArray array];
    for (NSDictionary *pvs in arr) {
        if (pvs.count) {
            id obj = [self objectWithData:pvs];
            if (obj) {
                [objectArray addObject:obj];
            }
        }
    }
    if (objectArray.count) {
        return objectArray;
    }
    return nil;
}

#pragma mark - Description

- (NSString *)descriptionWithPropertyValues {
    return [NSString stringWithFormat:@"%@ \n%@",[self description],[self allPropertyValues]];
}

#pragma mark - Others

- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (instancetype)new {
    return [[self alloc] init];
}

#pragma clang diagnostic pop

#pragma mark - 异常处理

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"%@ -> valueForUndefinedKey : %@",self,key);
    return nil;
}

#pragma mark - NSCoder

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [self init]) {
        NSArray *propertyList = [self propertyList];
        
        if (!propertyList || !propertyList.count) {
            return self;
        }
        
        for (NSString *valueKey in propertyList) {
            [self setValue:[coder decodeObjectForKey:valueKey] forKey:valueKey];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    NSArray *propertyList = [self propertyList];
    
    if (!propertyList || !propertyList.count) {
        return;
    }
    
    for (NSString *valueKey in propertyList) {
        [coder encodeObject:[self valueForKey:valueKey] forKey:valueKey];
    }
}

#pragma mark - 存取部分

- (void)setUserData:(id)userData {
    objc_setAssociatedObject(self, CGXExtensionNSObjectUserDataKey, userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)userData {
    return objc_getAssociatedObject(self, CGXExtensionNSObjectUserDataKey);
}

@end
