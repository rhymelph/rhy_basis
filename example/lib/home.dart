import 'package:rhy_basis/rhy_basis.dart';

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
    start(_TaskEnum.loadData.index, [1]);

  }

  @override
  void onCreateTask() {
    restartableFirst(_TaskEnum.loadData.index, (args) {
      dataModel = _DataModel()..data = args[0];
    });

    restartableFirst(_TaskEnum.addOne.index, (args) {
      dataModel.data++;
      notify();
    });
  }
}

class _DataModel {
  int data;
}
