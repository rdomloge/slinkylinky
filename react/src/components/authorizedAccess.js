import { jwtDecode } from 'jwt-decode';
import { useSession } from 'next-auth/react';

export function AuthorizedAccess({ allowedRoles, children }) {
    const { data: session } = useSession();
    const decodedToken = session ? jwtDecode(session.accessToken) : null;
    const userRoles = decodedToken ? decodedToken.realm_access.roles : [];

    if (!userRoles.some(role => allowedRoles.includes(role))) {
        return null;
    }

    return children;
}