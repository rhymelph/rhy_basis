part of 'rhy_basis.dart';


typedef void OnSuccess(dynamic data);
typedef void OnError(dynamic error);

abstract class RhyBasisNetWork {

  //base url
  String get baseUrl;

  int get connectTimeout => 5000;

  int get receiveTimeout => 5000;

  Options get options => _dio.options;

  Map<String,dynamic> _headers;

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

  set setHeaders(Map<String,dynamic> headers){
    this._headers=headers;
  }
  Map<String,dynamic> get getHeaders=>_headers;

  set setResponseType(ResponseType type){
    this._responseType=type;
  }
  ResponseType get getResponseType=>_responseType;

  set setContentType(ContentType contentType){
    this._contentType=contentType;
  }
  ContentType get getContentType=>_contentType;

  void get<T>(String path,OnSuccess onSuccess,OnError onError,[data]) async {
    try{
      var response = await _dio.get<T>(path,data: data);
      dynamic result = response.data;
      onSuccess(result);
    }on DioError catch(e){
      if(e.response!=null){
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      }else{
        print(e.type);
      }
    }
  }

  Future<T> postJson<T>(String path, dynamic data) async {
    var response = await _dio.post<T>(path, data: data);
    return response.data;
  }

  Future<T> postForm<T>(String path, Map<String, dynamic> data) async {
    FormData formData = FormData.from(data);
    var response = await _dio.post<T>(path, data: formData);
    return response.data;
  }

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
