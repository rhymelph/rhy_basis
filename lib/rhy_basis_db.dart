part of 'rhy_basis.dart';


///数据库基类
abstract class RhyBasisProvider<DATA,T extends Serializer<DATA>>{

  RhyBasisProvider(){
    db=baseConfig.db;
    db.execute(createTable);
  }

  ///表名为当前实体类名
  String get tableName=>DATA.runtimeType.toString();

  ///序列化
  Serializer<DATA> get serializer;

  //创建表的语句
  String get createTable;

  Database db;

  String get columnId=>'id';

  Future<int> insert(DATA data)async{
    return await db.insert(tableName, serializer.toMap(data));
  }

  Future<List<dynamic>> insertAll(List<DATA> dataList)async{
    try{
      Batch batch=db.batch();
      for(DATA data in dataList){
        batch.insert(tableName, serializer.toMap(data));
      }
      return await batch.commit();
    }catch (exception){
      return null;
    }
  }

  Future<List<DATA>> getAll()async{
    List<Map<String, dynamic>> list=await db.query(tableName);
    return serializer.fromList(list);
  }

  Future<int> deleteAll()async{
    return await db.delete(tableName);
  }

  Future<int> update(DATA data)async{
    return await db.update(tableName, serializer.toMap(data));
  }

  Future<DATA> getOne(int id)async{
    List<Map> maps =
    await db.query(tableName, where: '$columnId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return serializer.fromMap(maps.first);
    }
    return null;

  }
  Future<void> close()async{
    return await db.close();
  }
}


