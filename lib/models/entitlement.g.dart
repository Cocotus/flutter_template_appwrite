// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Entitlement _$EntitlementFromJson(Map<String, dynamic> json) => _Entitlement(
  plan: json['plan'] as String? ?? 'premium',
  orderId: json['orderId'] as String? ?? '',
  purchasedAt: json['purchasedAt'] as String? ?? '',
  email: json['email'] as String? ?? '',
);

Map<String, dynamic> _$EntitlementToJson(_Entitlement instance) =>
    <String, dynamic>{
      'plan': instance.plan,
      'orderId': instance.orderId,
      'purchasedAt': instance.purchasedAt,
      'email': instance.email,
    };
