part of 'rhy_basis.dart';

enum WidgetStatus {
  NORMAL,
  EMPTY,
  ERROR,
  PREVIEW,
}

enum SnackBarDuration {
  SHORT,
  LONG,
}

///基本的事件流
class _RhyBasisEvent {
  //任务表
  static final Map<String, ValueChanged<List<dynamic>>> _taskTable = {};

  //已经注册了的消息表
  static final Map<String, ValueChanged<dynamic>> _registerTable = {};
}

///发送消息
void sendMessage(String to, dynamic data) {
  if (_RhyBasisEvent._registerTable[to] != null) {
    _RhyBasisEvent._registerTable[to](data);
  }
}

///注册消息
void registerMessage(String who, ValueChanged<dynamic> onCall) {
  _RhyBasisEvent._registerTable[who] = onCall;
}

///移除消息
void unRegisterMessage(String who) {
  _RhyBasisEvent._registerTable.remove(who);
}

///定义视图
abstract class RhyBasisState<T extends StatefulWidget, MD> extends State<T>
    with BasePresenter<T, MD> {
  /// 获取到视图的key
  final GlobalKey<ScaffoldState> _mState = GlobalKey();

  /// 基本的事件流控制器
  final StreamController<MD> _baseStreamController = StreamController<MD>();

  /// 基本的事件流
  Stream<MD> _baseStream;

  /// 值改变监听
  VoidCallback _baseValueListener;

  ///当前状态
  WidgetStatus _status = WidgetStatus.NORMAL;

  WidgetStatus get status => _status;

  set status(WidgetStatus status) {
    setState(() {
      _status = status;
    });
  }

  /// 手动更新数据
  /// 该方法用于当值不是重新赋予的时候，进行更新成员变量，才需要调用
  /// 如果调用 [_valueNotifier.value]=?，会对视图进行更新
  void notify() {
    _baseStreamController.add(_valueNotifier.value);
  }

  @override
  void initState() {
    super.initState();
    _baseStream = _baseStreamController.stream.asBroadcastStream();
    _baseValueListener = () {
      //监听值的改变并发送到视图
      _baseStreamController.add(_valueNotifier.value);
    };
    _valueNotifier.addListener(_baseValueListener);
  }

  @override
  void dispose() {
    super.dispose();
    _valueNotifier.removeListener(_baseValueListener);
    _baseStreamController.close();
  }

  /// 显示对话框
  ///
  /// [title] 标题
  ///
  /// [content] 内容
  ///
  /// [action] 操作按钮
  ///
  /// [barrierDismissible] 是否可点击对话框外部取消
  void showCustom(String title, String content, List<Widget> action,
      [bool barrierDismissible]) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? true,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: action,
            ));
  }

  /// 显示加载中对话框
  ///
  /// [tip] 给用户的提示
  ///
  /// [barrierDismissible] 是否可点击对话框外部取消
  void showProgress(String tip, [bool barrierDismissible]) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? true,
        builder: (BuildContext context) => AlertDialog(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text(tip),
                ],
              ),
            ));
  }

  /// 显示 SnackBar
  ///
  /// [content] 要提示的内容
  ///
  /// [duration]  持续时间
  void showSnackBar(
    String content, [
    SnackBarDuration duration,
    Color backgroundColor,
  ]) {
    Duration time = Duration(milliseconds: 300);
    if (duration == SnackBarDuration.LONG) {
      time = Duration(seconds: 1);
    }
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        backgroundColor: backgroundColor,
        duration: time,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _buildWidget();

  _buildWidget() {
    switch (_status) {
      case WidgetStatus.EMPTY:
        return emptyWidget;
      case WidgetStatus.ERROR:
        return errorWidget;
      case WidgetStatus.PREVIEW:
        return previewWidget;
      case WidgetStatus.NORMAL:
        return StreamBuilder<MD>(
          initialData: _valueNotifier.value,
          stream: _baseStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return errorWidget;
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return previewWidget;
              case ConnectionState.active:
                return buildNetWork(snapshot.data);
              default:
                return emptyWidget;
            }
          },
        );
    }
  }



  /// 请求网络后构建
  Widget buildNetWork(MD t);

  /// 请求失败的页面
  Widget get errorWidget => Scaffold(
        key: _mState,
        body: Center(
          child: Text('error '),
        ),
      );

  ///等待数据的页面
  Widget get previewWidget => Scaffold(
        key: _mState,
        body: Center(
          child: Text('data loading...'),
        ),
      );

  ///空白的页面,或错误的页面
  Widget get emptyWidget => Scaffold(
        key: _mState,
        body: Center(
          child: Text(''),
        ),
      );
}

///定义逻辑
abstract class BasePresenter<T extends StatefulWidget, MD> implements State<T> {
  final StreamController<_Task> _taskController = StreamController<_Task>();
  Stream<_Task> _task;
  List<String> _taskTable = [];
  final ValueNotifier<MD> _valueNotifier = ValueNotifier<MD>(null);

  set dataModel(MD md) {
    _valueNotifier.value = md;
  }

  MD get dataModel => _valueNotifier.value;

  @override
  void initState() {
    onCreateTask();
    _task = _taskController.stream.asBroadcastStream();
    _task.listen((task) {
      ValueChanged<List<dynamic>> taskCall = _RhyBasisEvent
          ._taskTable['${this.runtimeType}_${task.restartableId}'];
      if (taskCall != null) {
        taskCall(task.args);
      }
    });
    initData();
  }

  @override
  void dispose() {
    _taskController.close();
    _RhyBasisEvent._taskTable.removeWhere((a, b) => _taskTable.contains(a));
    _taskTable.clear();
  }

  /// 接收任务的方法
  ///
  /// * [restartableId] 任务标识
  ///
  /// * [taskCall] 回调
  ///
  void restartableFirst(
      int restartableId, ValueChanged<List<dynamic>> taskCall) {
    String taskName = '${this.runtimeType}_$restartableId';

    _taskTable.add(taskName);
    _RhyBasisEvent._taskTable[taskName] = taskCall;
  }

  ///发送一条任务
  ///
  /// * [restartableId] 任务标识
  ///
  /// * [args] 参数
  ///
  void start(int restartableId, [List<dynamic> args]) {
    _taskController.add(_Task(restartableId, args));
  }

  ///创建任务
  void onCreateTask();

  ///初始化数据
  void initData();
}

class _Task {
  final int restartableId;
  final List<dynamic> args;

  _Task(this.restartableId, this.args);
}
