# CGXExtension

`CGXExtension ` 集成

#### 因含有第三方代码，所以需要以下步骤

1. SVProgressHUD

* 添加 `SVProgressHUD.bundle` 到 `Targets->Build Phases->Copy Bundle Resources`.
* 添加 `QuartzCore` framework.



###随笔记录

1. `UITableViewCell`左滑删除的按钮，点击时会触发两次，如果设置了拦截，有可能会拦截掉原本的删除事件，因此只针对UIButton这一特定类设置拦截，在UIControl的类目里单独判断UIButton比较好，而不是单独写UIButton的类目。如果写UIButton的类目，则UIButton的子类也可能会出问题。
2. 更新`cocoapods`时遇到`You don't have write permissions for the /usr/bin directory`，若使用`sudo`仍无法解决可以尝试添加`--user-install``参数
3. 若遇到`zsh: /usr/local/bin/pod: bad interpreter: /System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin: no such file or directory`问题可以尝试使用
`sudo gem install -n /usr/local/bin cocoapods`
4. 自适应高度cell，设置自适应控件以`contentView`为约束，在`heightforRowAtIndexPath`方法中设置`tempCell`的数据源，并在cell的`awakeFromNib`方法中设置控件的`preferredMaxLayoutWidth`