class AdminAccess {
  const AdminAccess({
    required this.isAdministrator,
    required this.roles,
  });

  final bool isAdministrator;
  final List<String> roles;

  factory AdminAccess.fromJson(Map<String, dynamic> json) {
    return AdminAccess(
      isAdministrator: json['isAdministrator'] as bool? ?? false,
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }
}

class AdminDashboardStats {
  const AdminDashboardStats({
    required this.userCount,
    required this.roleCount,
    required this.ipNoteCount,
    required this.ipLookupRecordCount,
    required this.pushDeviceCount,
    required this.outboxPendingCount,
    required this.ipSnapshotCount,
    this.supportTicketOpenCount = 0,
  });

  final int userCount;
  final int roleCount;
  final int ipNoteCount;
  final int ipLookupRecordCount;
  final int pushDeviceCount;
  final int outboxPendingCount;
  final int ipSnapshotCount;
  final int supportTicketOpenCount;

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    return AdminDashboardStats(
      userCount: json['userCount'] as int? ?? 0,
      roleCount: json['roleCount'] as int? ?? 0,
      ipNoteCount: json['ipNoteCount'] as int? ?? 0,
      ipLookupRecordCount: json['ipLookupRecordCount'] as int? ?? 0,
      pushDeviceCount: json['pushDeviceCount'] as int? ?? 0,
      outboxPendingCount: json['outboxPendingCount'] as int? ?? 0,
      ipSnapshotCount: json['ipSnapshotCount'] as int? ?? 0,
      supportTicketOpenCount: json['supportTicketOpenCount'] as int? ?? 0,
    );
  }
}

class AdminUser {
  const AdminUser({
    required this.id,
    required this.emailConfirmed,
    required this.roles,
    this.email,
    this.userName,
    this.lockoutEnd,
  });

  final String id;
  final String? email;
  final String? userName;
  final bool emailConfirmed;
  final String? lockoutEnd;
  final List<String> roles;

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String?,
      userName: json['userName'] as String?,
      emailConfirmed: json['emailConfirmed'] as bool? ?? false,
      lockoutEnd: json['lockoutEnd'] as String?,
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }
}

class AdminIpNoteItem {
  const AdminIpNoteItem({
    required this.id,
    required this.address,
    required this.created,
    required this.lastModified,
    required this.isSoftDeleted,
    this.title,
    this.body,
    this.tags,
    this.ownerId,
    this.ownerEmail,
    this.countryCode,
    this.city,
    this.deviceLabel,
  });

  final int id;
  final String address;
  final String? title;
  final String? body;
  final String? tags;
  final String? ownerId;
  final String? ownerEmail;
  final String created;
  final String lastModified;
  final String? countryCode;
  final String? city;
  final String? deviceLabel;
  final bool isSoftDeleted;

  factory AdminIpNoteItem.fromJson(Map<String, dynamic> json) {
    return AdminIpNoteItem(
      id: json['id'] as int? ?? 0,
      address: json['address'] as String? ?? '',
      title: json['title'] as String?,
      body: json['body'] as String?,
      tags: json['tags'] as String?,
      ownerId: json['ownerId'] as String?,
      ownerEmail: json['ownerEmail'] as String?,
      created: json['created'] as String? ?? '',
      lastModified: json['lastModified'] as String? ?? '',
      countryCode: json['countryCode'] as String?,
      city: json['city'] as String?,
      deviceLabel: json['deviceLabel'] as String?,
      isSoftDeleted: json['isSoftDeleted'] as bool? ?? false,
    );
  }
}

class AdminIpLookupItem {
  const AdminIpLookupItem({
    required this.id,
    required this.address,
    required this.created,
    this.city,
    this.countryCode,
    this.isp,
  });

  final int id;
  final String address;
  final String created;
  final String? city;
  final String? countryCode;
  final String? isp;

  factory AdminIpLookupItem.fromJson(Map<String, dynamic> json) {
    return AdminIpLookupItem(
      id: json['id'] as int? ?? 0,
      address: json['address'] as String? ?? '',
      created: json['created'] as String? ?? '',
      city: json['city'] as String?,
      countryCode: json['countryCode'] as String?,
      isp: json['isp'] as String?,
    );
  }
}

class AdminPushDevice {
  const AdminPushDevice({
    required this.id,
    required this.deviceToken,
    required this.platform,
    required this.created,
    required this.lastModified,
    this.ownerId,
  });

  final int id;
  final String deviceToken;
  final String platform;
  final String? ownerId;
  final String created;
  final String lastModified;

  factory AdminPushDevice.fromJson(Map<String, dynamic> json) {
    return AdminPushDevice(
      id: json['id'] as int? ?? 0,
      deviceToken: json['deviceToken'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      ownerId: json['ownerId'] as String?,
      created: json['created'] as String? ?? '',
      lastModified: json['lastModified'] as String? ?? '',
    );
  }
}

class AdminRole {
  const AdminRole({
    required this.id,
    required this.name,
    required this.userCount,
    required this.permissions,
    required this.isSystem,
  });

  final String id;
  final String name;
  final int userCount;
  final List<String> permissions;
  final bool isSystem;

  factory AdminRole.fromJson(Map<String, dynamic> json) {
    return AdminRole(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      userCount: json['userCount'] as int? ?? 0,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((entry) => entry.toString())
              .toList() ??
          const [],
      isSystem: json['isSystem'] as bool? ?? false,
    );
  }
}

class AdminPermissionCatalogItem {
  const AdminPermissionCatalogItem({
    required this.key,
    required this.groupKey,
  });

  final String key;
  final String groupKey;

  factory AdminPermissionCatalogItem.fromJson(Map<String, dynamic> json) {
    return AdminPermissionCatalogItem(
      key: json['key'] as String? ?? '',
      groupKey: json['groupKey'] as String? ?? '',
    );
  }
}

class AdminOutboxMessage {
  const AdminOutboxMessage({
    required this.id,
    required this.type,
    required this.occurredOn,
    required this.contentLength,
    this.processedOn,
    this.error,
  });

  final String id;
  final String type;
  final String occurredOn;
  final String? processedOn;
  final String? error;
  final int contentLength;

  factory AdminOutboxMessage.fromJson(Map<String, dynamic> json) {
    return AdminOutboxMessage(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      occurredOn: json['occurredOn'] as String? ?? '',
      processedOn: json['processedOn'] as String?,
      error: json['error'] as String?,
      contentLength: json['contentLength'] as int? ?? 0,
    );
  }
}

class AdminSupportTicket {
  const AdminSupportTicket({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.status,
    required this.emailSent,
    required this.created,
    this.emailError,
    this.userId,
  });

  final int id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final String status;
  final bool emailSent;
  final String? emailError;
  final String? userId;
  final String created;

  factory AdminSupportTicket.fromJson(Map<String, dynamic> json) {
    return AdminSupportTicket(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? '',
      emailSent: json['emailSent'] as bool? ?? false,
      emailError: json['emailError'] as String?,
      userId: json['userId'] as String?,
      created: json['created'] as String? ?? '',
    );
  }
}
