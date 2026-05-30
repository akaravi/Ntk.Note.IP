using System.Security.Claims;
using Ntk.Note.IP.Application.Admin;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Domain.Constants;
using Ntk.Note.IP.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Ntk.Note.IP.Infrastructure.Identity;

public class AdminRoleService : IAdminRoleService
{
    private readonly RoleManager<IdentityRole> _roleManager;
    private readonly UserManager<ApplicationUser> _userManager;

    public AdminRoleService(RoleManager<IdentityRole> roleManager, UserManager<ApplicationUser> userManager)
    {
        _roleManager = roleManager;
        _userManager = userManager;
    }

    public async Task<IReadOnlyList<AdminRoleDto>> GetListAsync(CancellationToken cancellationToken)
    {
        var roles = await _roleManager.Roles
            .AsNoTracking()
            .OrderBy(role => role.Name)
            .ToListAsync(cancellationToken);

        var result = new List<AdminRoleDto>(roles.Count);

        foreach (var role in roles)
        {
            if (string.IsNullOrWhiteSpace(role.Name))
            {
                continue;
            }

            var trackedRole = await _roleManager.FindByIdAsync(role.Id);
            if (trackedRole is null)
            {
                continue;
            }

            var permissions = await GetPermissionClaimsAsync(trackedRole);
            var members = await _userManager.GetUsersInRoleAsync(trackedRole.Name!);

            result.Add(new AdminRoleDto
            {
                Id = trackedRole.Id,
                Name = trackedRole.Name!,
                UserCount = members.Count,
                Permissions = permissions,
                IsSystem = Roles.SystemRoles.Contains(trackedRole.Name, StringComparer.OrdinalIgnoreCase),
            });
        }

        return result;
    }

    public IReadOnlyList<AdminPermissionCatalogItemDto> GetPermissionCatalog()
    {
        return Permissions.All
            .Select(key => new AdminPermissionCatalogItemDto
            {
                Key = key,
                GroupKey = ResolveGroupKey(key),
            })
            .ToList();
    }

    public async Task<Result> AddAsync(
        string name,
        IReadOnlyList<string> permissions,
        CancellationToken cancellationToken)
    {
        var normalizedName = name.Trim();
        if (string.IsNullOrWhiteSpace(normalizedName))
        {
            return Result.Failure(["Role name is required."]);
        }

        if (await _roleManager.RoleExistsAsync(normalizedName))
        {
            return Result.Failure(["Role already exists."]);
        }

        var createResult = await _roleManager.CreateAsync(new IdentityRole(normalizedName));
        if (!createResult.Succeeded)
        {
            return createResult.ToApplicationResult();
        }

        var role = await _roleManager.FindByNameAsync(normalizedName);
        if (role is null)
        {
            return Result.Failure(["Role was created but could not be loaded."]);
        }

        return await ReplacePermissionClaimsAsync(role, permissions, cancellationToken);
    }

    public async Task<Result> UpdatePermissionsAsync(
        string roleId,
        IReadOnlyList<string> permissions,
        CancellationToken cancellationToken)
    {
        var role = await _roleManager.FindByIdAsync(roleId);
        if (role is null)
        {
            return Result.Failure(["Role not found."]);
        }

        return await ReplacePermissionClaimsAsync(role, permissions, cancellationToken);
    }

    public async Task<Result> DeleteAsync(string roleId, CancellationToken cancellationToken)
    {
        var role = await _roleManager.FindByIdAsync(roleId);
        if (role is null)
        {
            return Result.Failure(["Role not found."]);
        }

        if (!string.IsNullOrWhiteSpace(role.Name)
            && Roles.SystemRoles.Contains(role.Name, StringComparer.OrdinalIgnoreCase))
        {
            return Result.Failure(["System roles cannot be deleted."]);
        }

        var members = await _userManager.GetUsersInRoleAsync(role.Name!);
        if (members.Count > 0)
        {
            return Result.Failure(["Remove all users from this role before deleting it."]);
        }

        var deleteResult = await _roleManager.DeleteAsync(role);
        return deleteResult.ToApplicationResult();
    }

    public static async Task EnsureRolePermissionsAsync(
        RoleManager<IdentityRole> roleManager,
        IdentityRole role,
        IReadOnlyList<string> permissions,
        CancellationToken cancellationToken)
    {
        var existing = await roleManager.GetClaimsAsync(role);
        var existingPermissions = existing
            .Where(claim => claim.Type == PermissionClaimTypes.Permission && claim.Value != null)
            .Select(claim => claim.Value!)
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        foreach (var permission in permissions.Where(Permissions.All.Contains))
        {
            if (!existingPermissions.Contains(permission))
            {
                await roleManager.AddClaimAsync(role, new Claim(PermissionClaimTypes.Permission, permission));
            }
        }
    }

    private async Task<Result> ReplacePermissionClaimsAsync(
        IdentityRole role,
        IReadOnlyList<string> permissions,
        CancellationToken cancellationToken)
    {
        var normalizedPermissions = permissions
            .Where(permission => Permissions.All.Contains(permission))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToList();

        var existingClaims = await _roleManager.GetClaimsAsync(role);
        var permissionClaims = existingClaims
            .Where(claim => claim.Type == PermissionClaimTypes.Permission)
            .ToList();

        foreach (var claim in permissionClaims)
        {
            var removeResult = await _roleManager.RemoveClaimAsync(role, claim);
            if (!removeResult.Succeeded)
            {
                return removeResult.ToApplicationResult();
            }
        }

        foreach (var permission in normalizedPermissions)
        {
            var addResult = await _roleManager.AddClaimAsync(
                role,
                new Claim(PermissionClaimTypes.Permission, permission));
            if (!addResult.Succeeded)
            {
                return addResult.ToApplicationResult();
            }
        }

        return Result.Success();
    }

    private async Task<IReadOnlyList<string>> GetPermissionClaimsAsync(IdentityRole role)
    {
        var claims = await _roleManager.GetClaimsAsync(role);
        return claims
            .Where(claim => claim.Type == PermissionClaimTypes.Permission && claim.Value != null)
            .Select(claim => claim.Value!)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .OrderBy(permission => permission, StringComparer.OrdinalIgnoreCase)
            .ToList();
    }

    private static string ResolveGroupKey(string permissionKey)
    {
        if (permissionKey.StartsWith("admin.dashboard.", StringComparison.Ordinal))
        {
            return "ADMIN.PERMS.GROUP_DASHBOARD";
        }

        if (permissionKey.StartsWith("admin.users.", StringComparison.Ordinal))
        {
            return "ADMIN.PERMS.GROUP_USERS";
        }

        if (permissionKey.StartsWith("admin.roles.", StringComparison.Ordinal))
        {
            return "ADMIN.PERMS.GROUP_ROLES";
        }

        if (permissionKey.StartsWith("admin.ipnotes.", StringComparison.Ordinal))
        {
            return "ADMIN.PERMS.GROUP_IP_NOTES";
        }

        if (permissionKey.StartsWith("admin.iplookups.", StringComparison.Ordinal))
        {
            return "ADMIN.PERMS.GROUP_IP_LOOKUPS";
        }

        if (permissionKey.StartsWith("admin.push.", StringComparison.Ordinal))
        {
            return "ADMIN.PERMS.GROUP_PUSH";
        }

        if (permissionKey.StartsWith("admin.outbox.", StringComparison.Ordinal))
        {
            return "ADMIN.PERMS.GROUP_OUTBOX";
        }

        return "ADMIN.PERMS.GROUP_OTHER";
    }
}
