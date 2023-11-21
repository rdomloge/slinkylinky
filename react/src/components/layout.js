'use client'

import React from 'react';
import Menu from './menu';
import Image from 'next/image'
import Icon from '@/components/logo.png'

const Layout =({children}) =>{
    return(
        <>
            <Image src={Icon} width={377/3} height={119/3} alt="Logo" className="p-1"/>
            <div className="grid grid-cols-6 gap-4">
                <div className="">
                    <Menu/>         
                </div>
                <div className="col-span-5">
                    {children}
                </div>
            </div>
            <div>This is the footer</div>
        </>
    )
}

export default Layout;