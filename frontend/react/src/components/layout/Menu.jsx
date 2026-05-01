import { Link, useLocation } from 'react-router-dom';
import { AuthorizedAccess } from '../AuthorizedAccess';
import { useAuth } from '@/auth/AuthProvider';
import { ORDERS_ENABLED } from '@/config';

// Entity accent colours for nav items (updated to pastel palette)
const ENTITY_COLORS = {
    '/demand':         { active: '#d4a574', glow: 'rgba(212, 165, 116, 0.15)', dot: '#d4a574' },
    '/supplier':       { active: '#6db89d', glow: 'rgba(109, 184, 157, 0.15)', dot: '#6db89d' },
    '/demandsites':    { active: '#a89dbd', glow: 'rgba(168, 157, 189, 0.15)', dot: '#a89dbd' },
    '/proposals':      { active: '#8dcbb3', glow: 'rgba(141, 203, 179, 0.15)', dot: '#8dcbb3' },
    '/categories':     { active: '#a89dbd', glow: 'rgba(168, 157, 189, 0.1)', dot: '#a89dbd' },
    '/orders':         { active: '#d4a574', glow: 'rgba(212, 165, 116, 0.15)', dot: '#d4a574' },
    '/audit':          { active: '#8dcbb3', glow: 'rgba(141, 203, 179, 0.1)', dot: '#8dcbb3' },
    '/organisations':  { active: '#a89dbd', glow: 'rgba(168, 157, 189, 0.15)', dot: '#a89dbd' },
    '/admin/organisations': { active: '#8dcbb3', glow: 'rgba(141, 203, 179, 0.1)', dot: '#8dcbb3' },
    '/users':          { active: '#d4a574', glow: 'rgba(212, 165, 116, 0.15)', dot: '#d4a574' },
    '/leads':          { active: '#a89dbd', glow: 'rgba(168, 157, 189, 0.15)', dot: '#a89dbd' },
    '/category-mappings': { active: '#6db89d', glow: 'rgba(109, 184, 157, 0.15)', dot: '#6db89d' },
};

const navItems = [
    {
        to: '/demand',
        label: 'Demand',
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 0 0-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 0 0-16.536-1.84M7.5 14.25 5.106 5.272M6 20.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Zm12.75 0a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Z" />
            </svg>
        ),
    },
    {
        to: '/categories',
        label: 'Categories',
        adminOnly: true,
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M9.568 3H5.25A2.25 2.25 0 0 0 3 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 0 0 5.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 0 0 9.568 3Z" />
                <path strokeLinecap="round" strokeLinejoin="round" d="M6 6h.008v.008H6V6Z" />
            </svg>
        ),
    },
    {
        to: '/organisations',
        label: 'Organisations',
        adminOnly: true,
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 21h16.5M4.5 3h15M5.25 3v18m13.5-18v18M9 6.75h1.5m-1.5 3h1.5m-1.5 3h1.5m3-6H15m-1.5 3H15m-1.5 3H15M9 21v-3.375c0-.621.504-1.125 1.125-1.125h3.75c.621 0 1.125.504 1.125 1.125V21" />
            </svg>
        ),
    },
    {
        to: '/admin/organisations',
        label: 'Org Overview',
        adminOnly: true,
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 3v11.25A2.25 2.25 0 0 0 6 16.5h2.25M3.75 3h-1.5m1.5 0h16.5m0 0h1.5m-1.5 0v11.25A2.25 2.25 0 0 1 18 16.5h-2.25m-7.5 0h7.5m-7.5 0-1 3m8.5-3 1 3m0 0 .5 1.5m-.5-1.5h-9.5m0 0-.5 1.5M9 11.25v1.5M12 9v3.75m3-6v6" />
            </svg>
        ),
    },
    {
        to: '/supplier',
        label: 'Suppliers',
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z" />
            </svg>
        ),
    },
    {
        to: '/proposals',
        label: 'Proposals',
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z" />
            </svg>
        ),
    },
    {
        to: '/demandsites',
        label: 'Demand Sites',
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
                <path strokeLinecap="round" strokeLinejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z" />
            </svg>
        ),
    },
    {
        to: '/users',
        label: 'Users',
        tenantAdminOnly: true,
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M15 19.128a9.38 9.38 0 0 0 2.625.372 9.337 9.337 0 0 0 4.121-.952 4.125 4.125 0 0 0-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 0 1 8.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0 1 11.964-3.07M12 6.375a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0Zm8.25 2.25a2.625 2.625 0 1 1-5.25 0 2.625 2.625 0 0 1 5.25 0Z" />
            </svg>
        ),
    },
    {
        to: '/orders',
        label: 'Orders',
        adminOnly: true,
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="m21 7.5-9-5.25L3 7.5m18 0-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
            </svg>
        ),
    },
    {
        to: '/leads',
        label: 'Leads',
        adminOnly: true,
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M6 12 3.269 3.125A59.769 59.769 0 0 1 21.485 12 59.768 59.768 0 0 1 3.27 20.875L5.999 12Zm0 0h7.5" />
            </svg>
        ),
    },
    {
        to: '/category-mappings',
        label: 'Cat. Mappings',
        adminOnly: true,
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M7.5 21 3 16.5m0 0L7.5 12M3 16.5h13.5m0-13.5L21 7.5m0 0L16.5 12M21 7.5H7.5" />
            </svg>
        ),
    },
    {
        to: '/audit',
        label: 'Audit',
        tenantAdminOnly: true,
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z" />
            </svg>
        ),
    },
];

function NavItem({ to, label, icon }) {
    const { pathname } = useLocation();
    const active = pathname === to || pathname.startsWith(to + '/');
    const colors = ENTITY_COLORS[to] || ENTITY_COLORS['/categories'];

    return (
        <Link
            to={to}
            rel="nofollow"
            style={active ? {
                backgroundColor: `rgba(${colors.active.match(/\w\w/g).map(x => parseInt(x, 16)).join(', ')}, 0.1)`,
                borderLeft: `3px solid ${colors.active}`,
                boxShadow: `0 0 12px ${colors.glow}`,
                color: 'var(--text-primary)',
                paddingLeft: '9px',
            } : {}}
            className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all duration-150
                ${active
                    ? 'text-slate-900'
                    : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100/50 border-l-3 border-transparent'
                }`}
        >
            <span style={active ? {color: colors.active} : {}} className={`shrink-0 transition-colors ${!active ? 'text-slate-500' : ''}`}>
                {icon}
            </span>
            <span>{label}</span>
            {active && (
                <span className="ml-auto w-1.5 h-1.5 rounded-full shrink-0" style={{backgroundColor: colors.dot}}/>
            )}
        </Link>
    );
}

export default function Menu() {
    const { user } = useAuth();
    const isGlobalAdmin = user?.roles?.includes('global_admin');
    const isAdmin = isGlobalAdmin || user?.roles?.includes('tenant_admin');

    const publicItems = navItems.filter(i => !i.adminOnly && !i.tenantAdminOnly);
    const ordersItem = navItems.find(i => i.to === '/orders');
    const tenantAdminItems = navItems.filter(i => i.tenantAdminOnly);
    const globalAdminItems = navItems.filter(i => i.adminOnly && i.to !== '/orders');

    return (
        <nav className="flex flex-col gap-0.5 pt-3 px-3 pb-4">
            {publicItems.map(item => (
                <NavItem key={item.to} {...item} />
            ))}
            {isAdmin && (
                <>
                    <div className="my-2" style={{ borderTopColor: 'var(--border-light)', borderTopWidth: '1px' }} />
                    {tenantAdminItems.map(item => (
                        <NavItem key={item.to} {...item} />
                    ))}
                </>
            )}
            {isGlobalAdmin && (
                <>
                    {ORDERS_ENABLED && <NavItem {...ordersItem} />}
                    {globalAdminItems.map(item => (
                        <NavItem key={item.to} {...item} />
                    ))}
                </>
            )}
        </nav>
    );
}
