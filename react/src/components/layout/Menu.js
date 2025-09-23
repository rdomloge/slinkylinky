'use client'

import '@/styles/globals.css'
import Link from 'next/link';
import { AuthorizedAccess } from '../authorizedAccess';

export default function Menu() {
    
    return (
        <div className="pt-5 px-3">
            <div><Link href="/demand" rel='nofollow'>Demand</Link></div>
            <div><Link href="/categories" rel='nofollow'>Categories</Link></div>
            <div><Link href="/supplier" rel='nofollow'>Suppliers</Link></div>
            <div><Link href="/proposals" rel='nofollow'>Proposals</Link></div>
            <div><Link href="/demandsites" rel='nofollow'>Demand Sites</Link></div>
            <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                <div><Link href="/orders" rel='nofollow'>Orders</Link></div>
            </AuthorizedAccess>
            <div><Link href="/audit" rel='nofollow'>Audit</Link></div>
        </div>
    );
}