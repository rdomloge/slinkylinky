import React, { useEffect } from 'react';
import Menu from './Menu';
import Footer from './Footer';
import Header from './Header';
import { useAuth } from '@/auth/AuthProvider';
import TenantWarning from '../TenantWarning';
import Logo from '@/assets/logo.png';

export default function Layout ({children, pagetitle = " ", headerTitle, headerActions}) {

    const { user, isAuthenticated, isLoading, signIn } = useAuth()

    useEffect(() => {
        if (pagetitle) {
            document.title = "Slinky Linky | " + pagetitle;
        }
    }, [pagetitle]);

    if (isAuthenticated && user) {
        return(
            <div className="flex flex-col h-screen">
                <TenantWarning/>
                <div className="flex flex-1 overflow-hidden">
                    {/* Sidebar */}
                    <aside className="w-56 shrink-0 flex flex-col border-r border-white/5 overflow-y-auto"
                           style={{background: 'linear-gradient(180deg, #0f172a 0%, #1e1b4b 100%)'}}>
                        {/* Brand */}
                        <a href="/" className="flex items-center gap-3 px-4 py-[1.1rem] shrink-0 border-b border-white/10 hover:bg-white/5 transition-colors group">
                            <img src={Logo} width={Math.round(439/10)} height={Math.round(498/10)} alt="Logo" className="brightness-0 invert opacity-80 group-hover:opacity-100 transition-opacity"/>
                            <span className="text-white font-extrabold text-base tracking-tight" style={{fontFamily: "'Outfit', sans-serif", letterSpacing: '-0.03em'}}>
                                Slinky<span style={{color: '#a78bfa'}}>Linky</span>
                            </span>
                        </a>
                        <Menu/>
                    </aside>
                    {/* Main content area */}
                    <div className="flex flex-col flex-1 min-w-0" style={{background: '#f0f2f7'}}>
                        <Header title={headerTitle ?? pagetitle} actions={headerActions}/>
                        <div className="flex-1 overflow-y-auto pt-4">
                            {children}
                            <Footer/>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
    else if(isLoading) return (
        <div className="flex justify-center items-center h-screen bg-slate-50">
            <div className="flex gap-2">
                <span className="w-2 h-2 bg-indigo-500 rounded-full animate-bounce [animation-delay:-0.3s]"/>
                <span className="w-2 h-2 bg-indigo-500 rounded-full animate-bounce [animation-delay:-0.15s]"/>
                <span className="w-2 h-2 bg-indigo-500 rounded-full animate-bounce"/>
            </div>
        </div>
    )
    else return (
        <div className="flex h-screen">
            {/* Left panel – branding */}
            <div className="hidden md:flex md:w-1/2 bg-gradient-to-br from-slate-900 via-slate-800 to-indigo-900 flex-col justify-between p-12 text-white">
                <div className="flex items-center gap-3">
                    <img src={Logo} width={439/8} height={498/8} alt="Logo" className="brightness-0 invert"/>
                    <span className="text-2xl font-bold tracking-tight">Slinky Linky</span>
                </div>
                <div>
                    <h1 className="text-4xl font-bold leading-snug mb-4">
                        Links,<br/>connected.
                    </h1>
                    <p className="text-slate-300 text-lg leading-relaxed">
                        Manage suppliers, demand sites, proposals, and orders — all in one place.
                    </p>
                </div>
                <div className="grid grid-cols-2 gap-4 text-sm text-slate-300">
                    <div className="bg-white/10 rounded-xl p-4 backdrop-blur-sm">
                        <div className="font-semibold text-white mb-1">Suppliers</div>
                        <div>Search and manage your supplier network</div>
                    </div>
                    <div className="bg-white/10 rounded-xl p-4 backdrop-blur-sm">
                        <div className="font-semibold text-white mb-1">Proposals</div>
                        <div>Track and compare supplier proposals</div>
                    </div>
                    <div className="bg-white/10 rounded-xl p-4 backdrop-blur-sm">
                        <div className="font-semibold text-white mb-1">Demand</div>
                        <div>Align demand sites with supply</div>
                    </div>
                    <div className="bg-white/10 rounded-xl p-4 backdrop-blur-sm">
                        <div className="font-semibold text-white mb-1">Orders</div>
                        <div>Monitor orders end-to-end</div>
                    </div>
                </div>
            </div>

            {/* Right panel – sign in */}
            <div className="flex flex-1 flex-col justify-center items-center bg-slate-50 p-8">
                <div className="w-full max-w-sm">
                    <div className="flex md:hidden items-center gap-2 mb-8">
                        <img src={Logo} width={36} height={36} alt="Logo"/>
                        <span className="text-xl font-bold text-gray-800">Slinky Linky</span>
                    </div>
                    <h2 className="text-3xl font-bold text-slate-900 mb-2">Welcome back</h2>
                    <p className="text-slate-500 mb-8">Sign in to access your workspace.</p>
                    <button
                        onClick={() => signIn()}
                        className="w-full bg-indigo-600 hover:bg-indigo-700 active:bg-indigo-800 text-white font-semibold px-6 py-3 rounded-lg transition-colors shadow-sm"
                    >
                        Sign in with SSO
                    </button>
                </div>
            </div>
        </div>
    )
}
