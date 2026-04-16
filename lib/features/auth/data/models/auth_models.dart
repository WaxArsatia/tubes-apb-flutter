import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class AuthRegisterRequest {
  const AuthRegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmationPassword,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmationPassword;

  factory AuthRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRegisterRequestToJson(this);
}

@JsonSerializable()
class AuthLoginRequest {
  const AuthLoginRequest({required this.email, required this.password});

  final String email;
  final String password;

  factory AuthLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthLoginRequestToJson(this);
}

@JsonSerializable()
class RefreshTokenRequest {
  const RefreshTokenRequest({required this.refreshToken});

  final String refreshToken;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}

@JsonSerializable()
class ForgotPasswordRequest {
  const ForgotPasswordRequest({required this.email});

  final String email;

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class VerifyOtpRequest {
  const VerifyOtpRequest({required this.email, required this.otp});

  final String email;
  final int otp;

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}

@JsonSerializable()
class ChangePasswordRequest {
  const ChangePasswordRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmationPassword,
  });

  final String email;
  final int otp;
  final String newPassword;
  final String confirmationPassword;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}

@JsonSerializable()
class AuthenticatedChangePasswordRequest {
  const AuthenticatedChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmationPassword,
  });

  final String oldPassword;
  final String newPassword;
  final String confirmationPassword;

  factory AuthenticatedChangePasswordRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$AuthenticatedChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AuthenticatedChangePasswordRequestToJson(this);
}

@JsonSerializable()
class AuthRegisterSuccess {
  const AuthRegisterSuccess({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final AuthRegisterData data;

  factory AuthRegisterSuccess.fromJson(Map<String, dynamic> json) =>
      _$AuthRegisterSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRegisterSuccessToJson(this);
}

@JsonSerializable()
class AuthRegisterData {
  const AuthRegisterData({required this.registered});

  final bool registered;

  factory AuthRegisterData.fromJson(Map<String, dynamic> json) =>
      _$AuthRegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRegisterDataToJson(this);
}

@JsonSerializable()
class AuthLoginSuccess {
  const AuthLoginSuccess({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final TokenBundle data;

  factory AuthLoginSuccess.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$AuthLoginSuccessToJson(this);
}

@JsonSerializable()
class TokenBundle {
  const TokenBundle({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  factory TokenBundle.fromJson(Map<String, dynamic> json) =>
      _$TokenBundleFromJson(json);

  Map<String, dynamic> toJson() => _$TokenBundleToJson(this);
}

@JsonSerializable()
class AuthLogoutSuccess {
  const AuthLogoutSuccess({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final AuthLogoutData data;

  factory AuthLogoutSuccess.fromJson(Map<String, dynamic> json) =>
      _$AuthLogoutSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$AuthLogoutSuccessToJson(this);
}

@JsonSerializable()
class AuthLogoutData {
  const AuthLogoutData({required this.loggedOut});

  final bool loggedOut;

  factory AuthLogoutData.fromJson(Map<String, dynamic> json) =>
      _$AuthLogoutDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthLogoutDataToJson(this);
}

@JsonSerializable()
class AuthMeSuccess {
  const AuthMeSuccess({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final AuthMeData data;

  factory AuthMeSuccess.fromJson(Map<String, dynamic> json) =>
      _$AuthMeSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMeSuccessToJson(this);
}

@JsonSerializable()
class AuthMeData {
  const AuthMeData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePicture;

  String get fullName => '$firstName $lastName';

  factory AuthMeData.fromJson(Map<String, dynamic> json) =>
      _$AuthMeDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMeDataToJson(this);
}

@JsonSerializable()
class ForgotPasswordSuccess {
  const ForgotPasswordSuccess({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final ForgotPasswordData data;

  factory ForgotPasswordSuccess.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordSuccessToJson(this);
}

@JsonSerializable()
class ForgotPasswordData {
  const ForgotPasswordData({
    required this.email,
    required this.otpExpiresInMinutes,
  });

  final String email;
  final int otpExpiresInMinutes;

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordDataFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordDataToJson(this);
}

@JsonSerializable()
class VerifyOtpSuccess {
  const VerifyOtpSuccess({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final VerifyOtpData data;

  factory VerifyOtpSuccess.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpSuccessToJson(this);
}

@JsonSerializable()
class VerifyOtpData {
  const VerifyOtpData({required this.email, required this.otpVerified});

  final String email;
  final bool otpVerified;

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpDataFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpDataToJson(this);
}

@JsonSerializable()
class ChangePasswordSuccess {
  const ChangePasswordSuccess({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final ChangePasswordData data;

  factory ChangePasswordSuccess.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordSuccessToJson(this);
}

@JsonSerializable()
class ChangePasswordData {
  const ChangePasswordData({required this.passwordChanged});

  final bool passwordChanged;

  factory ChangePasswordData.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordDataToJson(this);
}
