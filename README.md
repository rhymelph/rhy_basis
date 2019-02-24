# rhy_basis

一款理论和灵感来源于公司项目进行封装的插件，目的是让逻辑与视图更加分明，解决在写Flutter代码时出现一坨一坨的窘况!

## 插件
> 感谢以下优秀的插件
- 数据库:sqflite
- 配置缓存:shared_preferences
- 请求网络:dio
- 文件路径:path_provider
- json序列化:jaguar_serializer
- rx:rxdart

## 怎么使用？
> 添加包：
```yaml
    rhy_basis:
      git: https://github.com/rhymelph/rhy_basis.git
```
> 导入包：
```dart
import 'package:rhy_basis/rhy_basis.dart';
```

### 1.数据库

#### 初始化数据库
> 如果你之前有Android开发的基础，应该了解到，我们初始化数据库，一般会在Application的子类重写onCreate方法，在该方法下面进行对数据库的初始化，所以，下面是初始化的步骤
```dart
void main()async{
  // 该方法需要调用到原生的api，所以需要等待数据库初始化完成，不然会导致初始化未完成时，调用请求数据库的操作会发生
  // 异常
  // example.db 你的数据库名字
  // 1 你的数据库版本号
  await baseConfig.initDataBase('example.db', 1);
  
  //运行你的app
  runApp(MyApp());
}
```
> 如果你的应用在迭代过程中，对数据库的内容进行了扩充或者修改，你可以在这样操作
```dart
void main()async{
// 如果你的项目需要进行对数据库升级或者降级的操作，可以如下操作
  await baseConfig.initDataBase('example.db', 2,
      onUpgrade: (Database db,int oldVersion,int newVersion){
      //这里写升级的语句
      },
      onDowngrade: (Database db, int oldVersion, int newVersion){
      //这里写降级的语句
      });
  
  //运行你的app
  runApp(MyApp());
}
```
#### 使用数据库:
> 当初始化完成之后，我们就可以使用`baseConfig.db`该对象进行数据库的操作了
    
### 2.网络
> 在应用的开发过程中，会出现请求网络的一些api等，这个时候，我们就需要封装好一个网络请求库

#### 实现自己的网络
> 要实现自己的请求网络库，我们可以继承`RhyBasisNetWork`
```dart
class MyNetWork extends RhyBasisNetWork{
  
  //baseUrl 就是我们请求的一级路径
  @override
  String get baseUrl => 'http://api.google.com';

}
```
该父类已经封装了我们最常用的api
```dart
  /// get请求,同步
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  Future<T> getAsy<T>(String path, data);

  /// get请求
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  /// [onSuccess] 请求成功回调
  /// [onError] 请求失败回调
  void get<T>(String path, data, OnSuccess onSuccess, OnError onError);
  
  /// post请求，内容为json，同步
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  Future<T> postJsonAsy<T>(String path, data);
  
  /// post请求，内容为json
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  /// [onSuccess] 请求成功回调
  /// [onError] 请求失败回调
  void postJson<T>(
      String path, data, OnSuccess onSuccess, OnError onError);
  
  /// post请求，内容为表单，同步
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  Future<T> postFormAsy<T>(String path, Map<String, dynamic> data);
  
  /// post请求，内容为表单
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  /// [onSuccess] 请求成功回调
  /// [onError] 请求失败回调
  void postForm<T>(String path, Map<String, dynamic> data, OnSuccess onSuccess,
      OnError onError);
  
  /// 下载文件
  ///
  /// [path] 二级路径
  /// [savePath] 保存路径
  /// [onProgress] 下载进度
  /// [cancelToken] 取消的token
  /// [data] 请求的参数
  /// [options] 请求配置
  Future<T> download<T>(
    String path,
    String savePath, [
    OnDownloadProgress onProgress,
    CancelToken cancelToken,
    data,
    Options options,
  ]);
```
#### 初始化网络请求

```dart
void main()async{
  //MyNetWork继承自RhyBasisNetWork
  baseConfig.initNetWork(MyNetWork());

  runApp(MyApp());

}
```

#### 使用网络请求
```dart
    
  //这里就可以获取到网络请求的实例
  baseConfig.getNetWork<MyNetWork>();
```

### 3. 绑定实体类：
    我们初始化数据库之后，可以继承`RhyBasisProvider`这个类，获取到该实体类进行数据库操作的工具类,如下
    
```dart
class UserBean{
  int id;
  String username;
  String password;
  String address;
  int age;
  String phone;
  String email;
}

class UserProvider extends RhyBasisProvider<UserBean,UserSerializer>{
  //定义表中的列名
  static const String columnUsername='username';
  static const String columnPassword='password';
  static const String columnAge='age';
  static const String columnPhone='phone';
  static const String columnEmail='email';
  static const String columnAddress='address';

  //创建表的语句
  @override
  String get createTable => '''create table IF NO EXISTS $tableName(
  $columnId integer primary key autoincrement,
  $columnUsername text,
  $columnPassword text,
  $columnPhone text,
  $columnEmail text,
  $columnAddress text,
  $columnAge integer)''';

  
  //序列化操作工具类
  @override
  Serializer<UserBean> get serializer => UserSerializer();

}

//  run "flutter packages pub run build_runner build" in the terminal.
//  or watch file run "flutter packages pub run build_runner watch" in the terminal
//  add "part 'user.jser.dart'" in this file.
@GenSerializer()
class UserSerializer extends Serializer<UserBean> with _$UserSerializer {
}
```
### 4. 使用封装的RhyBasisState

```dart
enum _TaskEnum {//todo 任务标志
  loadData, //loading data
  addOne, //if user click the fab,data will add one
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends RhyBasisStatefulWidget<Home, _DataModel> {
  @override
  Widget buildNetWork(_DataModel t) {//todo 用于请求成功后的部件构建
    return Scaffold(
      appBar: AppBar(
        title: Text('Rhyme Plugin example app'),
      ),
      body: Center(
        child: Text('You had click ${dataModel.data}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          start(_TaskEnum.addOne.index);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initData() {//todo 用于初始化数据
    //开始一个任务,可传入参数
    start(_TaskEnum.loadData.index, [1]);

  }

  @override
  void onCreateTask() {//todo 用于注册任务
    UserProvider userProvider=UserProvider();

    //注册加载数据任务
    restartableFirst(_TaskEnum.loadData.index, (args) {
      //更新ui
      dataModel = _DataModel()..data = args[0];

    });

    //注册点击事件任务
    restartableFirst(_TaskEnum.addOne.index, (args) {
      dataModel.data++;
      //手动刷写ui
      notify();
    });
  }
}

class _DataModel {//todo 数据模型
  int data;
}

```

### 5. 在两个页面进行通信
```dart
    //注册接收消息,home是用来标识你的消息，当发送的时候就要知道发给的是谁了
    registerMessage('home', (data){
          dataModel.data++;
          //手动刷写ui
          notify();
        });

    //发送消息
    sendMessage('home', null);
    
    //注销注册
    unRegisterMessage('home');
```