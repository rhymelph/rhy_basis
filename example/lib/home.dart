import 'package:rhy_basis/rhy_basis.dart';

import 'entity/user.dart';

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
