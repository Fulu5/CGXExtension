### 随笔记录

1. `UITableViewCell`左滑删除的按钮，点击时会触发两次，如果设置了拦截，有可能会拦截掉原本的删除事件，因此只针对UIButton这一特定类设置拦截，在UIControl的类目里单独判断UIButton比较好，而不是单独写UIButton的类目。如果写UIButton的类目，则UIButton的子类也可能会出问题。
2. 更新`cocoapods`时遇到[You don't have write permissions for the /usr/bin directory]()，若使用`sudo`仍无法解决可以尝试添加`--user-install`参数
3. 若遇到[zsh: /usr/local/bin/pod: bad interpreter: /System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin: no such file or directory]()问题可以尝试使用
`sudo gem install -n /usr/local/bin cocoapods`
4. 自适应高度cell，设置自适应控件以`contentView`为约束，在`heightforRowAtIndexPath`方法中设置`tempCell`的数据源，并在cell的`awakeFromNib`方法中设置控件的`preferredMaxLayoutWidth`
5.	[git config]()
	* 使用`git config --list`查看当前目录的用户信息
	* 单独配置当前目录可以使用`git config user.name 'name'`和`git config user.email 'email'`
	* 配置全局使用`git config global user.name 'name'`和 `git config global user.email 'email'`
6. 大BOOL和小bool之间的区别： 

 * 类型不同 
BOOL为char型 
bool为布尔型 
 * 长度不同 
bool只有一个字节 
BOOL长度视实际环境来定，一般可认为是4个字节 
 * 取值不同 
bool取值false和true，是0和1的区别 
BOOL取值FALSE和TRUE，是0和非0的区别 

 ```
    /**
     typedef signed char BOOL
     typedef signed char Int8(SInt8)
     0和非0的区别
     */
    BOOL BL = YES;
    BL = NO;
    
    /**
     ISO C/C++ standard type
     0和1的区别
     */
    bool b = YES;//
    b = NO;
    
    /**
     define bool _Bool
     */
    _Bool Bl = YES;
    Bl = NO;
    
    /**
     typedef unsigned char Boolean
     typedef unsigned char UInt8
     Mac OS historic type
     sizeof(Boolean)==1
     */
    Boolean B = true;
    B = false;
```
7. 关于nil
 * nil的定义是[null pointer to object-c object]()，指的是一个`OC对象`指针为空，本质就是(id)0，是OC对象的字面0值
 * 不过这里有必要提一点就是OC中给空指针发消息不会崩溃的语言特性，原因是OC的函数调用都是通过[objc_msgSend]()进行消息发送来实现的，相对于C和C++来说，对于空指针的操作会引起Crash的问题，而objc_msgSend会通过判断self来决定是否发送消息，如果self为nil，那么selector也会为空，直接返回，所以不会出现问题。
 * 这里补充一点，如果一个对象已经被释放了，那么这个时候再去调用方法肯定是会Crash的，因为这个时候这个对象就是一个野指针了，安全的做法是释放后将对象重新置为nil，使它成为一个空指针
8. 关于Nil
 * Nil的定义是[null pointer to object-c class]()，指的是一个`类`指针为空。本质就是(class)0，OC类的字面零值。
9. 关于NULL
 * NULL的定义是[null pointer to primitive type or absence of data]()，指的是一般的`基础数据类型`为空，可以给任意的指针赋值。本质就是(void )0，是`C指针`的字面0值。
 * 我们要尽量不去将NULL初始化OC对象，可能会产生一些异常的错误，要使用nil，NULL主要针对基础数据类型。
10. 关于NSNull
 * NSNull好像没有什么具体的定义，它包含了唯一一个方法[+(NSNull)null]()，[NSNull null]是一个对象，用来表示零值的单独的对象。
 * NSNull主要用在`不能使用nil的场景`下，比如NSMutableArray是以nil作为数组结尾判断的，所以如果想插入一个空的对象就不能使用nil，NSMutableDictionary也是类似，我们不能使用nil作为一个object，而要使用NSNull
11. 关于UIImageRenderingMode
    * `UIImageRenderingModeAutomatic`
    	* 默认的渲染模式
    	* navigation bars, tab bars, toolbars, and segmented controls将被渲染为templates
    	* imageView 和 webView将被渲染为originals
    * `UIImageRenderingModeAlwaysOriginal`
    	* 原图展示
    * `UIImageRenderingModeAlwaysTemplate`
    	* 该模式忽略颜色信息

12. `layer.makesToBounds` 和 `clipsToBounds`
	* clipsToBounds：是UIView的属性，如果设置为yes，则不显示超出父视图的部分
	* masksToBounds：是CALayer的属性，如果设置为yes，则不显示超出父图层的部分
	* 功能上等价
	* `clipsToBounds`内部调用的是`masksToBounds`
13. `UILabel`切圆角
	* 设置视图的图层背景色,不要直接设置 label.backgroundColor
	* label.layer.backgroundColor = [UIColor grayColor].CGColor;
	* label.layer.cornerRadius = cornerRadius;
14. _cmd
	* _cmd 代指当前方法的选择器
15. 设置`UITableView`的背景色为白色可以取消`groupType`下`header`和`footer`的颜色(默认灰色的那种)
16. 使用`switch case`时注意`break`的使用
17. `复用`的cell中对视图进行隐藏和显示操作时，隐藏和显示的判断都要有，否则在复用过程中会出现错误的判断
18. `复用`的cell中，需要在`block`中使用`indexPath`时须使用tableView:indexPathForCell来获取，通过捕获得到的indexPath可能会因为复用不准确
19. Xcode一些快捷键
	* command shift O 快速搜索、打开文件
	* command \ 添加、删除断点
	* control ← 回到上次打开的页面
20. FPS 帧每秒
	* 每帧 16.7ms
	* 主线程UI渲染时间不超过16.7毫秒为优
21. `viewController.view`调用时会初始化添加在view上的视图，在继承定制的时候有些属性须在此之前进行配置
22. App Store`打包上传`
	* 证书配置
		* debug
		* release
	* release环境下打包，选择current device或者真机都行
	* iTunes Connect构建新版本
	* App Loader上传
	* iTunes Connect提交审核
23. 本地私有库
	* 拖入文件夹，不勾选copy items
	* 配置Building Setting
		* Framework SearchPath
		* Library SearchPath
		* Prefix Header
24. he
25. he
26. he
27. he
28. he
29. he
30. he