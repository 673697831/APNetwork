//
//  APBlackMagic.m
//  APNetwork
//
//  Created by ozr on 17/4/27.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APBlackMagic.h"
#import <objc/runtime.h>

@implementation APBlackMagic

+ (void) blackMagic
{
    [self blackMagicAFJSONResponseSerializer];
}

+ (void) blackMagicAFJSONResponseSerializer
{
    Class c = objc_getClass("AFJSONResponseSerializer");
    id block = ^NSSet*()
    {
        return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    };
    
    SEL selctor = NSSelectorFromString(@"acceptableContentTypes");
    IMP test = imp_implementationWithBlock(block);
    Method origMethod = class_getInstanceMethod(c,
                                                selctor);
    
    if(!class_addMethod(c, selctor, test,
                        method_getTypeEncoding(origMethod)))
    {
        method_setImplementation(origMethod, test);
    }
}

+ (void) replaceSelector:(SEL)selector
              fromSource:(Class)source
                toTarget:(Class)target
{
    //把 Source 的 SEL 塞入 Target
    if (class_respondsToSelector(source, selector)) {
        //获取 Source SEL 的 Method
        Method method = class_getInstanceMethod(source, selector);
        //获取 Method 指向的 IMP
        IMP imp = method_getImplementation(method);
        //尝试给 target 添加 sel, 如果成功返回 true
        //只要不是 target 这个类实现的 sel, 以及参数正确, 都会成功, 父类的方法会覆盖
        //这里其实可以用 replaceMethod 来实现, 省略 if 判断中的代码, 但是失去了讲解价值
        if (!class_addMethod(target, selector, imp, method_getTypeEncoding(method))) {
            // 从 target 中找出 method
            Method targetMethod = class_getInstanceMethod(target, selector);
            // 更改 method 指向的 IMP 即可完成 class 的方法改变, 可见 Method 和 Class 是绑在一起的
            method_setImplementation(targetMethod, imp);
        }
    }
}


@end
