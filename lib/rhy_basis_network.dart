part of 'rhy_basis.dart';

typedef void OnSuccess(dynamic data);
typedef void OnError(dynamic error);

abstract class RhyBasisNetWork {
  //base url
  String get baseUrl;

  int get connectTimeout => 5000;

  int get receiveTimeout => 5000;

  Options get options => _dio.options;

  Map<String, dynamic> _headers;

  ResponseType _responseType;

  ContentType _contentType;

  ValidateStatus _validateStatus;

  Dio get _dio => Dio(Options(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: _headers,
        responseType: _responseType,
        contentType: _contentType,
        validateStatus: _validateStatus,
      ));

  set setHeaders(Map<String, dynamic> headers) {
    this._headers = headers;
  }

  Map<String, dynamic> get getHeaders => _headers;

  set setResponseType(ResponseType type) {
    this._responseType = type;
  }

  ResponseType get getResponseType => _responseType;

  set setContentType(ContentType contentType) {
    this._contentType = contentType;
  }

  ContentType get getContentType => _contentType;

  /// get请求,同步
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  Future<T> getAsy<T>(String path, data) async {
    var response = await _dio.get<T>(path, data: data);
    return response.data;
  }

  /// get请求
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  /// [onSuccess] 请求成功回调
  /// [onError] 请求失败回调
  void get<T>(String path, data, OnSuccess onSuccess, OnError onError) async {
    try {
      var response = await _dio.get<T>(path, data: data);
      dynamic result = response.data;
      onSuccess(result);
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        print(e.type);
      }
    }
  }

  /// post请求，内容为json，同步
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  Future<T> postJsonAsy<T>(String path, data) async {
    var response = await _dio.post<T>(path, data: data);
    return response.data;
  }

  /// post请求，内容为json
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  /// [onSuccess] 请求成功回调
  /// [onError] 请求失败回调
  void postJson<T>(
      String path, data, OnSuccess onSuccess, OnError onError) async {
    try {
      var response = await _dio.post<T>(path, data: data);
      dynamic result = response.data;
      onSuccess(result);
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        print(e.type);
      }
    }
  }

  /// post请求，内容为表单，同步
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  Future<T> postFormAsy<T>(String path, Map<String, dynamic> data) async {
    FormData formData = FormData.from(data);
    var response = await _dio.post<T>(path, data: formData);
    return response.data;
  }

  /// post请求，内容为表单
  ///
  /// [path] 二级路径
  /// [data] 请求内容
  /// [onSuccess] 请求成功回调
  /// [onError] 请求失败回调
  void postForm<T>(String path, Map<String, dynamic> data, OnSuccess onSuccess,
      OnError onError) async {
    try {
      FormData formData = FormData.from(data);
      var response = await _dio.post<T>(path, data: formData);
      dynamic result = response.data;
      onSuccess(result);
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        print(e.type);
      }
    }
  }

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
  ]) async {
    var response = await _dio.download(
      path,
      savePath,
      onProgress: onProgress,
      options: options,
      cancelToken: cancelToken,
      data: data,
    );
    return response.data;
  }
}
