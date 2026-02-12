import '@/styles/globals.css'
import { Link } from 'react-router-dom';
import { AuthorizedAccess } from '../authorizedAccess';

export default function Menu() {
    
    return (
        <div className="pt-5 px-3">
            <div><Link to="/demand" rel='nofollow'>Demand</Link></div>
            <div><Link to="/categories" rel='nofollow'>Categories</Link></div>
            <div><Link to="/supplier" rel='nofollow'>Suppliers</Link></div>
            <div><Link to="/proposals" rel='nofollow'>Proposals</Link></div>
            <div><Link to="/demandsites" rel='nofollow'>Demand Sites</Link></div>
            <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                <div><Link to="/orders" rel='nofollow'>Orders</Link></div>
            </AuthorizedAccess>
            <div><Link to="/audit" rel='nofollow'>Audit</Link></div>
        </div>
    );
}