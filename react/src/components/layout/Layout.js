'use client'

import React from 'react';
import Menu from './Menu';
import Footer from './Footer';
import Header from './Header';
import Script from 'next/script';

const Layout =({children}) =>{
    
    return(
        <>
            <Script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.min.js"/>
            

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

export default Layout;