'use client'

import React from 'react';
import Menu from './Menu';
import Footer from './Footer';
import Header from './Header';

const Layout =({children}) =>{
    
    return(
        <>
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