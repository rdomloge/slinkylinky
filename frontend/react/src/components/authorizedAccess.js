import { jwtDecode } from 'jwt-decode';
import { useSession } from 'next-auth/react';

export function AuthorizedAccess({ 
    allowedRoles, 
    children, 
    unauthorizedContent = null 
}) {
    const { data: session } = useSession();
    const decodedToken = session ? jwtDecode(session.accessToken) : null;
    const userRoles = decodedToken ? decodedToken.realm_access.roles : [];

    const isAuthorized = userRoles.some(role => allowedRoles.includes(role));

    if (!isAuthorized) {
        return unauthorizedContent;
    }

    return children;
}