// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRegisterRequest _$AuthRegisterRequestFromJson(Map<String, dynamic> json) =>
    AuthRegisterRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      confirmationPassword: json['confirmationPassword'] as String,
    );

Map<String, dynamic> _$AuthRegisterRequestToJson(
  AuthRegisterRequest instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'password': instance.password,
  'confirmationPassword': instance.confirmationPassword,
};

AuthLoginRequest _$AuthLoginRequestFromJson(Map<String, dynamic> json) =>
    AuthLoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$AuthLoginRequestToJson(AuthLoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    RefreshTokenRequest(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$RefreshTokenRequestToJson(
  RefreshTokenRequest instance,
) => <String, dynamic>{'refreshToken': instance.refreshToken};

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordRequest(email: json['email'] as String);

Map<String, dynamic> _$ForgotPasswordRequestToJson(
  ForgotPasswordRequest instance,
) => <String, dynamic>{'email': instance.email};

VerifyOtpRequest _$VerifyOtpRequestFromJson(Map<String, dynamic> json) =>
    VerifyOtpRequest(
      email: json['email'] as String,
      otp: (json['otp'] as num).toInt(),
    );

Map<String, dynamic> _$VerifyOtpRequestToJson(VerifyOtpRequest instance) =>
    <String, dynamic>{'email': instance.email, 'otp': instance.otp};

ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => ChangePasswordRequest(
  email: json['email'] as String,
  otp: (json['otp'] as num).toInt(),
  newPassword: json['newPassword'] as String,
  confirmationPassword: json['confirmationPassword'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  ChangePasswordRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'otp': instance.otp,
  'newPassword': instance.newPassword,
  'confirmationPassword': instance.confirmationPassword,
};

AuthenticatedChangePasswordRequest _$AuthenticatedChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => AuthenticatedChangePasswordRequest(
  oldPassword: json['oldPassword'] as String,
  newPassword: json['newPassword'] as String,
  confirmationPassword: json['confirmationPassword'] as String,
);

Map<String, dynamic> _$AuthenticatedChangePasswordRequestToJson(
  AuthenticatedChangePasswordRequest instance,
) => <String, dynamic>{
  'oldPassword': instance.oldPassword,
  'newPassword': instance.newPassword,
  'confirmationPassword': instance.confirmationPassword,
};

AuthRegisterSuccess _$AuthRegisterSuccessFromJson(Map<String, dynamic> json) =>
    AuthRegisterSuccess(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AuthRegisterData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthRegisterSuccessToJson(
  AuthRegisterSuccess instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

AuthRegisterData _$AuthRegisterDataFromJson(Map<String, dynamic> json) =>
    AuthRegisterData(registered: json['registered'] as bool);

Map<String, dynamic> _$AuthRegisterDataToJson(AuthRegisterData instance) =>
    <String, dynamic>{'registered': instance.registered};

AuthLoginSuccess _$AuthLoginSuccessFromJson(Map<String, dynamic> json) =>
    AuthLoginSuccess(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: TokenBundle.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthLoginSuccessToJson(AuthLoginSuccess instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

TokenBundle _$TokenBundleFromJson(Map<String, dynamic> json) => TokenBundle(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  tokenType: json['tokenType'] as String,
  expiresIn: (json['expiresIn'] as num).toInt(),
);

Map<String, dynamic> _$TokenBundleToJson(TokenBundle instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
    };

AuthLogoutSuccess _$AuthLogoutSuccessFromJson(Map<String, dynamic> json) =>
    AuthLogoutSuccess(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AuthLogoutData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthLogoutSuccessToJson(AuthLogoutSuccess instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

AuthLogoutData _$AuthLogoutDataFromJson(Map<String, dynamic> json) =>
    AuthLogoutData(loggedOut: json['loggedOut'] as bool);

Map<String, dynamic> _$AuthLogoutDataToJson(AuthLogoutData instance) =>
    <String, dynamic>{'loggedOut': instance.loggedOut};

AuthMeSuccess _$AuthMeSuccessFromJson(Map<String, dynamic> json) =>
    AuthMeSuccess(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AuthMeData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthMeSuccessToJson(AuthMeSuccess instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

AuthMeData _$AuthMeDataFromJson(Map<String, dynamic> json) => AuthMeData(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  profilePicture: json['profilePicture'] as String?,
);

Map<String, dynamic> _$AuthMeDataToJson(AuthMeData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
    };

ForgotPasswordSuccess _$ForgotPasswordSuccessFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordSuccess(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: ForgotPasswordData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ForgotPasswordSuccessToJson(
  ForgotPasswordSuccess instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

ForgotPasswordData _$ForgotPasswordDataFromJson(Map<String, dynamic> json) =>
    ForgotPasswordData(
      email: json['email'] as String,
      otpExpiresInMinutes: (json['otpExpiresInMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$ForgotPasswordDataToJson(ForgotPasswordData instance) =>
    <String, dynamic>{
      'email': instance.email,
      'otpExpiresInMinutes': instance.otpExpiresInMinutes,
    };

VerifyOtpSuccess _$VerifyOtpSuccessFromJson(Map<String, dynamic> json) =>
    VerifyOtpSuccess(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: VerifyOtpData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VerifyOtpSuccessToJson(VerifyOtpSuccess instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

VerifyOtpData _$VerifyOtpDataFromJson(Map<String, dynamic> json) =>
    VerifyOtpData(
      email: json['email'] as String,
      otpVerified: json['otpVerified'] as bool,
    );

Map<String, dynamic> _$VerifyOtpDataToJson(VerifyOtpData instance) =>
    <String, dynamic>{
      'email': instance.email,
      'otpVerified': instance.otpVerified,
    };

ChangePasswordSuccess _$ChangePasswordSuccessFromJson(
  Map<String, dynamic> json,
) => ChangePasswordSuccess(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: ChangePasswordData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChangePasswordSuccessToJson(
  ChangePasswordSuccess instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

ChangePasswordData _$ChangePasswordDataFromJson(Map<String, dynamic> json) =>
    ChangePasswordData(passwordChanged: json['passwordChanged'] as bool);

Map<String, dynamic> _$ChangePasswordDataToJson(ChangePasswordData instance) =>
    <String, dynamic>{'passwordChanged': instance.passwordChanged};
