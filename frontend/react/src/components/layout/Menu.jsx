import { Link, useLocation } from 'react-router-dom';
import { AuthorizedAccess } from '../AuthorizedAccess';

// Entity accent colours for nav items
const ENTITY_COLORS = {
    '/demand':      { active: '#f59e0b', glow: 'rgba(245,158,11,0.25)',  dot: '#f59e0b' },
    '/supplier':    { active: '#10b981', glow: 'rgba(16,185,129,0.25)',  dot: '#10b981' },
    '/demandsites': { active: '#8b5cf6', glow: 'rgba(139,92,246,0.25)', dot: '#8b5cf6' },
    '/proposals':   { active: '#60a5fa', glow: 'rgba(96,165,250,0.25)', dot: '#60a5fa' },
    '/categories':  { active: '#94a3b8', glow: 'rgba(148,163,184,0.2)', dot: '#94a3b8' },
    '/orders':      { active: '#f472b6', glow: 'rgba(244,114,182,0.25)', dot: '#f472b6' },
    '/audit':       { active: '#94a3b8', glow: 'rgba(148,163,184,0.2)', dot: '#94a3b8' },
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
        icon: (
            <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M9.568 3H5.25A2.25 2.25 0 0 0 3 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 0 0 5.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 0 0 9.568 3Z" />
                <path strokeLinecap="round" strokeLinejoin="round" d="M6 6h.008v.008H6V6Z" />
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
        to: '/audit',
        label: 'Audit',
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
                backgroundColor: 'rgba(255,255,255,0.08)',
                borderLeft: `3px solid ${colors.active}`,
                boxShadow: `0 0 12px ${colors.glow}`,
                color: 'white',
                paddingLeft: '9px',
            } : {}}
            className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all duration-150
                ${active
                    ? 'text-white'
                    : 'text-slate-400 hover:text-white hover:bg-white/5 border-l-3 border-transparent'
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
    return (
        <nav className="flex flex-col gap-0.5 pt-3 px-3 pb-4">
            {navItems.filter(i => !i.adminOnly).map(item => (
                <NavItem key={item.to} {...item} />
            ))}
            <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                <div className="my-2 border-t border-white/10"/>
                <NavItem {...navItems.find(i => i.adminOnly)} />
            </AuthorizedAccess>
        </nav>
    );
}
