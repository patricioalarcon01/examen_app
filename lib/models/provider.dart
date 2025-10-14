class ProviderModel {
  final int id;
  final String name;
  final String lastName;
  final String mail;
  final String state;

  ProviderModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.mail,
    required this.state,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
        id: json['providerid'] ?? json['provider_id'] ?? 0,
        name: json['provider_name'] ?? '',
        lastName: json['provider_last_name'] ?? '',
        mail: json['provider_mail'] ?? '',
        state: json['provider_state'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'provider_id': id,
        'provider_name': name,
        'provider_last_name': lastName,
        'provider_mail': mail,
        'provider_state': state,
      };
}
