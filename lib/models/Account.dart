class Account {
  Account({
    required this.job,
    required this.account,
    required this.password,
  });
  late final String job;
  late final String account;
  late final String password;

  Account.fromJson(Map<String, dynamic> json){
    job = json['job'];
    account = json['account'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['job'] = job;
    _data['account'] = account;
    _data['password'] = password;
    return _data;
  }
}