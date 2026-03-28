import { Link } from 'react-router-dom';
import Profile from '../Profile';
import Logo from '@/assets/logo.png';

export default function Header({ title, actions }) {
    return (
        <header className="bg-white border-b border-slate-200 sticky top-0 z-30 shadow-sm">
            <div className="flex items-center justify-between px-6 py-2.5 gap-4">

                {/* Breadcrumb: Logo + brand + chevron + page title */}
                <div className="flex items-center gap-2 min-w-0">
                    <Link to="/" className="flex items-center gap-2 shrink-0 text-slate-500 hover:text-indigo-600 transition-colors">
                        <img src={Logo} width={20} height={20} alt="" className="opacity-60"/>
                        <span className="text-sm font-semibold">Slinky Linky</span>
                    </Link>
                    {title && (
                        <>
                            <svg className="w-4 h-4 text-slate-300 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                                <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7"/>
                            </svg>
                            <h1 className="text-sm font-semibold text-slate-800 truncate">{title}</h1>
                        </>
                    )}
                </div>

                {/* Right: actions + profile */}
                <div className="flex items-center gap-4 shrink-0">
                    {actions}
                    <Profile/>
                </div>

            </div>
        </header>
    );
}
