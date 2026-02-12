import React, { useEffect } from 'react';
import Menu from './Menu';
import Footer from './Footer';
import Header from './Header';
import { useAuth } from '@/auth/AuthProvider';
import TenantWarning from '../tenantWarning';

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
        <div className="flex flex-col justify-center items-center h-screen">
            Not signed in <br />
            <button onClick={() => signIn()} className='bg-blue-500 text-white px-4 py-2 rounded'>Sign in</button>
        </div>
    )
}
