part of 'rhy_basis.dart';


const RhyBasisConfig baseConfig = RhyBasisConfig();

/// 基本配置
class RhyBasisConfig {
  const RhyBasisConfig();
  static final Map<String, dynamic> _baseConfig = {};
  /// 数据库名
  set dbName(String name) {
    _baseConfig['dbName'] = name;
  }
  String get dbName => _baseConfig['dbName'];
  /// 数据库版本号
  set dbVersion(int version) {
    _baseConfig['dbVersion'] = version;
  }

  int get dbVersion => _baseConfig['dbVersion'];
  /// 初始化数据库
  ///
  /// [dbName] 数据库名字
  /// [dbVersion] 数据库版本号
  /// [onUpgrade] 数据库升级
  /// [onDowngrade] 数据库降级
  Future<void> initDataBase(String dbName,
      int dbVersion, {
        OnDatabaseVersionChangeFn onUpgrade,
        OnDatabaseVersionChangeFn onDowngrade,
      }) async{
    this.dbName=dbName;
    this.dbVersion=dbVersion;
    Database db=await openDatabase(
      dbName,
      version: dbVersion,
      onUpgrade: onUpgrade,
      onDowngrade: onDowngrade,
    );
    _baseConfig['database']=db;
    return null;
  }
  /// 获取数据库
  Database get db=>_baseConfig['database'];
  /// 网络请求配置
  ///
  /// [network] 继承自 [RhyBasisNetWork] 类
  void initNetWork<T extends RhyBasisNetWork>(T network) {
    _baseConfig['network'] = network;
  }
  T getNetWork<T extends RhyBasisNetWork>() => _baseConfig['network'];

  /// 设置自定义的全局变量
  ///
  /// [database]、[network]、[dbName]、[dbVersion] was used
  ///
  /// [key] 键
  /// [value] 值
  void setExpend(String key,dynamic value){
      _baseConfig[key]=value;
  }
  /// 获取自定义的全局变量
  ///
  /// [key] 键
  dynamic getExpend(String key){
    return _baseConfig[key];
  }
  ///移除全局变量
  ///
  /// [key] 键
  void removeExpend(String key){
    _baseConfig.remove(key);
  }
  /// 是否含有该全局变量
  ///
  /// [key] 键
  bool hasExpend(String key){
    return _baseConfig.containsKey(key);
  }
}
