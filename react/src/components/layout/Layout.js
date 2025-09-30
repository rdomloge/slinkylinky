import React, { useEffect } from 'react';
import Menu from './Menu';
import Footer from './Footer';
import Header from './Header';
import Head from 'next/head'
import { useSession, signIn, signOut } from "next-auth/react"
import TenantWarning from '../tenantWarning';
import TenantBanner from '../TenantBanner';

export default function Layout ({children, pagetitle = " "}) {

    const { data: session, status } = useSession()
    if (session && session.user && status === "authenticated") {
        return(
            <>
            <TenantWarning/>
                <Head>
                    <meta name="robots" content="noindex,nofollow" />
                    <title>{"Slinky Linky | " + pagetitle}</title>
                </Head>
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
    else if(status === "loading") return (
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