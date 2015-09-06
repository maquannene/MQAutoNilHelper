# MRC下使用Block中的对象被释放，野指针的处理


iOS目前已经是ARC的时代，而且苹果的新语言swift也只是ARC的，所以一个var声明的是`__weak`，当这个var不再被`__strong`引用时，这个`__weak`的var就会自动变成nil，所以ARC环境大多数情况下不必担心没有设置为nil时野指针的出现。

但是，如果工程中仍旧使用的是MRC，那么就会碰到一个问题：
网络请求中，大量使用到block，当block中引用到了一个被`__block`关键字声明的变量（后面用var代替），并且在这个block被回调的时候，这个var 已经被释放了，那么此时block中捕获的这个var 就成为了一个野指针。Objective-C中，向一个nil的对象发送消息是不会崩溃的，但是对一个野指针发送对象是必然崩溃的。

那么问题来了，如何在MRC下避免这种崩溃的发生。

### 方法一：将MRC的文件改成ARC的
如果都是这样改，那我还写这篇干个毛啊。关键在于，工程中MRC的文件太多了，行数少的一百多行还能改，上千行的就放弃吧。

### 方法二：搞一个类似于全局的NSMutblMeSet去暂存可能会出现问题中所描述的 var
首先这个NSMutblMeSet可以是个全局静态的变量，可以是个属于AppDelegate的var and so on，无所谓。如果一个对象涉及到问题中描述的可能会变成野指针的用法，那么这个对象初始化的时候，就注册进这个NSMutblMeSet；delloc时，就从NSMutblMeSet中remove。在block中使用时，先对对象进行是否存在检查，如果存在就向可以向这个对象发送消息，不存在就返回等等。
这其实是我在网上找到了一种方法，这种方法是可以解决想野指针发送消息引起的崩溃，但是并不是我想要的解决方法，装逼点说，就是我觉得这个方法不够优雅。

### 方法三：实现类似ARC下__weak的功能，被释放时自动置为nil
前一阵看到了一篇文章，讲的是ARC__weak自动设置为nil的原理。所以我就在想，如果仿照ARC __weak原理应该可以实现。
所以就大致将这个原理写了一下并且做了封装，其实非常简单，就是 `关联` + `block`。

第一步：创建一个叫`MMAutoNilHelper`的类，这个类只有一个属性，并且只干一件事情。
首先：这个属性是一个`block`，类型为`void(^MMAutoNilBlock)(void)`
```objc
typedef void(^MMAutoNilBlock)(void);

@interface MMAutoNilHelper : NSObject
@property (nonatomic, copy) MMAutoNilBlock autoNilBlock;

@end
```

其次：这个类只干的一件事情就是在自己dealloc的时候调用这个block：
```obj
- (void)dealloc {
    if (_autoNilBlock) {
        _autoNilBlock();
    }
    self.autoNilBlock = nil;
    [super dealloc];
}
```

第二步：怎么用`MMAutoNilHelper`这个类
首先，我们的目的在于，在某一个var被释放时，指向这个var的__block型var都自动变为nil，那么我们就可以借助这个`autoNilBlock`来帮助我们完成这个事情，具体操作如下：
```objc
__block typeof(self) bSelf = self;
MMAutoNilHelper *autoNilHelper = [[MMAutoNilHelper alloc] init];
autoNilHelper.autoNilBlock = ^{
    bSelf = nil;
};
objc_setAssociatedObject(bSelf, &autoNilHelper, autoNilHelper, OBJC_ASSOCIATION_RETAIN);
[autoNilHelper release];
```
看过代码之后，其实道理很简单易懂了吧。
假如上面的`bSelf`随时都有被释放的可能，那么我们实例一个`MMAutoNilHelper`对象，并且将这个对象关联到`bSelf`（就是自己）上，当bSelf被释放的时候，`autoNilHelper`也会被释放，`autoNilHelper`的`dealloc`方法就会被调用，此时，`_autoNilBlock()`就会被调用，bSelf就会被设置为了nil。这时，无论哪个block捕获了bSelf，bSelf都会变成nil，这样就不会出现野指针的现象了。

第三步：更加优雅一点
如果每次都要写那么多第二步的代码，那岂不是太啰嗦了，太不好用了，所以可以创建一个NSObject的category，将第二步的代码放在category的一个方法中：
```ojbc
- (void)MMMrcWeak:(void (^)(void))autoNilBlock {
    MMAutoNilHelper *autoNilHelper = [[MMAutoNilHelper alloc] init];
    autoNilHelper.autoNilBlock = autoNilBlock;
    objc_setAssociatedObject(self, &autoNilHelper, autoNilHelper, OBJC_ASSOCIATION_RETAIN);
    [autoNilHelper release];
}
```
并且写一个自动设置autoNibBlock的宏：
```objc
#ifndef MMMrcWeak
#if __has_feature(objc_arc)
#define MMMrcWeak(x) (x)
#else
#define MMMrcWeak(x)    \
[x MMMrcWeak:^{         \
x = nil;                \
}];                     \

#endif
#endif
```

此时如果我们在碰到想要bSelf自动置为nil，就只用写一句话`MMMrcWeak(bSelf)`即可：
```objc
__block typeof(self) bSelf = self;
MMMrcWeak(bSelf);   // 声明:MMMrcWeak 将bSelf 变成类似 arc下的weak，实现如果当bSelf释放的时候，自动设为nil
//  进行网络请求
[self qurey:^{
    if (bSelf) {
    NSLog(@"bSelf = %@ 这个指针还存在（没有被置为nil，可能是野指针）", bSelf);
    }
    else {
        NSLog(@"bSelf 不存在");
    }
}];
```

最后，[这里是Demo连接](https://github.com/wuhanness/MQAutoNilHelper);

其实这里还有个问题，就是如果反复调用了很多次`MMMrcWeak(bSelf)`,就会关联很多个`autoNilHelper`，那么这些`autoNilHelper`想要不用时就释放也成了一个难题，这个后续我再想想有没有什么办法，如果你有，可以 pull request。







