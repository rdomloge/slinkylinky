import { jwtDecode } from 'jwt-decode';
import { useAuth } from '@/auth/AuthProvider';

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