import React, { useEffect } from 'react';
import Menu from './Menu';
import Footer from './Footer';
import Header from './Header';
import { useAuth } from '@/auth/AuthProvider';
import TenantWarning from '../TenantWarning';
import Logo from '@/assets/logo.png';

export default function Layout ({children, pagetitle = " "}) {

    const { user, isAuthenticated, isLoading, signIn } = useAuth()

    useEffect(() => {
        if (pagetitle) {
            document.title = "Slinky Linky | " + pagetitle;
        }
    }, [pagetitle]);

    if (isAuthenticated && user) {
        return(
            <>
            <TenantWarning/>
                <Header/>

                <div className="grid grid-cols-8 gap-2">
                    <div className="">
                        <Menu/>
                    </div>
                    <div className="col-span-7 h-full">
                        {children}
                    </div>
                </div>
                <Footer/>
            </>
        )
    }
    else if(isLoading) return (
        <div className="flex justify-center items-center h-screen">
        Loading...
        </div>
    )
    else return (
        <div className="flex h-screen">
            {/* Left panel – branding */}
            <div className="hidden md:flex md:w-1/2 bg-gradient-to-br from-blue-600 to-blue-900 flex-col justify-between p-12 text-white">
                <div className="flex items-center gap-3">
                    <img src={Logo} width={439/8} height={498/8} alt="Logo" className="brightness-0 invert"/>
                    <span className="text-2xl font-bold tracking-tight">Slinky Linky</span>
                </div>
                <div>
                    <h1 className="text-4xl font-bold leading-snug mb-4">
                        Procurement,<br/>connected.
                    </h1>
                    <p className="text-blue-200 text-lg leading-relaxed">
                        Manage suppliers, demand sites, proposals, and orders — all in one place.
                    </p>
                </div>
                <div className="grid grid-cols-2 gap-4 text-sm text-blue-200">
                    <div className="bg-white/10 rounded-xl p-4">
                        <div className="font-semibold text-white mb-1">Suppliers</div>
                        <div>Search and manage your supplier network</div>
                    </div>
                    <div className="bg-white/10 rounded-xl p-4">
                        <div className="font-semibold text-white mb-1">Proposals</div>
                        <div>Track and compare supplier proposals</div>
                    </div>
                    <div className="bg-white/10 rounded-xl p-4">
                        <div className="font-semibold text-white mb-1">Demand</div>
                        <div>Align demand sites with supply</div>
                    </div>
                    <div className="bg-white/10 rounded-xl p-4">
                        <div className="font-semibold text-white mb-1">Orders</div>
                        <div>Monitor orders end-to-end</div>
                    </div>
                </div>
            </div>

            {/* Right panel – sign in */}
            <div className="flex flex-1 flex-col justify-center items-center bg-gray-50 p-8">
                <div className="w-full max-w-sm">
                    <div className="flex md:hidden items-center gap-2 mb-8">
                        <img src={Logo} width={36} height={36} alt="Logo"/>
                        <span className="text-xl font-bold text-gray-800">Slinky Linky</span>
                    </div>
                    <h2 className="text-3xl font-bold text-gray-900 mb-2">Welcome back</h2>
                    <p className="text-gray-500 mb-8">Sign in to access your workspace.</p>
                    <button
                        onClick={() => signIn()}
                        className="w-full bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white font-semibold px-6 py-3 rounded-lg transition-colors shadow-sm"
                    >
                        Sign in with SSO
                    </button>
                </div>
            </div>
        </div>
    )
}
