// Permission handling based on roles
class Permissions {
  static bool hasPermission(String requiredRole, String currentUserRole) {
    const rolesHierarchy = ["Thành viên dòng họ", "Hội đồng tài chính", "Hội đồng gia tộc"];
    return rolesHierarchy.indexOf(currentUserRole) >= rolesHierarchy.indexOf(requiredRole);
  }
}
