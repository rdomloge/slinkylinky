import { jwtDecode } from 'jwt-decode';
import { useAuth } from '@/auth/AuthProvider';
import { useMemo } from 'react';

const ADMIN_ROLES = ['tenant_admin', 'global_admin'];

export function useIsAdmin() {
    const { accessToken } = useAuth();
    const decodedToken = accessToken ? jwtDecode(accessToken) : null;
    const userRoles = decodedToken ? decodedToken.realm_access.roles : [];

    return useMemo(() => userRoles.some(role => ADMIN_ROLES.includes(role)), [accessToken]);
}

export function AuthorizedAccess({ 
    allowedRoles, 
    children, 
    unauthorizedContent = null 
}) {
    const { accessToken } = useAuth();
    const decodedToken = accessToken ? jwtDecode(accessToken) : null;
    const userRoles = decodedToken ? decodedToken.realm_access.roles : [];

    const isAuthorized = userRoles.some(role => allowedRoles.includes(role));

    if (!isAuthorized) {
        return unauthorizedContent;
    }

    return children;
}