# rhy_basis

A basis Flutter plugin by rhyme_lph.

## 怎么使用？

1. 初始化数据库:
    如果你之前有Android开发的基础，会了解到，我们初始化数据库，一般会在Application的子类重写onCreate方法，在该
    方法下面进行对数据库的初始化，所以，下面是初始化的步骤
```dart
void main()async{
  // 该方法需要调用到原生的api，所以需要等待数据库初始化完成，不然会导致初始化未完成时，调用请求数据库的操作会发生
  // 异常
  // example.db 你的数据库名字
  // 1 你的数据库版本号
  await baseConfig.initDataBase('example.db', 1);
  
  // 如果你的项目需要进行对数据库升级或者降级的操作，可以如下操作
  await baseConfig.initDataBase('example.db', 1,
      onUpgrade: (Database db,int oldVersion,int newVersion){
      //这里写升级的语句
      },
      onDowngrade: (Database db, int oldVersion, int newVersion){
      //这里写降级的语句
      });
  
  
  runApp(MyApp());

}
```
2. 使用数据库:
    当初始化完成之后，我们就可以使用`baseConfig.db;`该对象进行数据库的操作了
    

3. 绑定实体类：
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
4. 使用封装的RhyBasisState

```dart
enum _TaskEnum {
  loadData, //loading data
  addOne, //if user click the fab,data will add one
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends RhyBasisState<Home, _DataModel> {
  @override
  Widget buildNetWork(_DataModel t) {
// TODO: implement buildNetWork
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
  void initData() {
    //开始一个任务,可传入参数
    start(_TaskEnum.loadData.index, [1]);

  }

  @override
  void onCreateTask() {
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

class _DataModel {
  int data;
}

```