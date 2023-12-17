'use client'

import React from 'react';
import Menu from './Menu';
import Image from 'next/image'
import Icon from '@/components/logo.png'
import Profile from './profile';

const Layout =({children}) =>{
    
    return(
        <>
            <div className='grid grid-cols-2'>
                <Image src={Icon} width={377/3} height={119/3} alt="Logo" className="p-1 inline-block"/>
                <Profile/>
            </div>
            <div className="grid grid-cols-8 gap-2">
                <div className="">
                    <Menu/>         
                </div>
                <div className="col-span-7">
                    {children}
                </div>
            </div>
            <div>This is the footer</div>
        </>
    )
}

export default Layout;