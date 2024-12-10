


class DeviceModel {
  String? deviceName;
  String? deviceModel;
  String? deviceToken;
  String? deviceOS;
  dynamic deviceOSVersion;
  String? deviceId;

  Map? details;

  DeviceModel(
      {this.deviceName,
        this.deviceModel,
        this.deviceToken,
        this.deviceOS,
        this.details,
        this.deviceOSVersion,
        this.deviceId});

  DeviceModel.fromJson(Map<String, dynamic> json) {
    deviceName = json['device_name'];
    deviceModel = json['device_model'];
    deviceToken = json['device_token'];
    deviceOS = json['device_os'];
    deviceOSVersion = json['deviceOSVersion'];
    details = json['details'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['device_name'] = deviceName;
    data['device_model'] = deviceModel;
    data['device_token'] = deviceToken;
    data['device_os'] = deviceOS;
    data['deviceOSVersion'] = deviceOSVersion;
    data['details'] = details;
    data['deviceId'] = deviceId;
    return data;
  }
}
