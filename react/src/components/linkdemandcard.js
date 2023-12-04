'use client'

import '@/styles/globals.css'
import CategoriesCard from '@/components/categoriescard'
import Image from 'next/image'
import Icon from '@/components/shoppingcart.png'
import NiceDate from './Date'

export default function LinkDemandCard({linkdemand}) {
    
    if(linkdemand === null) return <p>NULL</p>;
    else {
        return (
            <div className="card list-card">
                <Image src={Icon} width={32} height={32} alt="Shopping cart icon"/>
                <div>{linkdemand.name}</div>
                <div>{linkdemand.url}</div>
                <div>Domain Authority needed {linkdemand.daNeeded}</div>
                <div><NiceDate isostring={linkdemand.requestedDate}/></div>
                <p>Created by {linkdemand.createdBy}</p>
                <CategoriesCard categories={linkdemand.categories}/>
            </div>
        );
***REMOVED***
}